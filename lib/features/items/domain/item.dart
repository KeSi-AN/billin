import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

part 'item.freezed.dart';

/// Units a shop commonly sells in. Stored as the short code.
const itemUnits = [
  'pcs', 'kg', 'g', 'l', 'ml', 'm', 'box', 'pack', 'dozen', 'pair', 'bottle',
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
  }) = _Item;
}

class DuplicateBarcodeException implements Exception {
  const DuplicateBarcodeException(this.barcode, this.existingItemName);

  final String barcode;
  final String existingItemName;

  @override
  String toString() =>
      'Barcode $barcode is already used by "$existingItemName"';
}

abstract interface class ItemRepository {
  /// Active items, alphabetical, optionally filtered by name or barcode.
  Stream<List<Item>> watchAll({String query = ''});

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
}
