import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/domain/item.dart';

enum MovementType { opening, stockIn, sale, cancel, adjust }

class Category {
  const Category({required this.id, required this.name, this.parentId});

  final int id;
  final String name;

  /// Set for a subcategory.
  final int? parentId;

  bool get isSubcategory => parentId != null;
}

class StockBatch {
  const StockBatch({
    required this.id,
    required this.itemId,
    required this.batchNo,
    required this.quantity,
    this.expiry,
  });

  final int id;
  final int itemId;
  final String batchNo;
  final DateTime? expiry;
  final Quantity quantity;

  bool isExpiredOn(DateTime day) =>
      expiry != null &&
      expiry!.isBefore(DateTime(day.year, day.month, day.day));
}

class StockMovement {
  const StockMovement({
    required this.id,
    required this.itemId,
    required this.quantity,
    required this.type,
    required this.balanceAfter,
    required this.at,
    this.batchNo,
    this.note,
    this.billId,
    this.invoiceNo,
  });

  final int id;
  final int itemId;

  /// Signed: + in, − out.
  final Quantity quantity;
  final MovementType type;
  final Quantity balanceAfter;
  final DateTime at;
  final String? batchNo;
  final String? note;
  final int? billId;
  final String? invoiceNo;
}

/// A batch nearing (or past) its expiry, with its item.
class ExpiringBatch {
  const ExpiringBatch({required this.item, required this.batch});

  final Item item;
  final StockBatch batch;
}

class BatchRequiredException implements Exception {
  const BatchRequiredException();

  @override
  String toString() => 'This item keeps stock in batches: give a batch number';
}

abstract interface class InventoryRepository {
  Stream<List<Category>> watchCategories();

  /// Adds a category (or subcategory under [parentId]). If one with the same
  /// name already exists there (any case), returns that instead.
  Future<Category> addCategory(String name, {int? parentId});

  /// Stock coming in: a delivery, or opening stock for a new item. Batch
  /// items need [batchNo]; the batch is created if new.
  Future<void> addStock(
    int itemId,
    Quantity quantity, {
    String? batchNo,
    DateTime? expiry,
    String? note,
    bool opening = false,
  });

  /// Sets stock to a counted figure (damage, theft, recount). For batch
  /// items, adjusts the given batch.
  Future<void> adjustStock(
    int itemId,
    Quantity actual, {
    int? batchId,
    String? note,
  });

  /// Newest first.
  Stream<List<StockMovement>> watchMovements(int itemId, {int limit = 100});

  /// Batches with stock, earliest expiry first.
  Stream<List<StockBatch>> watchBatches(int itemId);

  /// Tracked items at or below their low-stock level, lowest first.
  Stream<List<Item>> watchLowStock();

  /// Batches with stock that expire before [before] (includes expired).
  Stream<List<ExpiringBatch>> watchExpiring({required DateTime before});
}
