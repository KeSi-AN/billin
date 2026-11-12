import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/india/phone.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/customers/data/party_ledger.dart';
import 'package:shop_app/features/customers/domain/party.dart';

class DriftPartyRepository implements PartyRepository {
  DriftPartyRepository(this._db, {this._clock = DateTime.now})
    : _ledger = PartyLedger(_db, _clock);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final PartyLedger _ledger;

  $PartiesTable get _p => _db.parties;

  SimpleSelectStatement<$PartiesTable, PartyRow> _customers() =>
      _db.select(_p)
        ..where((p) => p.isActive.equals(true) & p.type.equals('customer'));

  @override
  Stream<List<Party>> watchAll({PartyFilter filter = const PartyFilter()}) {
    final select = _customers();
    final q = filter.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      final escaped = q
          .replaceAll(r'\', r'\\')
          .replaceAll('%', r'\%')
          .replaceAll('_', r'\_');
      final digits = IndianPhone.normalize(q);
      select.where(
        (p) =>
            p.name.lower().like('%$escaped%', escapeChar: r'\') |
            (digits.isEmpty
                ? const Constant(false)
                : p.phone.like('%$digits%')),
      );
    }
    if (filter.onlyWithDues) {
      select.where((p) => p.balancePaise.isBiggerThanValue(0));
    }
    select.orderBy([
      switch (filter.sort) {
        PartySort.name => (p) => OrderingTerm.asc(p.name.lower()),
        PartySort.dueHighFirst => (p) => OrderingTerm.desc(p.balancePaise),
        PartySort.recent => (p) => OrderingTerm.desc(p.updatedAt),
      },
      (p) => OrderingTerm.asc(p.name.lower()),
    ]);
    return select.watch().map((rows) => rows.map(toDomain).toList());
  }

  @override
  Stream<Money> watchTotalDue() {
    final sum = _p.balancePaise.sum(
      filter: _p.balancePaise.isBiggerThanValue(0) & _p.isActive.equals(true),
    );
    return (_db.selectOnly(_p)..addColumns([sum])).watchSingle().map(
      (row) => Money.paise(row.read(sum) ?? 0),
    );
  }

  @override
  Future<Party?> byId(int id) async {
    final row = await (_db.select(
      _p,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    return row == null ? null : toDomain(row);
  }

  @override
  Stream<Party?> watch(int id) =>
      (_db.select(_p)..where((p) => p.id.equals(id))).watchSingleOrNull().map(
        (row) => row == null ? null : toDomain(row),
      );

  @override
  Future<Party> save(
    Party party, {
    Money openingDue = Money.zero,
  }) => _db.transaction(() async {
    final phone = _blankToNull(party.phone);
    final normalized = phone == null ? null : IndianPhone.normalize(phone);
    if (normalized != null) {
      final clash =
          await (_customers()..where((p) => p.phone.equals(normalized)))
              .getSingleOrNull();
      if (clash != null && clash.id != party.id) {
        throw DuplicatePhoneException(clash.name);
      }
    }
    final now = _clock();
    final companion = PartiesCompanion(
      type: Value(party.type.name),
      name: Value(party.name.trim()),
      phone: Value(normalized),
      addressLine: Value(_blankToNull(party.addressLine)),
      gstin: Value(_blankToNull(party.gstin)?.toUpperCase()),
      notes: Value(_blankToNull(party.notes)),
      updatedAt: Value(now),
    );
    final int id;
    if (party.id == null) {
      id = await _db.into(_p).insert(companion.copyWith(createdAt: Value(now)));
      if (!openingDue.isZero) {
        await _ledger.post(
          partyId: id,
          amountPaise: openingDue.paise,
          type: EntryType.opening,
        );
      }
    } else {
      id = party.id!;
      await (_db.update(_p)..where((p) => p.id.equals(id))).write(companion);
    }
    return (await byId(id))!;
  });

  @override
  Future<void> delete(int id) => _db.transaction(() async {
    final party = (await byId(id))!;
    if (!party.balance.isZero) throw PartyHasBalanceException(party.balance);
    await (_db.update(_p)..where((p) => p.id.equals(id))).write(
      PartiesCompanion(
        isActive: const Value(false),
        updatedAt: Value(_clock()),
      ),
    );
  });

  JoinedSelectStatement<HasResultSet, dynamic> _entries(int partyId) =>
      _db.select(_db.partyEntries).join([
        leftOuterJoin(
          _db.bills,
          _db.bills.id.equalsExp(_db.partyEntries.billId),
        ),
      ])..where(_db.partyEntries.partyId.equals(partyId));

  @override
  Stream<List<PartyEntry>> watchEntries(int partyId) {
    final e = _db.partyEntries;
    final query = _entries(partyId)
      ..orderBy([OrderingTerm.desc(e.at), OrderingTerm.desc(e.id)]);
    return query.watch().map((rows) => rows.map(_toEntry).toList());
  }

  @override
  Future<List<PartyEntry>> entriesBetween(
    int partyId,
    DateTime from,
    DateTime to,
  ) async {
    final e = _db.partyEntries;
    final query = _entries(partyId)
      ..where(e.at.isBiggerOrEqualValue(from) & e.at.isSmallerThanValue(to))
      ..orderBy([OrderingTerm.asc(e.at), OrderingTerm.asc(e.id)]);
    return (await query.get()).map(_toEntry).toList();
  }

  @override
  Future<void> receivePayment(
    int partyId,
    Money amount, {
    PaymentMode mode = PaymentMode.cash,
    String? note,
  }) {
    if (!amount.isPositive) {
      throw ArgumentError.value(amount, 'amount', 'must be positive');
    }
    return _db.transaction(
      () => _ledger.post(
        partyId: partyId,
        amountPaise: -amount.paise,
        type: EntryType.payment,
        paymentMode: mode.name,
        note: _blankToNull(note),
      ),
    );
  }

  PartyEntry _toEntry(TypedResult r) {
    final row = r.readTable(_db.partyEntries);
    final mode = row.paymentMode;
    return PartyEntry(
      id: row.id,
      partyId: row.partyId,
      type: EntryType.values.byName(row.type),
      amount: Money.paise(row.amountPaise),
      balanceAfter: Money.paise(row.balanceAfterPaise),
      at: row.at,
      billId: row.billId,
      invoiceNo: r.readTableOrNull(_db.bills)?.invoiceNo,
      paymentMode: mode == null ? null : PaymentMode.values.byName(mode),
      note: row.note,
    );
  }

  static Party toDomain(PartyRow r) => Party(
    id: r.id,
    type: PartyType.values.byName(r.type),
    name: r.name,
    phone: r.phone,
    addressLine: r.addressLine,
    gstin: r.gstin,
    notes: r.notes,
    balance: Money.paise(r.balancePaise),
  );

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
