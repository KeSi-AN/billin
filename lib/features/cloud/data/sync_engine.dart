import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/db/sync_schema.dart';
import 'package:shop_app/features/cloud/domain/cloud.dart';
import 'package:shop_app/features/cloud/domain/sync.dart';

/// Runs [SyncEngine] while the app is open: on start and on return to
/// the app, every [every] while it stays open, and once more when the
/// user leaves (so the last bills go up).
class SyncScheduler {
  SyncScheduler(this._engine, {this.every = const Duration(minutes: 1)});

  final SyncEngine _engine;
  final Duration every;
  Timer? _timer;
  AppLifecycleListener? _lifecycle;

  void start() {
    _lifecycle = AppLifecycleListener(onResume: _resume, onPause: _pause);
    _resume();
  }

  void _resume() {
    unawaited(_engine.syncNow());
    _timer?.cancel();
    _timer = Timer.periodic(every, (_) => unawaited(_engine.syncNow()));
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    unawaited(_engine.syncNow());
  }

  void dispose() {
    _timer?.cancel();
    _lifecycle?.dispose();
  }
}

/// Keeps this phone's database and the shop's cloud rows in step:
/// sends what changed here (the outbox), then applies what other phones
/// sent. Every phone keeps working offline; this catches up when it can.
class SyncEngine {
  SyncEngine(
    this._db,
    this._remote,
    this._link, {
    this._clock = DateTime.now,
    this.pageSize = 500,
  });

  final AppDatabase _db;
  final SyncRemote _remote;
  final Future<CloudLink?> Function() _link;
  final DateTime Function() _clock;
  final int pageSize;

  /// Rows re-read below the last applied number each time: the server
  /// numbers rows when they are written, so a row written slightly earlier
  /// can become visible after a later one. Applying a row twice is
  /// harmless.
  static const _overlap = 100;

  final ValueNotifier<SyncStatus> status = ValueNotifier(const SyncStatus());

  Future<void>? _running;
  bool _again = false;
  final _columns = <String, List<String>>{};

  /// Syncs now; if a sync is already running, one more follows it.
  Future<void> syncNow() {
    if (_running != null) {
      _again = true;
      return _running!;
    }
    return _running = _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    do {
      _again = false;
      await _once();
    } while (_again);
  }

  Future<void> _once() async {
    final link = await _link();
    if (link == null) return;
    status.value = status.value.copyWith(running: true);
    try {
      await _push(link);
      await _pull(link);
      status.value = status.value.copyWith(
        running: false,
        lastSyncedAt: _clock(),
        pending: await _pendingCount(),
        clearError: true,
      );
    } on Object catch (e) {
      status.value = status.value.copyWith(
        running: false,
        pending: await _pendingCount(),
        error: '$e',
      );
    }
  }

  Future<int> _pendingCount() async =>
      (await _db
              .customSelect('SELECT COUNT(*) AS n FROM sync_outbox')
              .getSingle())
          .read<int>('n');

  // ---------------------------------------------------------------- push

  Future<void> _push(CloudLink link) async {
    final rank = {for (final (i, t) in syncTables.indexed) t.name: i};
    while (true) {
      final queued = await _db
          .customSelect(
            'SELECT id, tbl, row_id FROM sync_outbox ORDER BY id LIMIT ?',
            variables: [Variable.withInt(pageSize)],
          )
          .get();
      if (queued.isEmpty) return;
      // Parents before children, so another phone can resolve links.
      queued.sort(
        (a, b) => (rank[a.read<String>('tbl')] ?? 99).compareTo(
          rank[b.read<String>('tbl')] ?? 99,
        ),
      );
      final rows = <CloudRow>[];
      for (final q in queued) {
        final name = q.read<String>('tbl');
        final table = syncTables.where((t) => t.name == name).firstOrNull;
        if (table == null) continue;
        final row = await _encode(table, q.read<int>('row_id'));
        if (row != null) rows.add(row);
      }
      if (rows.isNotEmpty) await _remote.push(link.shopId, link.deviceId, rows);
      // Only the entries sent: a row changed meanwhile has a new entry.
      final ids = [for (final q in queued) q.read<int>('id')];
      await _db.customStatement(
        'DELETE FROM sync_outbox WHERE id IN (${ids.join(',')})',
      );
      status.value = status.value.copyWith(pending: await _pendingCount());
    }
  }

  Future<CloudRow?> _encode(SyncTable t, int id) async {
    final row = await _db
        .customSelect(
          'SELECT * FROM ${t.name} WHERE id = ?',
          variables: [Variable.withInt(id)],
        )
        .getSingleOrNull();
    if (row == null) return null;
    final data = <String, Object?>{};
    for (final c in await _shared(t)) {
      var v = row.data[c];
      final ref = t.refs[c];
      if (ref != null && v != null) v = await _uidOf(ref, v as int);
      data[c] = v;
    }
    final rowId = t.single ? 'shop' : row.data['uid'] as String?;
    if (rowId == null) return null;
    return CloudRow(tbl: t.name, rowId: rowId, data: data);
  }

