// Export rows must keep every column, empty or not, so conditional
// expressions (not `if` elements, which would drop cells) are intended.
// ignore_for_file: prefer_if_elements_to_conditional_expressions

import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';

/// The columns of the item sheet, in export order. Import also accepts the
/// common alternative names shopkeepers use, in any order and any case.
enum ItemColumn {
  name('Item name', ['name', 'item', 'product', 'product name', 'item name']),
  barcode('Barcode', ['barcode', 'ean', 'ean code', 'bar code', 'upc']),
  salePrice('Selling price', [
    'selling price',
    'sale price',
    'price',
    'rate',
    'sp',
  ]),
  mrp('MRP', ['mrp']),
  unit('Unit', ['unit', 'uom']),
  gst('GST %', ['gst %', 'gst', 'gst rate', 'tax %', 'tax', 'tax rate']),
  priceIncludesGst('Price includes GST', [
    'price includes gst',
    'inclusive',
    'incl gst',
    'tax inclusive',
  ]),
  hsn('HSN', ['hsn', 'hsn code', 'hsn/sac', 'sac']),
  category('Category', ['category', 'group']),
  subcategory('Subcategory', ['subcategory', 'sub category', 'sub-category']),
  stock('Opening stock', ['opening stock', 'stock', 'qty', 'quantity']),
  lowStock('Low stock at', ['low stock at', 'reorder level', 'min stock']);

  ItemColumn(this.header, this.aliases);

  final String header;
  final List<String> aliases;

  static ItemColumn? match(String header) {
    final h = header.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    for (final c in values) {
      if (c.aliases.contains(h) || c.header.toLowerCase() == h) return c;
    }
    return null;
  }
}

enum RowAction { create, update, skip }

/// One parsed row of the sheet.
class ImportRow {
  ImportRow({required this.rowNumber});

  /// As Excel numbers it (header is row 1).
  final int rowNumber;
  final errors = <String>[];
  Item? item;
  String? category;
  String? subcategory;
  Quantity? openingStock;
  RowAction action = RowAction.skip;

  /// Set when the row updates an existing item.
  Item? existing;

  bool get isValid => errors.isEmpty;
}

class ImportPlan {
  ImportPlan(this.rows, {this.unknownHeaders = const []});

  final List<ImportRow> rows;

  /// Headers that weren't recognised (shown, then ignored).
  final List<String> unknownHeaders;

  Iterable<ImportRow> get valid => rows.where((r) => r.isValid);
  Iterable<ImportRow> get invalid => rows.where((r) => !r.isValid);
  int get creates => valid.where((r) => r.action == RowAction.create).length;
  int get updates => valid.where((r) => r.action == RowAction.update).length;
}

class ImportResult {
  const ImportResult({
    required this.created,
    required this.updated,
    required this.failed,
  });

  final int created;
  final int updated;
  final int failed;
}

/// Turns a sheet into a checked plan, then applies it.
///
/// Matching: an existing item with the same barcode is updated; otherwise
/// one with the same name (ignoring case) is; otherwise a new item is made.
/// Stock is only set for new items: changing stock of existing items goes
/// through Adjust, so the ledger keeps a reason for it.
class ItemImporter {
  const ItemImporter({required this.items, required this.inventory});

  final ItemRepository items;
  final InventoryRepository inventory;

