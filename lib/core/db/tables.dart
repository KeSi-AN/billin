import 'package:drift/drift.dart';

// Conventions: money columns end in `Paise`, quantities in `Milli`, GST rates
// in `Bp` (basis points). All are integers; see Money, Quantity, TaxRate.

/// The shop's own details. Always exactly one row (id = 1).
@DataClassName('ShopProfileRow')
class ShopProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get addressLine => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get pincode => text().nullable()();

  /// GST state code (`27` = Maharashtra). Drives CGST/SGST vs IGST later.
  TextColumn get stateCode => text().withLength(min: 2, max: 2)();
  TextColumn get gstin => text().nullable()();

  /// Absolute path to the logo copied into the app's private storage.
  TextColumn get logoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}

/// Things the shop sells.
@DataClassName('ItemRow')
@TableIndex(name: 'items_name', columns: {#name})
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Unique when set. Cleared when an item is deleted so it can be reused.
  TextColumn get barcode => text().nullable().unique()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  IntColumn get salePricePaise => integer()();
  IntColumn get mrpPaise => integer().nullable()();
  IntColumn get taxRateBp => integer().withDefault(const Constant(0))();
  BoolColumn get priceIncludesTax =>
      boolean().withDefault(const Constant(true))();
  TextColumn get hsn => text().nullable()();

  /// Deleted items are hidden, not removed: old bills still point at them.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // --- Phase 2: inventory (schema v3) ---

  /// Off: unlimited stock, nothing is counted.
  BoolColumn get trackStock => boolean().withDefault(const Constant(false))();

  /// Cached sum of this item's stock movements, in base units. The ledger
  /// (StockMovements) is the truth; this is kept in step in the same
  /// transaction so lists don't have to add up history.
  IntColumn get stockMilli => integer().withDefault(const Constant(0))();
  IntColumn get lowStockMilli => integer().nullable()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get imagePath => text().nullable()();

  /// Stock is held in batches with expiry dates; sales take the batch that
  /// expires first (FEFO).
  BoolColumn get tracksBatches =>
      boolean().withDefault(const Constant(false))();

  /// A second selling unit, e.g. `box` = 12 × `pcs`.
  TextColumn get altUnit => text().nullable()();
  IntColumn get altUnitFactorMilli => integer().nullable()();
  IntColumn get altUnitPricePaise => integer().nullable()();
}

/// Item categories. A category with a parent is a subcategory (one level).
@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
}

/// Stock held in one batch (lot) of an item, with its expiry date.
@DataClassName('BatchRow')
class ItemBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  TextColumn get batchNo => text()();
  DateTimeColumn get expiry => dateTime().nullable()();
  IntColumn get quantityMilli => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {itemId, batchNo},
  ];
}

/// Append-only stock ledger. Every change to stock is one row here; stock
/// is never edited directly.
@DataClassName('MovementRow')
@TableIndex(name: 'movements_item', columns: {#itemId, #at})
class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get batchId => integer().nullable().references(ItemBatches, #id)();

  /// Signed, in base units: + stock in, − stock out.
  IntColumn get quantityMilli => integer()();

  /// `opening`, `stockIn`, `sale`, `cancel`, `adjust`.
  TextColumn get type => text()();
  TextColumn get note => text().nullable()();
  IntColumn get billId => integer().nullable().references(Bills, #id)();

  /// Item stock right after this movement.
  IntColumn get balanceAfterMilli => integer()();
  DateTimeColumn get at => dateTime()();
}

/// A saved sale. Amounts are stored as calculated at billing time and never
/// recomputed, so a reprint always matches what the customer got.
@DataClassName('BillRow')
@TableIndex(name: 'bills_billed_at', columns: {#billedAt})
class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNo => text().unique()();
  IntColumn get fyStart => integer()();
  IntColumn get sequence => integer()();
  DateTimeColumn get billedAt => dateTime()();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  IntColumn get itemsTotalPaise => integer()();
  IntColumn get billDiscountPaise => integer()();
  IntColumn get taxablePaise => integer()();
  IntColumn get taxPaise => integer()();
  IntColumn get roundOffPaise => integer()();
  IntColumn get grandTotalPaise => integer()();

  /// `cash`, `upi`, `card` or `credit`.
  TextColumn get paymentMode => text()();

  /// `completed` or `cancelled`. Bills are never deleted.
  TextColumn get status => text().withDefault(const Constant('completed'))();
  DateTimeColumn get cancelledAt => dateTime().nullable()();
  TextColumn get cancelReason => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {fyStart, sequence},
  ];
}

@DataClassName('BillLineRow')
class BillLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get billId =>
      integer().references(Bills, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();

  /// Null for quick (unsaved) items.
  IntColumn get itemId => integer().nullable().references(Items, #id)();

  // Snapshot of the item at billing time.
  TextColumn get name => text()();
  TextColumn get unit => text()();
  TextColumn get hsn => text().nullable()();
  IntColumn get quantityMilli => integer()();
  IntColumn get unitPricePaise => integer()();
  IntColumn get taxRateBp => integer()();
  BoolColumn get priceIncludesTax => boolean()();

  // Calculated amounts.
  IntColumn get discountPaise => integer()();
  IntColumn get billDiscountSharePaise => integer()();
  IntColumn get taxablePaise => integer()();
  IntColumn get taxPaise => integer()();
  IntColumn get totalPaise => integer()();

  /// Base units per sold unit: 1000 normally, 12000 when a "box" of 12 pcs
  /// was sold. Stock moved = quantity × factor.
  IntColumn get unitFactorMilli =>
      integer().withDefault(const Constant(1000))();
}

/// Last invoice sequence used in each financial year.
class InvoiceCounters extends Table {
  IntColumn get fyStart => integer()();
  IntColumn get lastSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => {fyStart};
}

/// Billing and printer settings. Always exactly one row (id = 1).
@DataClassName('SettingsRow')
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('INV'))();
  BoolColumn get roundToRupee => boolean().withDefault(const Constant(true))();
  TextColumn get upiId => text().nullable()();
  TextColumn get receiptFooter => text().nullable()();
  TextColumn get printerAddress => text().nullable()();
  TextColumn get printerName => text().nullable()();
  IntColumn get paperWidthMm => integer().withDefault(const Constant(58))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}
