import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';

/// The only code that changes stock. Every change appends a movement and
/// updates the cached item (and batch) totals. Callers run it inside a
/// transaction so the ledger and the caches can never disagree.
class StockLedger {
  StockLedger(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  Future<void> post({
    required int itemId,
    required int quantityMilli,
    required MovementType type,
    int? batchId,
    int? billId,
    String? note,
  }) async {
    if (quantityMilli == 0) return;
    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(itemId))).getSingle();
    final balance = item.stockMilli + quantityMilli;
    await _db
        .into(_db.stockMovements)
        .insert(
          StockMovementsCompanion.insert(
            itemId: itemId,
            batchId: Value(batchId),
            quantityMilli: quantityMilli,
            type: type.name,
            note: Value(note),
            billId: Value(billId),
            balanceAfterMilli: balance,
            at: _clock(),
          ),
        );
    await (_db.update(_db.items)..where((t) => t.id.equals(itemId))).write(
      ItemsCompanion(stockMilli: Value(balance)),
    );
    if (batchId != null) {
      await _db.customUpdate(
        'UPDATE item_batches SET quantity_milli = quantity_milli + ? WHERE id = ?',
        variables: [Variable.withInt(quantityMilli), Variable.withInt(batchId)],
        updates: {_db.itemBatches},
      );
    }
  }

  /// Takes [quantityMilli] (positive, base units) out for a sale. Batch
  /// items are drawn first-expiry-first-out; anything the batches can't
  /// cover is recorded without a batch (stock goes negative, which shops
  /// fix with a recount rather than being blocked at the counter).
  Future<void> sell({
    required int itemId,
    required int quantityMilli,
    required int billId,
  }) async {
    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(itemId))).getSingle();
    if (!item.trackStock || quantityMilli <= 0) return;

    var remaining = quantityMilli;
    if (item.tracksBatches) {
      final batches =
          await (_db.select(_db.itemBatches)
                ..where(
                  (b) =>
                      b.itemId.equals(itemId) &
                      b.quantityMilli.isBiggerThanValue(0),
                )
                ..orderBy([
                  // Earliest expiry first; batches without a date last.
                  (b) => OrderingTerm(
                    expression: b.expiry,
                    nulls: NullsOrder.last,
                  ),
                  (b) => OrderingTerm.asc(b.createdAt),
                ]))
              .get();
      for (final batch in batches) {
        if (remaining == 0) break;
        final take = remaining < batch.quantityMilli
            ? remaining
            : batch.quantityMilli;
        await post(
          itemId: itemId,
          quantityMilli: -take,
          type: MovementType.sale,
          batchId: batch.id,
          billId: billId,
        );
        remaining -= take;
      }
    }
    if (remaining > 0) {
      await post(
        itemId: itemId,
        quantityMilli: -remaining,
        type: MovementType.sale,
        billId: billId,
      );
    }
  }

  /// Puts back everything a bill took out, batch by batch.
  Future<void> reverseBill(int billId) async {
    final sales =
        await (_db.select(_db.stockMovements)..where(
              (m) =>
                  m.billId.equals(billId) &
                  m.type.equals(MovementType.sale.name),
            ))
            .get();
    for (final m in sales) {
      await post(
        itemId: m.itemId,
        quantityMilli: -m.quantityMilli,
        type: MovementType.cancel,
        batchId: m.batchId,
        billId: billId,
      );
    }
  }
}
