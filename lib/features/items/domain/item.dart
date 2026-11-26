import 'dart:convert';

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

    /// Cost per base unit before GST; purchases keep it up to date.
    Money? costPrice,

    /// Colours it comes in (for the website and the shop's reference).
    @Default(<ItemColour>[]) List<ItemColour> colours,
    String? fabric,

    /// Washing and care, e.g. "Dry wash only".
    String? care,
    String? description,

    /// Listed on the shop's website.
    @Default(false) bool showOnWebsite,
  }) = _Item;

  const Item._();

  bool get hasAltUnit =>
      altUnit != null && altUnitFactor != null && altUnitFactor!.isPositive;

  bool get isOutOfStock => trackStock && !stock.isPositive;

  bool get isLowStock => trackStock && lowStock != null && !(stock > lowStock!);
}

/// A colour an item comes in: a name, and optionally its colour code
/// (`#6b3f6e`) for the website's swatch.
@immutable
class ItemColour {
  const ItemColour(this.name, [this.hex]);

  final String name;
  final String? hex;

  static final _hex = RegExp(r'^#[0-9a-fA-F]{6}$');

  /// `#rrggbb` when valid, otherwise `null`.
  static String? cleanHex(String? hex) {
    final h = hex?.trim() ?? '';
    final withHash = h.startsWith('#') ? h : '#$h';
    return _hex.hasMatch(withHash) ? withHash.toLowerCase() : null;
  }

  Map<String, Object?> toJson() => {'name': name, if (hex != null) 'hex': hex};

  /// The `colours` column: `[{"name":"Plum","hex":"#6b3f6e"}]`; `null` for
  /// none. Anything unreadable is dropped rather than failing.
  static String? encodeList(List<ItemColour> colours) => colours.isEmpty
      ? null
      : jsonEncode([for (final c in colours) c.toJson()]);

  static List<ItemColour> decodeList(String? json) {
    if (json == null || json.trim().isEmpty) return const [];
    try {
      return [
        for (final c in jsonDecode(json) as List)
          if (c is Map &&
              c['name'] is String &&
              (c['name'] as String).trim().isNotEmpty)
            ItemColour(
              (c['name'] as String).trim(),
              cleanHex(c['hex'] as String?),
            ),
      ];
    } on Object {
      return const [];
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ItemColour && other.name == name && other.hex == hex;

  @override
  int get hashCode => Object.hash(name, hex);
}

/// One size of an item (S, M, L, XL, 32…) with its own stock, and
/// optionally its own price and barcode. Items without sizes are "free
/// size".
@immutable
class ItemSize {
  const ItemSize({
    required this.size,
    this.id,
    this.position = 0,
    this.price,
    this.barcode,
    this.stock = Quantity.zero,
    this.isActive = true,
  });

  final int? id;
  final String size;
  final int position;

  /// `null`: the item's price.
  final Money? price;
  final String? barcode;

  /// Read-only here: only the stock ledger changes it.
  final Quantity stock;
  final bool isActive;

  /// The price this size sells at.
  Money priceOf(Item item) => price ?? item.salePrice;

  ItemSize copyWith({
    int? id,
    String? size,
    int? position,
    Money? Function()? price,
    String? Function()? barcode,
    Quantity? stock,
    bool? isActive,
  }) => ItemSize(
    id: id ?? this.id,
    size: size ?? this.size,
    position: position ?? this.position,
    price: price != null ? price() : this.price,
    barcode: barcode != null ? barcode() : this.barcode,
    stock: stock ?? this.stock,
    isActive: isActive ?? this.isActive,
  );

  @override
  bool operator ==(Object other) =>
      other is ItemSize &&
      other.id == id &&
      other.size == size &&
      other.position == position &&
      other.price == price &&
      other.barcode == barcode &&
      other.stock == stock &&
      other.isActive == isActive;

  @override
  int get hashCode =>
      Object.hash(id, size, position, price, barcode, stock, isActive);
}

/// What a scanned code is: an item, or one size of an item.
typedef ItemMatch = ({Item item, ItemSize? size});

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

  /// The item's sizes in order (active ones only, unless asked); empty for
  /// a free-size item.
  Future<List<ItemSize>> sizesOf(int itemId, {bool includeRemoved = false});

  Stream<List<ItemSize>> watchSizes(int itemId);

  /// Makes the item's sizes match [sizes] (in that order): new ones are
  /// added, changed ones updated, missing ones hidden (old bills keep
  /// them). Stock isn't touched here. Returns the saved sizes.
  /// Throws [DuplicateBarcodeException] if a barcode is taken.
  Future<List<ItemSize>> saveSizes(int itemId, List<ItemSize> sizes);

  /// The item, or the item and size, with exactly this barcode.
  Future<ItemMatch?> byAnyBarcode(String barcode);
}