  Future<ImportPlan> plan(Rows sheet) async {
    if (sheet.isEmpty) {
      throw const SpreadsheetException('The file is empty');
    }
    final header = sheet.first;
    final columns = <ItemColumn, int>{};
    final unknown = <String>[];
    for (var i = 0; i < header.length; i++) {
      if (header[i].trim().isEmpty) continue;
      final c = ItemColumn.match(header[i]);
      if (c == null) {
        unknown.add(header[i]);
      } else {
        columns.putIfAbsent(c, () => i);
      }
    }
    if (!columns.containsKey(ItemColumn.name) ||
        !columns.containsKey(ItemColumn.salePrice)) {
      throw const SpreadsheetException(
        'The first row must have column names, including "Item name" and '
        '"Selling price". Download the template to see the format.',
      );
    }

    // Existing items, for matching.
    final existing = await items.watchAll().first;
    final byBarcode = {
      for (final i in existing)
        if (i.barcode != null) i.barcode!: i,
    };
    final byName = {for (final i in existing) i.name.toLowerCase(): i};

    final seenBarcodes = <String, int>{};
    final rows = <ImportRow>[];
    for (var r = 1; r < sheet.length; r++) {
      final cells = sheet[r];
      String get(ItemColumn c) {
        final i = columns[c];
        return i == null || i >= cells.length ? '' : cells[i].trim();
      }

      final row = ImportRow(rowNumber: r + 1);
      rows.add(row);
      final name = get(ItemColumn.name);
      if (name.isEmpty) {
        row.errors.add('Item name is missing');
      } else if (name.length > 120) {
        row.errors.add('Item name is longer than 120 characters');
      }

      final price = _money(get(ItemColumn.salePrice));
      if (price == null) {
        row.errors.add(
          'Selling price "${get(ItemColumn.salePrice)}" is not a valid amount',
        );
      }
      final mrpText = get(ItemColumn.mrp);
      final mrp = mrpText.isEmpty ? null : _money(mrpText);
      if (mrpText.isNotEmpty && mrp == null) {
        row.errors.add('MRP "$mrpText" is not a valid amount');
      } else if (mrp != null && price != null && mrp < price) {
        row.errors.add('MRP is lower than the selling price');
      }

      final gstText = get(ItemColumn.gst);
      final gst = gstText.isEmpty ? TaxRate.zero : _gst(gstText);
      if (gst == null) {
        row.errors.add(
          'GST "$gstText" is not a valid rate (use one of '
          '${TaxRate.choices.map((r) => r.label).join(', ')})',
        );
      }

      final barcode = get(ItemColumn.barcode);
      if (barcode.isNotEmpty) {
        final first = seenBarcodes[barcode];
        if (first != null) {
          row.errors.add('Barcode $barcode is repeated (also on row $first)');
        } else {
          seenBarcodes[barcode] = row.rowNumber;
        }
      }

      final unitText = get(ItemColumn.unit).toLowerCase();
      final unit = unitText.isEmpty ? 'pcs' : _unit(unitText);
      if (unit == null) {
        row.errors.add(
          'Unit "$unitText" is not one of ${itemUnits.join(', ')}',
        );
      }

      final stockText = get(ItemColumn.stock);
      final stock = stockText.isEmpty ? null : Quantity.tryParse(stockText);
      if (stockText.isNotEmpty && stock == null) {
        row.errors.add('Opening stock "$stockText" is not a valid quantity');
      }
      final lowText = get(ItemColumn.lowStock);
      final low = lowText.isEmpty ? null : Quantity.tryParse(lowText);
      if (lowText.isNotEmpty && low == null) {
        row.errors.add('Low stock "$lowText" is not a valid quantity');
      }

      final inclusiveText = get(ItemColumn.priceIncludesGst).toLowerCase();
      final inclusive = ![
        'n',
        'no',
        'false',
        '0',
        'exclusive',
      ].contains(inclusiveText);

      if (!row.isValid) continue;

      final match =
          (barcode.isNotEmpty ? byBarcode[barcode] : null) ??
          byName[name.toLowerCase()];
      final tracks =
          stock != null || low != null || (match?.trackStock ?? false);
      final base = match ?? Item(name: name, salePrice: price!);
      row
        ..existing = match
        ..action = match == null ? RowAction.create : RowAction.update
        ..category = get(ItemColumn.category).isEmpty
            ? null
            : get(ItemColumn.category)
        ..subcategory = get(ItemColumn.subcategory).isEmpty
            ? null
            : get(ItemColumn.subcategory)
        ..openingStock = match == null ? stock : null
        ..item = base.copyWith(
          name: name,
          salePrice: price!,
          mrp: mrp,
          barcode: barcode.isEmpty ? base.barcode : barcode,
          unit: unit!,
          taxRate: gst!,
          priceIncludesTax: inclusive,
          hsn: get(ItemColumn.hsn).isEmpty ? base.hsn : get(ItemColumn.hsn),
          trackStock: tracks,
          lowStock: low ?? base.lowStock,
        );
      // A barcode already used by a *different* existing item.
      final owner = barcode.isEmpty ? null : byBarcode[barcode];
      if (owner != null && match != null && owner.id != match.id) {
        row.errors.add('Barcode $barcode already belongs to "${owner.name}"');
      }
    }
    return ImportPlan(rows, unknownHeaders: unknown);
  }

