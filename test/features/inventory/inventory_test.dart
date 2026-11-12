import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/inventory/data/drift_inventory_repository.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';

void main() {
  late AppDatabase db;
  late DriftItemRepository items;
  late DriftInventoryRepository inventory;
  late DriftBillRepository bills;
  var now = DateTime(2026, 11, 12, 10);
  DateTime clock() => now;

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  setUp(() {
    now = DateTime(2026, 11, 12, 10);
    db = AppDatabase(NativeDatabase.memory());
    items = DriftItemRepository(db, clock: clock);
    inventory = DriftInventoryRepository(db, clock: clock);
    bills = DriftBillRepository(db, clock: clock);
  });
  tearDown(() => db.close());

  Future<Item> tracked({
    String name = 'Maggi',
    int lowStock = 5,
    bool batches = false,
    String? altUnit,
    int? altFactor,
  }) => items.save(
    Item(
      name: name,
      salePrice: const Money.rupees(14),
      trackStock: true,
      lowStock: Quantity.whole(lowStock),
      tracksBatches: batches,
      altUnit: altUnit,
      altUnitFactor: altFactor == null ? null : Quantity.whole(altFactor),
      altUnitPrice: altFactor == null ? null : Money.rupees(14 * altFactor),
    ),
  );

  Future<Quantity> stockOf(Item i) async => (await items.byId(i.id!))!.stock;

  Future<Bill> sell(Item i, int qty, {String? unit, int factor = 1}) =>
      bills.create(
        BillDraft(
          lines: [
            DraftLine(
              itemId: i.id,
              name: i.name,
              unit: unit ?? i.unit,
              unitPrice: i.salePrice,
              quantity: Quantity.whole(qty),
              unitFactor: Quantity.whole(factor),
            ),
          ],
        ),
      );

  test('opening stock, stock in, adjust: ledger and balance agree', () async {
    final maggi = await tracked();
    await inventory.addStock(
      maggi.id!,
      const Quantity.whole(20),
      opening: true,
    );
    await inventory.addStock(
      maggi.id!,
      const Quantity.whole(10),
      note: 'Delivery',
    );
    await inventory.adjustStock(
      maggi.id!,
      const Quantity.whole(28),
      note: '2 damaged',
    );
    expect(await stockOf(maggi), const Quantity.whole(28));

    final history = await inventory.watchMovements(maggi.id!).first;
    expect(history.map((m) => m.type), [
      MovementType.adjust,
      MovementType.stockIn,
      MovementType.opening,
    ]);
    expect(history.map((m) => m.quantity.format()), ['-2', '10', '20']);
    expect(history.first.balanceAfter, const Quantity.whole(28));
    expect(history.first.note, '2 damaged');
  });

  test('saving an item never changes its stock', () async {
    final maggi = await tracked();
    await inventory.addStock(maggi.id!, const Quantity.whole(7));
    // A stale copy (stock 0) saved from a form must not wipe stock.
    await items.save(maggi.copyWith(salePrice: const Money.rupees(15)));
    expect(await stockOf(maggi), const Quantity.whole(7));
  });

  test(
    'a sale takes stock out; cancelling puts it back exactly once',
    () async {
      final maggi = await tracked();
      await inventory.addStock(maggi.id!, const Quantity.whole(10));
      final bill = await sell(maggi, 3);
      expect(await stockOf(maggi), const Quantity.whole(7));

      await bills.cancel(bill.id);
      await bills.cancel(bill.id); // second cancel is a no-op
      expect(await stockOf(maggi), const Quantity.whole(10));
      final types = (await inventory.watchMovements(maggi.id!).first).map(
        (m) => m.type,
      );
      expect(types, [
        MovementType.cancel,
        MovementType.sale,
        MovementType.stockIn,
      ]);
    },
  );

  test('untracked items and quick items move no stock', () async {
    final untracked = await items.save(
      const Item(name: 'Tea', salePrice: Money.rupees(10)),
    );
    await sell(untracked, 2);
    await bills.create(
      const BillDraft(
        lines: [DraftLine(name: 'Quick', unitPrice: Money.rupees(5))],
      ),
    );
    expect(await stockOf(untracked), Quantity.zero);
    expect(await db.select(db.stockMovements).get(), isEmpty);
  });

  test('selling 2 boxes of 12 takes 24 pcs', () async {
    final soap = await tracked(name: 'Soap', altUnit: 'box', altFactor: 12);
    await inventory.addStock(soap.id!, const Quantity.whole(100));
    final bill = await sell(soap, 2, unit: 'box', factor: 12);
    expect(await stockOf(soap), const Quantity.whole(76));
    expect(bill.lines.single.unitFactor, const Quantity.whole(12));
  });

  test('stock may go negative rather than block a sale', () async {
    final maggi = await tracked();
    await inventory.addStock(maggi.id!, const Quantity.whole(1));
    await sell(maggi, 3);
    expect(await stockOf(maggi), const Quantity.whole(-2));
  });

  group('batches', () {
    test('need a batch number', () async {
      final crocin = await tracked(name: 'Crocin', batches: true);
      expect(
        () => inventory.addStock(crocin.id!, const Quantity.whole(5)),
        throwsA(isA<BatchRequiredException>()),
      );
    });

    test('sales use the earliest expiry first, then go unbatched', () async {
      final crocin = await tracked(name: 'Crocin', batches: true);
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(10),
        batchNo: 'B-LATE',
        expiry: DateTime(2027, 6),
      );
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(4),
        batchNo: 'B-SOON',
        expiry: DateTime(2026, 12),
      );
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(3),
        batchNo: 'B-NODATE',
      );

      await sell(crocin, 6); // 4 from SOON, 2 from LATE
      var batches = await inventory.watchBatches(crocin.id!).first;
      expect(
        {for (final b in batches) b.batchNo: b.quantity.format()},
        {'B-LATE': '8', 'B-NODATE': '3'},
      );

      await sell(crocin, 15); // 8 LATE + 3 NODATE + 4 unbatched
      batches = await inventory.watchBatches(crocin.id!).first;
      expect(batches, isEmpty);
      expect(await stockOf(crocin), const Quantity.whole(-4));
    });

    test('cancel returns stock to the same batches', () async {
      final crocin = await tracked(name: 'Crocin', batches: true);
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(2),
        batchNo: 'A',
        expiry: DateTime(2026, 12),
      );
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(5),
        batchNo: 'B',
        expiry: DateTime(2027, 1),
      );
      final bill = await sell(crocin, 4);
      await bills.cancel(bill.id);
      final batches = await inventory.watchBatches(crocin.id!).first;
      expect(
        {for (final b in batches) b.batchNo: b.quantity.format()},
        {'A': '2', 'B': '5'},
      );
    });

    test('adding to an existing batch tops it up', () async {
      final crocin = await tracked(name: 'Crocin', batches: true);
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(2),
        batchNo: 'A',
      );
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(3),
        batchNo: 'A',
        expiry: DateTime(2027, 3),
      );
      final batches = await inventory.watchBatches(crocin.id!).first;
      expect(batches.single.quantity, const Quantity.whole(5));
      expect(batches.single.expiry, DateTime(2027, 3));
    });

    test(
      'expiring list includes expired and soon-to-expire batches with stock',
      () async {
        final crocin = await tracked(name: 'Crocin', batches: true);
        await inventory.addStock(
          crocin.id!,
          const Quantity.whole(1),
          batchNo: 'OLD',
          expiry: DateTime(2026, 10),
        );
        await inventory.addStock(
          crocin.id!,
          const Quantity.whole(1),
          batchNo: 'SOON',
          expiry: DateTime(2026, 11, 30),
        );
        await inventory.addStock(
          crocin.id!,
          const Quantity.whole(1),
          batchNo: 'FAR',
          expiry: DateTime(2027, 6),
        );
        final expiring = await inventory
            .watchExpiring(before: DateTime(2026, 12, 12))
            .first;
        expect(expiring.map((e) => e.batch.batchNo), ['OLD', 'SOON']);
        expect(expiring.first.batch.isExpiredOn(now), isTrue);
      },
    );

    test('adjusting a batch to its counted quantity', () async {
      final crocin = await tracked(name: 'Crocin', batches: true);
      await inventory.addStock(
        crocin.id!,
        const Quantity.whole(10),
        batchNo: 'A',
      );
      final batch = (await inventory.watchBatches(crocin.id!).first).single;
      await inventory.adjustStock(
        crocin.id!,
        const Quantity.whole(8),
        batchId: batch.id,
      );
      expect(
        (await inventory.watchBatches(crocin.id!).first).single.quantity,
        const Quantity.whole(8),
      );
      expect(await stockOf(crocin), const Quantity.whole(8));
    });
  });

  test('low-stock list: tracked items at or below their level', () async {
    final a = await tracked(name: 'A');
    final b = await tracked(name: 'B');
    await items.save(const Item(name: 'Untracked', salePrice: Money.rupees(1)));
    await inventory.addStock(a.id!, const Quantity.whole(5)); // at level → low
    await inventory.addStock(b.id!, const Quantity.whole(6)); // above
    final low = await inventory.watchLowStock().first;
    expect(low.map((i) => i.name), ['A']);
    expect(low.single.isLowStock, isTrue);
  });

  test(
    'categories: subcategories and case-insensitive de-duplication',
    () async {
      final food = await inventory.addCategory('Food');
      final again = await inventory.addCategory('  food ');
      final snacks = await inventory.addCategory('Snacks', parentId: food.id);
      final topSnacks = await inventory.addCategory('Snacks');
      expect(again.id, food.id);
      expect(snacks.parentId, food.id);
      expect(topSnacks.id, isNot(snacks.id));
      expect((await inventory.watchCategories().first).length, 3);
    },
  );
}
