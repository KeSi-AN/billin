import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/items/domain/item.dart';

class DriftItemRepository implements ItemRepository {
  DriftItemRepository(this._db, {this._clock = DateTime.now, this._storageDir});

  final AppDatabase _db;
  final DateTime Function() _clock;
  final Future<Directory> Function()? _storageDir;

  $ItemsTable get _items => _db.items;

  SimpleSelectStatement<$ItemsTable, ItemRow> _active() =>
      _db.select(_items)..where((t) => t.isActive.equals(true));

  Expression<bool> _matches($ItemsTable t, String query) {
    // Escape % and _ so they're matched literally, not as SQL wildcards.
    final q = _escape(query.trim().toLowerCase());
    return t.name.lower().like('%$q%', escapeChar: r'\') |
        t.barcode.like('$q%', escapeChar: r'\');
  }

  @override
  Stream<List<Item>> watchAll({ItemFilter filter = const ItemFilter()}) {
    final select = _active();
    if (filter.query.trim().isNotEmpty) {
      select.where((t) => _matches(t, filter.query));
    }
    final category = filter.categoryId;
    if (category != null) {
      // The category itself or any of its subcategories.
      final subs = _db.selectOnly(_db.categories)
        ..addColumns([_db.categories.id])
        ..where(_db.categories.parentId.equals(category));
      select.where(
        (t) => t.categoryId.equals(category) | t.categoryId.isInQuery(subs),
      );
    }
    switch (filter.stock) {
      case StockFilter.all:
        break;
      case StockFilter.low:
        select.where(
          (t) =>
              t.trackStock.equals(true) &
              t.lowStockMilli.isNotNull() &
              t.stockMilli.isSmallerOrEqual(t.lowStockMilli),
        );
      case StockFilter.out:
        select.where(
          (t) =>
              t.trackStock.equals(true) & t.stockMilli.isSmallerOrEqualValue(0),
        );
    }
    select.orderBy([
      switch (filter.sort) {
        ItemSort.name => (t) => OrderingTerm.asc(t.name.lower()),
        ItemSort.stockLowFirst => (t) => OrderingTerm.asc(t.stockMilli),
        ItemSort.priceHighFirst => (t) => OrderingTerm.desc(t.salePricePaise),
      },
      (t) => OrderingTerm.asc(t.name.lower()),
    ]);
    return select.watch().map((rows) => rows.map(toDomain).toList());
  }

  @override
  Future<Item?> byId(int id) async {
    final row = await (_db.select(
      _items,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : toDomain(row);
  }

  @override
  Future<Item?> byBarcode(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return null;
    final row = await (_active()..where((t) => t.barcode.equals(code)))
        .getSingleOrNull();
    return row == null ? null : toDomain(row);
  }

  @override
  Future<List<Item>> search(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];
    final select = _active()
      ..where((t) => _matches(t, query))
      ..orderBy([(t) => OrderingTerm.asc(t.name.lower())])
      ..limit(limit);
    return (await select.get()).map(toDomain).toList();
  }

  @override
  Future<Item> save(Item item) => _db.transaction(() async {
    final barcode = _blankToNull(item.barcode);
    if (barcode != null) {
      final clash = await (_db.select(
        _items,
      )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
      if (clash != null && clash.id != item.id) {
        throw DuplicateBarcodeException(barcode, clash.name);
      }
    }
    final now = _clock();
    final companion = ItemsCompanion(
      name: Value(item.name.trim()),
      barcode: Value(barcode),
      unit: Value(item.unit),
      salePricePaise: Value(item.salePrice.paise),
      mrpPaise: Value(item.mrp?.paise),
      taxRateBp: Value(item.taxRate.bp),
      priceIncludesTax: Value(item.priceIncludesTax),
      hsn: Value(_blankToNull(item.hsn)),
      trackStock: Value(item.trackStock),
      lowStockMilli: Value(item.lowStock?.milli),
      categoryId: Value(item.categoryId),
      imagePath: Value(item.imagePath),
      tracksBatches: Value(item.tracksBatches),
      altUnit: Value(item.hasAltUnit ? item.altUnit!.trim() : null),
      altUnitFactorMilli: Value(
        item.hasAltUnit ? item.altUnitFactor!.milli : null,
      ),
      altUnitPricePaise: Value(
        item.hasAltUnit ? item.altUnitPrice?.paise : null,
      ),
      // stockMilli is deliberately absent: only the stock ledger writes it.
      updatedAt: Value(now),
    );
    if (item.id == null) {
      final id = await _db
          .into(_items)
          .insert(companion.copyWith(createdAt: Value(now)));
      return (await byId(id))!;
    }
    await (_db.update(
      _items,
    )..where((t) => t.id.equals(item.id!))).write(companion);
    return (await byId(item.id!))!;
  });

  @override
  Future<void> delete(int id) async {
    await (_db.update(_items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(
        isActive: const Value(false),
        barcode: const Value(null),
        updatedAt: Value(_clock()),
      ),
    );
  }

  @override
  Future<String> importImage(String sourcePath) async {
    final base = await (_storageDir ?? () async => Directory.systemTemp)();
    final dir = Directory(p.join(base.path, 'item_images'));
    await dir.create(recursive: true);
    final ext = p.extension(sourcePath).toLowerCase();
    final target = p.join(
      dir.path,
      'item_${_clock().microsecondsSinceEpoch}${ext.isEmpty ? '.jpg' : ext}',
    );
    await File(sourcePath).copy(target);
    return target;
  }

  static Item toDomain(ItemRow r) => Item(
    id: r.id,
    name: r.name,
    barcode: r.barcode,
    unit: r.unit,
    salePrice: Money.paise(r.salePricePaise),
    mrp: r.mrpPaise == null ? null : Money.paise(r.mrpPaise!),
    taxRate: TaxRate(r.taxRateBp),
    priceIncludesTax: r.priceIncludesTax,
    hsn: r.hsn,
    trackStock: r.trackStock,
    stock: Quantity.milli(r.stockMilli),
    lowStock: r.lowStockMilli == null ? null : Quantity.milli(r.lowStockMilli!),
    categoryId: r.categoryId,
    imagePath: r.imagePath,
    tracksBatches: r.tracksBatches,
    altUnit: r.altUnit,
    altUnitFactor: r.altUnitFactorMilli == null
        ? null
        : Quantity.milli(r.altUnitFactorMilli!),
    altUnitPrice: r.altUnitPricePaise == null
        ? null
        : Money.paise(r.altUnitPricePaise!),
  );

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static String _escape(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
}