  // ---------------------------------------------------------------- pull

  Future<void> _pull(CloudLink link) async {
    final from = await _pulledSeq();
    final rows = <CloudRow>[];
    var after = math.max(0, from - _overlap);
    while (true) {
      final page = await _remote.pull(
        link.shopId,
        after: after,
        limit: pageSize,
      );
      rows.addAll(page);
      if (page.length < pageSize) break;
      after = page.last.seq;
    }
    if (rows.isEmpty) return;
    final top = rows.map((r) => r.seq).reduce(math.max);

    final rank = {for (final (i, t) in syncTables.indexed) t.name: i};
    final ordered = [...rows]
      ..sort((a, b) {
        final byTable = (rank[a.tbl] ?? 99).compareTo(rank[b.tbl] ?? 99);
        return byTable != 0 ? byTable : a.seq.compareTo(b.seq);
      });

    final touched = <String>{};
    int? stuckAt;
    await _db.transaction(() async {
      await _db.customStatement(
        'UPDATE sync_state SET applying = 1 WHERE id = 1',
      );
      try {
        var waiting = ordered;
        // A row linking to one that hasn't arrived yet waits a round.
        while (waiting.isNotEmpty) {
          final later = <CloudRow>[];
          for (final r in waiting) {
            if (await _apply(r)) {
              touched.add(r.tbl);
            } else {
              later.add(r);
            }
          }
          if (later.length == waiting.length) break;
          waiting = later;
        }
        // Still waiting after everything fetched was placed: the row it
        // links to isn't coming (e.g. a batch both phones created). Optional
        // links are left empty rather than holding up sync forever.
        if (waiting.isNotEmpty) {
          final later = <CloudRow>[];
          for (final r in waiting) {
            if (await _apply(r, lenient: true)) {
              touched.add(r.tbl);
            } else {
              later.add(r);
            }
          }
          waiting = later;
        }
        if (waiting.isNotEmpty) {
          stuckAt = waiting.map((r) => r.seq).reduce(math.min);
        }
        // Rows that still can't be placed are read again next time.
        final done = stuckAt == null
            ? math.max(top, from)
            : math.max(from, stuckAt! - 1);
        await _db.customStatement(
          'UPDATE sync_state SET pulled_seq = ? WHERE id = 1',
          [done],
        );
      } finally {
        await _db.customStatement(
          'UPDATE sync_state SET applying = 0 WHERE id = 1',
        );
      }
    });
    if (touched.isNotEmpty) {
      // Screens watching these tables (and stock/balance totals) refresh.
      _db.notifyUpdates({
        for (final t in {
          ...touched,
          'items',
          'parties',
          'item_batches',
          'item_sizes',
        })
          TableUpdate(t),
      });
    }
  }

  Future<int> _pulledSeq() async =>
      (await _db
              .customSelect('SELECT pulled_seq FROM sync_state WHERE id = 1')
              .getSingleOrNull())
          ?.read<int>('pulled_seq') ??
      0;

  /// Applies one cloud row; `false` if it links to a row not here yet
  /// ([lenient]: unless that link may be empty, which it then is).
  Future<bool> _apply(CloudRow r, {bool lenient = false}) async {
    final t = syncTables.where((t) => t.name == r.tbl).firstOrNull;
    if (t == null) return true; // from a newer app version: skip
    final values = <String, Object?>{};
    for (final c in await _shared(t)) {
      if (!r.data.containsKey(c)) continue; // older sender: keep default
      var v = r.data[c];
      final ref = t.refs[c];
      if (ref != null && v != null) {
        final id = await _localId(ref, v as String);
        if (id == null && !(lenient && await _nullable(t, c))) return false;
        v = id;
      }
      values[c] = v;
    }

    if (t.single) {
      final exists = await _db
          .customSelect('SELECT id FROM ${t.name} WHERE id = 1')
          .getSingleOrNull();
      if (exists == null) {
        await _insert(t, {'id': 1, ...values});
      } else if (!await _isPending(t.name, 1)) {
        await _update(t, 1, values);
      }
      return true;
    }

    final localId = await _localId(t.name, r.rowId);
    if (t.ledger) {
      if (localId != null) return true; // already counted
      final id = await _insert(t, {...values, 'uid': r.rowId});
      if (id > 0) await _post(t, id, values);
      return true;
    }
    if (localId == null) {
      await _insert(t, {...values, 'uid': r.rowId});
    } else if (!await _isPending(t.name, localId)) {
      // A change made here and not yet sent wins until it is sent.
      await _update(t, localId, values);
    }
    return true;
  }

