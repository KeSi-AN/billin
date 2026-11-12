import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/customers/domain/party.dart';

/// The only code that changes what a party owes. Appends an entry and
/// updates the cached balance; callers run it inside a transaction.
class PartyLedger {
  PartyLedger(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  Future<void> post({
    required int partyId,
    required int amountPaise,
    required EntryType type,
    int? billId,
    String? paymentMode,
    String? note,
  }) async {
    if (amountPaise == 0) return;
    final party = await (_db.select(
      _db.parties,
    )..where((p) => p.id.equals(partyId))).getSingle();
    final balance = party.balancePaise + amountPaise;
    await _db
        .into(_db.partyEntries)
        .insert(
          PartyEntriesCompanion.insert(
            partyId: partyId,
            type: type.name,
            amountPaise: amountPaise,
            billId: Value(billId),
            paymentMode: Value(paymentMode),
            note: Value(note),
            balanceAfterPaise: balance,
            at: _clock(),
          ),
        );
    await (_db.update(_db.parties)..where((p) => p.id.equals(partyId))).write(
      PartiesCompanion(
        balancePaise: Value(balance),
        updatedAt: Value(_clock()),
      ),
    );
  }

  /// Undoes everything a bill did to a party's balance.
  Future<void> reverseBill(int billId) async {
    final entries = await (_db.select(
      _db.partyEntries,
    )..where((e) => e.billId.equals(billId))).get();
    final byParty = <int, int>{};
    for (final e in entries) {
      byParty[e.partyId] = (byParty[e.partyId] ?? 0) + e.amountPaise;
    }
    for (final MapEntry(key: partyId, value: sum) in byParty.entries) {
      await post(
        partyId: partyId,
        amountPaise: -sum,
        type: EntryType.cancel,
        billId: billId,
      );
    }
  }
}
