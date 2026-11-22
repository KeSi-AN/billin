import 'package:drift/drift.dart';

/// How one table is shared between the phones of a shop.
class SyncTable {
  const SyncTable(
    this.name, {
    this.refs = const {},
    this.localOnly = const {},
    this.ledger = false,
    this.single = false,
  });

  /// SQL table name.
  final String name;

  /// Columns holding another synced row's local id → that row's table.
  /// They travel as the other row's uid and are mapped back on arrival.
  final Map<String, String> refs;

  /// Columns that stay on this phone: running totals other synced rows
  /// already add up to (stock, balances) and paths to local files.
  final Set<String> localOnly;

  /// Rows are only ever added (stock movements, payments): each one is
  /// applied exactly once, and its amount is added to the running total.
  final bool ledger;

  /// One row per shop (the shop profile, id 1), without a uid.
  final bool single;
}

/// Everything shared between phones, parents before children (a row's
/// links can then always be resolved when rows arrive in this order).
const syncTables = <SyncTable>[
  SyncTable('shop_profiles', single: true, localOnly: {'logo_path'}),
  SyncTable('categories', refs: {'parent_id': 'categories'}),
  SyncTable(
    'items',
    refs: {'category_id': 'categories'},
    localOnly: {'stock_milli', 'image_path'},
  ),
  SyncTable(
    'item_batches',
    refs: {'item_id': 'items'},
    localOnly: {'quantity_milli'},
  ),
  SyncTable('parties', localOnly: {'balance_paise'}),
  SyncTable('bills', refs: {'party_id': 'parties'}),
  SyncTable('bill_lines', refs: {'bill_id': 'bills', 'item_id': 'items'}),
  SyncTable(
    'purchases',
    refs: {'party_id': 'parties'},
    localOnly: {'photo_path'},
  ),
  SyncTable(
    'purchase_lines',
    refs: {'purchase_id': 'purchases', 'item_id': 'items'},
  ),
  SyncTable('expenses'),
  SyncTable('credit_notes', refs: {'bill_id': 'bills'}),
  SyncTable(
    'credit_note_lines',
    refs: {'credit_note_id': 'credit_notes', 'bill_line_id': 'bill_lines'},
  ),
  SyncTable(
    'stock_movements',
    refs: {'item_id': 'items', 'batch_id': 'item_batches', 'bill_id': 'bills'},
    localOnly: {'balance_after_milli'},
    ledger: true,
  ),
  SyncTable(
    'party_entries',
    refs: {'party_id': 'parties', 'bill_id': 'bills'},
    localOnly: {'balance_after_paise'},
    ledger: true,
  ),
];

SyncTable syncTable(String name) =>
    syncTables.firstWhere((t) => t.name == name);

/// Never sent: the local id and the uid travel separately.
const _notData = {'id', 'uid'};

/// The columns of [table] that are shared (sent to the cloud).
Future<List<String>> sharedColumns(
  DatabaseConnectionUser db,
  SyncTable table,
) async {
  final info = await db.customSelect('PRAGMA table_info(${table.name})').get();
  return [
    for (final r in info)
      if (!_notData.contains(r.read<String>('name')) &&
          !table.localOnly.contains(r.read<String>('name')))
        r.read<String>('name'),
  ];
}

/// (Re)creates the triggers that give new rows a uid and queue changed
/// rows for sending. Run on every open, so new columns are always covered.
///
/// A row is queued when it is added, or when a *shared* column is written:
/// a sale updates an item's stock total, which must not re-send the item
/// (a stale copy could undo a price change made on the other phone).
/// Queuing replaces an existing entry (delete, then insert: a conflict
/// clause inside a trigger would be overridden by the outer statement's,
/// e.g. an upsert's) with a new outbox id, so a row changed
/// again while it is being sent stays queued: only the entries that were
/// read for sending are removed afterwards.
/// While rows from the cloud are applied (`sync_state.applying = 1`),
/// nothing is queued, so they aren't sent straight back.
Future<void> installSyncTriggers(DatabaseConnectionUser db) async {
  // Not there yet in a database still at an older version (tests that
  // migrate step by step open the app's database at each version).
  final hasSync = await db
      .customSelect(
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'sync_state'",
      )
      .getSingleOrNull();
  if (hasSync == null) return;
  await db.customStatement(
    'INSERT OR IGNORE INTO sync_state (id, applying, pulled_seq) '
    'VALUES (1, 0, 0)',
  );
  // A crash while applying must not leave queuing switched off.
  await db.customStatement('UPDATE sync_state SET applying = 0 WHERE id = 1');
  const notApplying =
      'coalesce((SELECT applying FROM sync_state WHERE id = 1), 0) = 0';
  for (final t in syncTables) {
    final n = t.name;
    for (final trigger in ['sync_uid_$n', 'sync_add_$n', 'sync_change_$n']) {
      await db.customStatement('DROP TRIGGER IF EXISTS $trigger');
    }
    if (!t.single) {
      await db.customStatement(
        'CREATE TRIGGER sync_uid_$n AFTER INSERT ON $n '
        'WHEN NEW.uid IS NULL BEGIN '
        'UPDATE $n SET uid = lower(hex(randomblob(16))) WHERE id = NEW.id; '
        'END',
      );
    }
    await db.customStatement(
      'CREATE TRIGGER sync_add_$n AFTER INSERT ON $n '
      'WHEN $notApplying BEGIN '
      "DELETE FROM sync_outbox WHERE tbl = '$n' AND row_id = NEW.id; "
      "INSERT INTO sync_outbox (tbl, row_id) VALUES ('$n', NEW.id); "
      'END',
    );
    final columns = (await sharedColumns(db, t)).join(', ');
    await db.customStatement(
      'CREATE TRIGGER sync_change_$n AFTER UPDATE OF $columns ON $n '
      'WHEN $notApplying BEGIN '
      "DELETE FROM sync_outbox WHERE tbl = '$n' AND row_id = NEW.id; "
      "INSERT INTO sync_outbox (tbl, row_id) VALUES ('$n', NEW.id); "
      'END',
    );
  }
}

/// Gives existing rows a uid and queues everything for sending: run once
/// when the sync tables are added, so a phone's data so far goes up too.
Future<void> backfillSync(DatabaseConnectionUser db) async {
  for (final t in syncTables) {
    if (!t.single) {
      await db.customStatement(
        'UPDATE ${t.name} SET uid = lower(hex(randomblob(16))) '
        'WHERE uid IS NULL',
      );
    }
    await db.customStatement(
      'INSERT OR IGNORE INTO sync_outbox (tbl, row_id) '
      "SELECT '${t.name}', id FROM ${t.name}",
    );
  }
}
