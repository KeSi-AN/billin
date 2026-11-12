import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/inventory/data/stock_ledger.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';

class DriftInventoryRepository implements InventoryRepository {
  DriftInventoryRepository(this._db, {DateTime Function() clock = DateTime.now})
    : _ledger = StockLedger(_db, clock);

  final AppDatabase _db;
  final StockLedger _ledger;

  @override
  Stream<List<Category>> watchCategories() =>
      (_db.select(
        _db.categories,
      )..orderBy([(c) => OrderingTerm.asc(c.name.lower())])).watch().map(
        (rows) => [
          for (final r in rows)
            Category(id: r.id, name: r.name, parentId: r.parentId),
        ],
      );

  @override
  Future<Category> addCategory(String name, {int? parentId}) => _db.transaction(
    () async {
      final clean = name.trim();
      final existing =
          await (_db.select(_db.categories)..where(
                (c) =>
                    c.name.lower().equals(clean.toLowerCase()) &
                    (parentId == null
                        ? c.parentId.isNull()
                        : c.parentId.equals(parentId)),
              ))
              .getSingleOrNull();
      if (existing != null) {
        return Category(
          id: existing.id,
          name: existing.name,
          parentId: existing.parentId,
        );
      }
      final id = await _db
          .into(_db.categories)
          .insert(
            CategoriesCompanion.insert(name: clean, parentId: Value(parentId)),
          );
      return Category(id: id, name: clean, parentId: parentId);
    },
  );

  @override
  Future<void> addStock(
    int itemId,
    Quantity quantity, {
    String? batchNo,
    DateTime? expiry,
    String? note,
    bool opening = false,
  }) => _db.transaction(() async {
    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(itemId))).getSingle();
    int? batchId;
    if (item.tracksBatches) {
      final no = batchNo?.trim() ?? '';
      if (no.isEmpty) throw const BatchRequiredException();
      batchId = await _ledger.batchFor(itemId, no, expiry);
    }
    await _ledger.post(
      itemId: itemId,
      quantityMilli: quantity.milli,
      type: opening ? MovementType.opening : MovementType.stockIn,
      batchId: batchId,
      note: _blankToNull(note),
    );
  });

  @override
  Future<void> adjustStock(
    int itemId,
    Quantity actual, {
    int? batchId,
    String? note,
  }) => _db.transaction(() async {
    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(itemId))).getSingle();
    final int current;
    if (batchId != null) {
      current = (await (_db.select(
        _db.itemBatches,
      )..where((b) => b.id.equals(batchId))).getSingle()).quantityMilli;
    } else {
      current = item.stockMilli;
    }
    await _ledger.post(
      itemId: itemId,
      quantityMilli: actual.milli - current,
      type: MovementType.adjust,
      batchId: batchId,
      note: _blankToNull(note),
    );
  });

  @override
  Stream<List<StockMovement>> watchMovements(int itemId, {int limit = 100}) {
    final m = _db.stockMovements;
    final query =
        _db.select(m).join([
            leftOuterJoin(
              _db.itemBatches,
              _db.itemBatches.id.equalsExp(m.batchId),
            ),
            leftOuterJoin(_db.bills, _db.bills.id.equalsExp(m.billId)),
          ])
          ..where(m.itemId.equals(itemId))
          ..orderBy([OrderingTerm.desc(m.at), OrderingTerm.desc(m.id)])
          ..limit(limit);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          _toMovement(
            r.readTable(m),
            r.readTableOrNull(_db.itemBatches)?.batchNo,
            r.readTableOrNull(_db.bills)?.invoiceNo,
          ),
      ],
    );
  }

  @override
  Stream<List<StockBatch>> watchBatches(int itemId) =>
      (_db.select(_db.itemBatches)
            ..where(
              (b) =>
                  b.itemId.equals(itemId) &
                  b.quantityMilli.isBiggerThanValue(0),
            )
            ..orderBy([
              (b) => OrderingTerm(expression: b.expiry, nulls: NullsOrder.last),
            ]))
          .watch()
          .map((rows) => rows.map(_toBatch).toList());

  @override
  Stream<List<Item>> watchLowStock() {
    final i = _db.items;
    return (_db.select(i)
          ..where(
            (t) =>
                t.isActive.equals(true) &
                t.trackStock.equals(true) &
                t.lowStockMilli.isNotNull() &
                t.stockMilli.isSmallerOrEqual(t.lowStockMilli),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.stockMilli)]))
        .watch()
        .map((rows) => rows.map(DriftItemRepository.toDomain).toList());
  }

  @override
  Stream<List<ExpiringBatch>> watchExpiring({required DateTime before}) {
    final b = _db.itemBatches;
    final query =
        _db.select(b).join([
            innerJoin(_db.items, _db.items.id.equalsExp(b.itemId)),
          ])
          ..where(
            b.quantityMilli.isBiggerThanValue(0) &
                b.expiry.isNotNull() &
                b.expiry.isSmallerThanValue(before) &
                _db.items.isActive.equals(true),
          )
          ..orderBy([OrderingTerm.asc(b.expiry)]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          ExpiringBatch(
            item: DriftItemRepository.toDomain(r.readTable(_db.items)),
            batch: _toBatch(r.readTable(b)),
          ),
      ],
    );
  }

  static StockBatch _toBatch(BatchRow r) => StockBatch(
    id: r.id,
    itemId: r.itemId,
    batchNo: r.batchNo,
    expiry: r.expiry,
    quantity: Quantity.milli(r.quantityMilli),
  );

  static StockMovement _toMovement(
    MovementRow r,
    String? batchNo,
    String? invoiceNo,
  ) => StockMovement(
    id: r.id,
    itemId: r.itemId,
    quantity: Quantity.milli(r.quantityMilli),
    type: MovementType.values.byName(r.type),
    balanceAfter: Quantity.milli(r.balanceAfterMilli),
    at: r.at,
    batchNo: batchNo,
    note: r.note,
    billId: r.billId,
    invoiceNo: invoiceNo,
  );

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
