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
      final sizeClash = await _sizeWithBarcode(barcode);
      if (sizeClash != null) throw sizeClash;
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
      costPricePaise: Value(item.costPrice?.paise),
      colours: Value(ItemColour.encodeList(item.colours)),
      fabric: Value(_blankToNull(item.fabric)),
      care: Value(_blankToNull(item.care)),
      description: Value(_blankToNull(item.description)),
      pattern: Value(_blankToNull(item.pattern)),
      showOnWebsite: Value(item.showOnWebsite),
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

    costPrice: r.costPricePaise == null ? null : Money.paise(r.costPricePaise!),
    colours: ItemColour.decodeList(r.colours),
    fabric: r.fabric,
    care: r.care,
    description: r.description,
    pattern: r.pattern,
    showOnWebsite: r.showOnWebsite,
  );

  // ---------------------------------------------------------------- sizes

  static ItemSize _size(ItemSizeRow r) => ItemSize(
    id: r.id,
    size: r.size,
    colour: r.colour,
    colourHex: r.colourHex,
    position: r.position,
    price: r.salePricePaise == null ? null : Money.paise(r.salePricePaise!),
    barcode: r.barcode,
    stock: Quantity.milli(r.stockMilli),
    isActive: r.isActive,
  );

  SimpleSelectStatement<$ItemSizesTable, ItemSizeRow> _sizes(
    int itemId, {
    bool includeRemoved = false,
  }) => _db.select(_db.itemSizes)
    ..where(
      (s) =>
          s.itemId.equals(itemId) &
          (includeRemoved ? const Constant(true) : s.isActive.equals(true)),
    )
    ..orderBy([
      (s) => OrderingTerm.asc(s.position),
      (s) => OrderingTerm.asc(s.id),
    ]);

  @override
  Future<List<ItemSize>> sizesOf(
    int itemId, {
    bool includeRemoved = false,
  }) async => (await _sizes(
    itemId,
    includeRemoved: includeRemoved,
  ).get()).map(_size).toList();

  @override
  Stream<List<ItemSize>> watchSizes(int itemId) =>
      _sizes(itemId).watch().map((rows) => rows.map(_size).toList());

  /// A size of another item already using [barcode], as the error to throw.
  Future<DuplicateBarcodeException?> _sizeWithBarcode(
    String barcode, {
    int? exceptSizeId,
  }) async {
    final row = await (_db.select(_db.itemSizes).join([
      innerJoin(_items, _items.id.equalsExp(_db.itemSizes.itemId)),
    ])..where(_db.itemSizes.barcode.equals(barcode))).getSingleOrNull();
    if (row == null) return null;
    final size = row.readTable(_db.itemSizes);
    if (size.id == exceptSizeId) return null;
    return DuplicateBarcodeException(
      barcode,
      '${row.readTable(_items).name} (${_size(size).label})',
    );
  }

  @override
  Future<List<ItemSize>> saveSizes(int itemId, List<ItemSize> sizes) =>
      _db.transaction(() async {
        final now = _clock();
        final kept = <int>{};
        for (final (i, s) in sizes.indexed) {
          final name = s.size.trim();
          final colour = _blankToNull(s.colour);
          if (name.isEmpty && colour == null) continue;
          final barcode = _blankToNull(s.barcode);
          if (barcode != null) {
            final item = await (_db.select(
              _items,
            )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
            if (item != null) {
              throw DuplicateBarcodeException(barcode, item.name);
            }
            final clash = await _sizeWithBarcode(barcode, exceptSizeId: s.id);
            if (clash != null) throw clash;
          }
          final companion = ItemSizesCompanion(
            size: Value(name),
            colour: Value(colour),
            colourHex: Value(
              colour == null ? null : ItemColour.cleanHex(s.colourHex),
            ),
            position: Value(i),
            salePricePaise: Value(s.price?.paise),
            barcode: Value(barcode),
            isActive: const Value(true),
          );
          if (s.id == null) {
            kept.add(
              await _db
                  .into(_db.itemSizes)
                  .insert(
                    companion.copyWith(
                      itemId: Value(itemId),
                      createdAt: Value(now),
                    ),
                  ),
            );
          } else {
            await (_db.update(
              _db.itemSizes,
            )..where((t) => t.id.equals(s.id!))).write(companion);
            kept.add(s.id!);
          }
        }
        // Sizes taken off the list are hidden, not deleted (old bills).
        await (_db.update(_db.itemSizes)..where(
              (t) =>
                  t.itemId.equals(itemId) &
                  t.isActive.equals(true) &
                  t.id.isNotIn(kept),
            ))
            .write(const ItemSizesCompanion(isActive: Value(false)));
        return await sizesOf(itemId);
      });

  @override
  Future<ItemMatch?> byAnyBarcode(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return null;
    final item = await byBarcode(code);
    if (item != null) return (item: item, size: null);
    final row =
        await (_db.select(_db.itemSizes).join([
              innerJoin(_items, _items.id.equalsExp(_db.itemSizes.itemId)),
            ])..where(
              _db.itemSizes.barcode.equals(code) &
                  _db.itemSizes.isActive.equals(true) &
                  _items.isActive.equals(true),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    return (
      item: toDomain(row.readTable(_items)),
      size: _size(row.readTable(_db.itemSizes)),
    );
  }

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static String _escape(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
}
