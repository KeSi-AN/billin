import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/items/domain/item.dart';

class DriftItemRepository implements ItemRepository {
  DriftItemRepository(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final DateTime Function() _clock;

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
  Stream<List<Item>> watchAll({String query = ''}) {
    final select = _active();
    if (query.trim().isNotEmpty) select.where((t) => _matches(t, query));
    select.orderBy([(t) => OrderingTerm.asc(t.name.lower())]);
    return select.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Item?> byId(int id) async {
    final row = await (_db.select(
      _items,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Item?> byBarcode(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return null;
    final row = await (_active()..where((t) => t.barcode.equals(code)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<List<Item>> search(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];
    final select = _active()
      ..where((t) => _matches(t, query))
      ..orderBy([(t) => OrderingTerm.asc(t.name.lower())])
      ..limit(limit);
    return (await select.get()).map(_toDomain).toList();
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
      updatedAt: Value(now),
    );
    if (item.id == null) {
      final id = await _db
          .into(_items)
          .insert(companion.copyWith(createdAt: Value(now)));
      return item.copyWith(id: id, barcode: barcode);
    }
    await (_db.update(
      _items,
    )..where((t) => t.id.equals(item.id!))).write(companion);
    return item.copyWith(barcode: barcode);
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

  static Item _toDomain(ItemRow r) => Item(
    id: r.id,
    name: r.name,
    barcode: r.barcode,
    unit: r.unit,
    salePrice: Money.paise(r.salePricePaise),
    mrp: r.mrpPaise == null ? null : Money.paise(r.mrpPaise!),
    taxRate: TaxRate(r.taxRateBp),
    priceIncludesTax: r.priceIncludesTax,
    hsn: r.hsn,
  );

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static String _escape(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
}
