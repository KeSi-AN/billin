import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

part 'item.freezed.dart';

/// Units a shop commonly sells in. Stored as the short code.
const itemUnits = [
  'pcs',
  'kg',
  'g',
  'l',
  'ml',
  'm',
  'box',
  'pack',
  'dozen',
  'pair',
  'bottle',
];

@freezed
abstract class Item with _$Item {
  const factory Item({
    required String name,
    required Money salePrice,

    /// `null` until saved.
    int? id,
    String? barcode,
    @Default('pcs') String unit,
    Money? mrp,
    @Default(TaxRate.zero) TaxRate taxRate,

    /// MRP-style pricing (GST included in the price), the usual retail case.
    @Default(true) bool priceIncludesTax,
    String? hsn,

    /// Off: unlimited stock, nothing is counted.
    @Default(false) bool trackStock,

    /// Current stock in base units. Read-only here: only the stock ledger
    /// changes it (saving an item never touches stock).
    @Default(Quantity.zero) Quantity stock,

    /// Alert when stock falls to this level or below.
    Quantity? lowStock,
    int? categoryId,
    String? imagePath,

    /// Stock kept in batches with expiry; sales use the earliest expiry.
    @Default(false) bool tracksBatches,

    /// Optional second selling unit, e.g. `box` holding 12 `pcs`.
    String? altUnit,
    Quantity? altUnitFactor,
    Money? altUnitPrice,
  }) = _Item;

  const Item._();

  bool get hasAltUnit =>
      altUnit != null && altUnitFactor != null && altUnitFactor!.isPositive;

  bool get isOutOfStock => trackStock && !stock.isPositive;

  bool get isLowStock => trackStock && lowStock != null && !(stock > lowStock!);
}

class DuplicateBarcodeException implements Exception {
  const DuplicateBarcodeException(this.barcode, this.existingItemName);

  final String barcode;
  final String existingItemName;

  @override
  String toString() =>
      'Barcode $barcode is already used by "$existingItemName"';
}

enum StockFilter { all, low, out }

enum ItemSort { name, stockLowFirst, priceHighFirst }

/// What the items list shows.
@immutable
class ItemFilter {
  const ItemFilter({
    this.query = '',
    this.categoryId,
    this.stock = StockFilter.all,
    this.sort = ItemSort.name,
  });

  final String query;

  /// Matches the category and its subcategories.
  final int? categoryId;
  final StockFilter stock;
  final ItemSort sort;

  ItemFilter copyWith({
    String? query,
    int? Function()? categoryId,
    StockFilter? stock,
    ItemSort? sort,
  }) => ItemFilter(
    query: query ?? this.query,
    categoryId: categoryId != null ? categoryId() : this.categoryId,
    stock: stock ?? this.stock,
    sort: sort ?? this.sort,
  );

  @override
  bool operator ==(Object other) =>
      other is ItemFilter &&
      other.query == query &&
      other.categoryId == categoryId &&
      other.stock == stock &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(query, categoryId, stock, sort);
}

abstract interface class ItemRepository {
  /// Active items matching [filter].
  Stream<List<Item>> watchAll({ItemFilter filter = const ItemFilter()});

  Future<Item?> byId(int id);

  /// Exact barcode match among active items: what a scanner lookup needs.
  Future<Item?> byBarcode(String barcode);

  /// Name contains [query] (any case) or barcode starts with it.
  Future<List<Item>> search(String query, {int limit = 20});

  /// Inserts or updates; returns the saved item with its id.
  /// Throws [DuplicateBarcodeException] if another item has the barcode.
  Future<Item> save(Item item);

  /// Hides the item. Past bills keep their copy of its details.
  Future<void> delete(int id);

  /// Copies a picked photo into app storage; returns the stored path.
  Future<String> importImage(String sourcePath);
}
