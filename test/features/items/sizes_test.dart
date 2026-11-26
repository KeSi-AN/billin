import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/inventory/data/drift_inventory_repository.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/domain/ean.dart';

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  late AppDatabase db;
  late DriftItemRepository items;
  late DriftInventoryRepository stock;
  late DriftBillRepository bills;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    items = DriftItemRepository(db);
    stock = DriftInventoryRepository(db);
    bills = DriftBillRepository(db);
  });
  tearDown(() => db.close());

  Future<(Item, Map<String, ItemSize>)> kurti() async {
    final item = await items.save(
      const Item(
        name: 'Kurti set',
        salePrice: Money.rupees(1835),
        trackStock: true,
        colours: [ItemColour('Plum', '#6b3f6e'), ItemColour('Multicolour')],
        fabric: 'Rayon',
        care: 'Hand wash',
        description: 'Straight kurti with palazzo',
        showOnWebsite: true,
      ),
    );
    final sizes = await items.saveSizes(item.id!, const [
      ItemSize(size: 'M'),
      ItemSize(size: 'L'),
      ItemSize(size: 'XL', price: Money.rupees(1935), barcode: '2510000000013'),
    ]);
    final byName = {for (final s in sizes) s.size: s};
    await stock.addStock(
      item.id!,
      const Quantity.whole(3),
      opening: true,
      sizeId: byName['M']!.id,
    );
    await stock.addStock(
      item.id!,
      const Quantity.whole(2),
      opening: true,
      sizeId: byName['L']!.id,
    );
    return ((await items.byId(item.id!))!, byName);
  }

  Future<Map<String, Quantity>> stockBySize(int itemId) async => {
    for (final s in await items.sizesOf(itemId)) s.size: s.stock,
  };

  test(
    'details are kept; sizes keep their own stock, item has the total',
    () async {
      final (item, sizes) = await kurti();
      expect(item.colours, const [
        ItemColour('Plum', '#6b3f6e'),
        ItemColour('Multicolour'),
      ]);
      expect(
        (item.fabric, item.care, item.showOnWebsite),
        ('Rayon', 'Hand wash', true),
      );
      expect(item.description, 'Straight kurti with palazzo');
      expect(item.stock, const Quantity.whole(5));
      expect(await stockBySize(item.id!), {
        'M': const Quantity.whole(3),
        'L': const Quantity.whole(2),
        'XL': Quantity.zero,
      });
      expect(sizes['XL']!.priceOf(item), const Money.rupees(1935));
      expect(sizes['M']!.priceOf(item), const Money.rupees(1835));
    },
  );

  test(
    'selling a size takes it from that size; cancelling puts it back',
    () async {
      final (item, sizes) = await kurti();
      final bill = await bills.create(
        BillDraft(
          lines: [
            DraftLine(
              itemId: item.id,
              sizeId: sizes['M']!.id,
              size: 'M',
              name: 'Kurti set (M)',
              unitPrice: item.salePrice,
              quantity: const Quantity.whole(2),
            ),
          ],
        ),
      );
      expect(bill.lines.single.name, 'Kurti set (M)');
      expect((await stockBySize(item.id!))['M'], Quantity.one);
      expect((await items.byId(item.id!))!.stock, const Quantity.whole(3));
      final line = await db.select(db.billLines).getSingle();
      expect((line.sizeId, line.size), (sizes['M']!.id, 'M'));

      await bills.cancel(bill.id, reason: 'test');
      expect((await stockBySize(item.id!))['M'], const Quantity.whole(3));
      expect((await items.byId(item.id!))!.stock, const Quantity.whole(5));
    },
  );

  test("counting one size's stock only changes that size", () async {
    final (item, sizes) = await kurti();
    await stock.adjustStock(item.id!, Quantity.one, sizeId: sizes['L']!.id);
    expect(await stockBySize(item.id!), {
      'M': const Quantity.whole(3),
      'L': Quantity.one,
      'XL': Quantity.zero,
    });
    expect((await items.byId(item.id!))!.stock, const Quantity.whole(4));
  });

  test("a size's barcode finds the item and the size", () async {
    final (item, sizes) = await kurti();
    final match = (await items.byAnyBarcode('2510000000013'))!;
    expect((match.item.id, match.size?.size), (item.id, 'XL'));
    expect(await items.byAnyBarcode('999'), isNull);
    // Barcodes are unique across items and sizes.
    expect(
      () => items.save(
        const Item(
          name: 'Other',
          salePrice: Money.rupees(1),
          barcode: '2510000000013',
        ),
      ),
      throwsA(isA<DuplicateBarcodeException>()),
    );
  });

  test(
    'a removed size is hidden, not deleted; order follows the list',
    () async {
      final (item, sizes) = await kurti();
      await items.saveSizes(item.id!, [sizes['L']!, sizes['M']!]);
      expect(
        [for (final s in await items.sizesOf(item.id!)) s.size],
        ['L', 'M'],
      );
      final all = await items.sizesOf(item.id!, includeRemoved: true);
      expect(all.where((s) => !s.isActive).single.size, 'XL');
    },
  );

  test('a free-size item is untouched by all this', () async {
    final saree = await items.save(
      const Item(name: 'Saree', salePrice: Money.rupees(565), trackStock: true),
    );
    await stock.addStock(saree.id!, const Quantity.whole(4), opening: true);
    expect(await items.sizesOf(saree.id!), isEmpty);
    final again = (await items.byId(saree.id!))!;
    expect(
      (again.stock, again.showOnWebsite),
      (const Quantity.whole(4), false),
    );
    expect(again.colours, isEmpty);
  });

  test('size barcodes never meet item barcodes', () {
    expect(Ean.inStoreSize(7), isNot(Ean.inStore(7)));
    expect(Ean.inStoreSize(7, series: 'B'), startsWith('252'));
    expect(Ean.isValid(Ean.inStoreSize(7, series: 'B')), isTrue);
  });
}