  /// Saves the valid rows. [onProgress] gets (done, total).
  Future<ImportResult> apply(
    ImportPlan plan, {
    void Function(int done, int total)? onProgress,
  }) async {
    final rows = plan.valid.toList();
    final categoryIds = <String, int>{};
    Future<int?> categoryFor(ImportRow row) async {
      if (row.category == null) return row.item!.categoryId;
      final topKey = row.category!.toLowerCase();
      final top = categoryIds[topKey] ??= (await inventory.addCategory(
        row.category!,
      )).id;
      if (row.subcategory == null) return top;
      final subKey = '$topKey/${row.subcategory!.toLowerCase()}';
      return categoryIds[subKey] ??= (await inventory.addCategory(
        row.subcategory!,
        parentId: top,
      )).id;
    }

    var created = 0;
    var updated = 0;
    var failed = 0;
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      try {
        final saved = await items.save(
          row.item!.copyWith(categoryId: await categoryFor(row)),
        );
        final stock = row.openingStock;
        if (row.action == RowAction.create &&
            stock != null &&
            stock.isPositive) {
          if (saved.tracksBatches) {
            await inventory.addStock(
              saved.id!,
              stock,
              opening: true,
              batchNo: 'OPENING',
            );
          } else {
            await inventory.addStock(saved.id!, stock, opening: true);
          }
        }
        row.action == RowAction.create ? created++ : updated++;
      } on Object catch (e) {
        row.errors.add(e.toString());
        failed++;
      }
      onProgress?.call(i + 1, rows.length);
    }
    return ImportResult(created: created, updated: updated, failed: failed);
  }

  static Money? _money(String text) => Money.tryParse(text);

  /// `18`, `18%`, `0.18` (Excel percent cells), `5.0`.
  static TaxRate? _gst(String text) {
    final cleaned = text.replaceAll('%', '').trim();
    var value = double.tryParse(cleaned);
    if (value == null) return null;
    if (value > 0 &&
        value < 1 &&
        !TaxRate.choices.contains(TaxRate((value * 100).round()))) {
      value *= 100; // 0.18 → 18
    }
    final bp = (value * 100).round();
    final rate = TaxRate(bp);
    return TaxRate.choices.contains(rate) ? rate : null;
  }

  static String? _unit(String text) {
    const aliases = {
      'pc': 'pcs',
      'piece': 'pcs',
      'pieces': 'pcs',
      'nos': 'pcs',
      'no': 'pcs',
      'kgs': 'kg',
      'kilo': 'kg',
      'gm': 'g',
      'gms': 'g',
      'gram': 'g',
      'ltr': 'l',
      'litre': 'l',
      'liter': 'l',
      'mtr': 'm',
      'metre': 'm',
      'pkt': 'pack',
      'packet': 'pack',
      'doz': 'dozen',
      'btl': 'bottle',
    };
    final u = aliases[text] ?? text;
    return itemUnits.contains(u) ? u : null;
  }
}

/// All active items as sheet rows (same columns the importer reads), so an
/// export can be edited in Excel and imported back.
Future<Rows> exportItems(
  ItemRepository items,
  InventoryRepository inventory,
) async {
  final all = await items.watchAll().first;
  final categories = await inventory.watchCategories().first;
  final byId = {for (final c in categories) c.id: c};
  final rows = <List<String>>[
    [for (final c in ItemColumn.values) c.header],
  ];
  for (final i in all) {
    final cat = byId[i.categoryId];
    final parent = cat?.parentId == null ? null : byId[cat!.parentId];
    rows.add([
      i.name,
      i.barcode ?? '',
      i.salePrice.toInput(),
      i.mrp?.toInput() ?? '',
      i.unit,
      _gstNumber(i.taxRate),
      i.priceIncludesTax ? 'Yes' : 'No',
      i.hsn ?? '',
      parent?.name ?? cat?.name ?? '',
      parent == null ? '' : cat!.name,
      i.trackStock ? i.stock.format() : '',
      i.lowStock?.format() ?? '',
    ]);
  }
  return rows;
}

/// A ready-to-fill template with two example rows.
Rows itemTemplate() => [
  [for (final c in ItemColumn.values) c.header],
  [
    'Parle-G Biscuit 100g',
    '8901719110054',
    '10',
    '10',
    'pcs',
    '5',
    'Yes',
    '1905',
    'Food',
    'Biscuits',
    '48',
    '12',
  ],
  [
    'Basmati Rice (loose)',
    '',
    '120',
    '',
    'kg',
    '0',
    'Yes',
    '',
    'Food',
    'Grains',
    '25',
    '5',
  ],
];

/// Columns written as numbers in the exported .xlsx.
const itemNumericColumns = {2, 3, 5, 10, 11};

String _gstNumber(TaxRate r) => r.label.replaceAll('%', '');