  /// A ledger row from another phone: add it to the running totals.
  Future<void> _post(SyncTable t, int id, Map<String, Object?> v) async {
    if (t.name == 'stock_movements') {
      final item = v['item_id'] as int?;
      final batch = v['batch_id'] as int?;
      final q = (v['quantity_milli'] as num?)?.toInt() ?? 0;
      if (item == null) return;
      await _db.customStatement(
        'UPDATE items SET stock_milli = stock_milli + ? WHERE id = ?',
        [q, item],
      );
      if (batch != null) {
        await _db.customStatement(
          'UPDATE item_batches SET quantity_milli = quantity_milli + ? '
          'WHERE id = ?',
          [q, batch],
        );
      }
      final size = v['size_id'] as int?;
      if (size != null) {
        await _db.customStatement(
          'UPDATE item_sizes SET stock_milli = stock_milli + ? WHERE id = ?',
          [q, size],
        );
      }
      await _db.customStatement(
        'UPDATE stock_movements SET balance_after_milli = '
        '(SELECT stock_milli FROM items WHERE id = ?) WHERE id = ?',
        [item, id],
      );
    } else if (t.name == 'party_entries') {
      final party = v['party_id'] as int?;
      final amount = (v['amount_paise'] as num?)?.toInt() ?? 0;
      if (party == null) return;
      await _db.customStatement(
        'UPDATE parties SET balance_paise = balance_paise + ? WHERE id = ?',
        [amount, party],
      );
      await _db.customStatement(
        'UPDATE party_entries SET balance_after_paise = '
        '(SELECT balance_paise FROM parties WHERE id = ?) WHERE id = ?',
        [party, id],
      );
    }
  }

  Future<int> _insert(SyncTable t, Map<String, Object?> values) async {
    // Totals start at zero (ledger rows add up to them); paths stay empty.
    final row = {
      for (final c in t.localOnly)
        c: c.endsWith('_milli') || c.endsWith('_paise') ? 0 : null,
      ...values,
    };
    Future<int> run(Map<String, Object?> r) => _db.customInsert(
      'INSERT INTO ${t.name} (${r.keys.join(', ')}) '
      'VALUES (${List.filled(r.length, '?').join(', ')})',
      variables: [for (final v in r.values) _variable(v)],
    );
    try {
      return await run(row);
    } on Object catch (e) {
      // Both phones gave different items the same barcode: keep the item,
      // drop the clashing barcode here.
      if (t.name == 'items' && '$e'.contains('items.barcode')) {
        return await run({...row, 'barcode': null});
      }
      // The same batch made on both phones: keep the one here.
      if (t.name == 'item_batches' && '$e'.contains('item_batches.')) {
        return -1;
      }
      rethrow;
    }
  }

  Future<void> _update(SyncTable t, int id, Map<String, Object?> v) async {
    if (v.isEmpty) return;
    Future<void> run(Map<String, Object?> r) => _db.customUpdate(
      'UPDATE ${t.name} SET ${r.keys.map((c) => '$c = ?').join(', ')} '
      'WHERE id = ?',
      variables: [for (final x in r.values) _variable(x), Variable.withInt(id)],
    );
    try {
      await run(v);
    } on Object catch (e) {
      if (t.name == 'items' && '$e'.contains('items.barcode')) {
        return await run({...v, 'barcode': null});
      }
      rethrow;
    }
  }

  Future<bool> _isPending(String table, int id) async =>
      await _db
          .customSelect(
            'SELECT 1 FROM sync_outbox WHERE tbl = ? AND row_id = ?',
            variables: [Variable.withString(table), Variable.withInt(id)],
          )
          .getSingleOrNull() !=
      null;

  Future<int?> _localId(String table, String uid) async =>
      (await _db
              .customSelect(
                'SELECT id FROM $table WHERE uid = ?',
                variables: [Variable.withString(uid)],
              )
              .getSingleOrNull())
          ?.read<int>('id');

  Future<String?> _uidOf(String table, int id) async =>
      (await _db
              .customSelect(
                'SELECT uid FROM $table WHERE id = ?',
                variables: [Variable.withInt(id)],
              )
              .getSingleOrNull())
          ?.readNullable<String>('uid');

  Future<List<String>> _shared(SyncTable t) async =>
      _columns[t.name] ??= await sharedColumns(_db, t);

  final _optional = <String, Set<String>>{};

  /// Whether [column] of [t] may be empty (NULL).
  Future<bool> _nullable(SyncTable t, String column) async {
    final optional = _optional[t.name] ??= {
      for (final r
          in await _db.customSelect('PRAGMA table_info(${t.name})').get())
        if (r.read<int>('notnull') == 0) r.read<String>('name'),
    };
    return optional.contains(column);
  }

  static Variable<Object> _variable(Object? v) => switch (v) {
    null => const Variable(null),
    final bool b => Variable.withBool(b),
    final int i => Variable.withInt(i),
    final double d => Variable.withReal(d),
    final String s => Variable.withString(s),
    _ => Variable.withString('$v'),
  };
}
