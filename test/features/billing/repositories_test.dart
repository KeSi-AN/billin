import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/settings/data/drift_settings_repository.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

void main() {
  late AppDatabase db;
  var now = DateTime(2026, 11, 12, 10);
  DateTime clock() => now;

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 12, 10);
  });
  tearDown(() => db.close());

  group('Items', () {
    late DriftItemRepository items;
    setUp(() => items = DriftItemRepository(db, clock: clock));

    const parle = Item(
      name: 'Parle-G 100g',
      salePrice: Money.rupees(10),
      barcode: '8901719110054',
      taxRate: TaxRate(500),
    );

    test('saves, finds by barcode and searches by name or barcode', () async {
      final saved = await items.save(parle);
      expect(saved.id, isNotNull);
      expect((await items.byBarcode('8901719110054'))?.name, 'Parle-G 100g');
      expect(await items.byBarcode('0000'), isNull);
      expect((await items.search('parle')).single.id, saved.id);
      expect((await items.search('890171')).single.id, saved.id);
      expect(await items.search('100%'), isEmpty);
    });

    test('rejects a barcode already used by another item', () async {
      await items.save(parle);
      expect(
        () => items.save(const Item(name: 'Other', salePrice: Money.rupees(5), barcode: '8901719110054')),
        throwsA(isA<DuplicateBarcodeException>()),
      );
    });

    test('updating an item keeps its own barcode', () async {
      final saved = await items.save(parle);
      await items.save(saved.copyWith(salePrice: const Money.rupees(11)));
      expect((await items.byId(saved.id!))?.salePrice, const Money.rupees(11));
    });

    test('delete hides the item and frees its barcode', () async {
      final saved = await items.save(parle);
      await items.delete(saved.id!);
      expect(await items.watchAll().first, isEmpty);
      expect(await items.byBarcode('8901719110054'), isNull);
      await items.save(parle.copyWith(name: 'Parle-G new pack'));
    });

    test('lists alphabetically, ignoring case', () async {
      for (final n in ['banana', 'Apple', 'cherry']) {
        await items.save(Item(name: n, salePrice: const Money.rupees(1)));
      }
      final names = (await items.watchAll().first).map((i) => i.name);
      expect(names, ['Apple', 'banana', 'cherry']);
    });
  });

  group('Bills', () {
    late DriftBillRepository bills;
    setUp(() => bills = DriftBillRepository(db, clock: clock));

    BillDraft draft({int price = 10000, int discount = 0}) => BillDraft(
      lines: [
        DraftLine(
          name: 'Rice 1kg',
          unit: 'kg',
          unitPrice: Money.paise(price),
          quantity: const Quantity.milli(1500),
          taxRate: const TaxRate(500),
        ),
        const DraftLine(name: 'Quick item', unitPrice: Money.rupees(20)),
      ],
      billDiscount: Money.paise(discount),
      paymentMode: PaymentMode.upi,
      customerName: ' Ravi ',
    );

    test('saves the bill with calculated totals and lines in order', () async {
      final bill = await bills.create(draft());
      expect(bill.invoiceNo, 'INV/26-27/0001');
      expect(bill.lines.map((l) => l.name), ['Rice 1kg', 'Quick item']);
      expect(bill.lines.first.quantity, const Quantity.milli(1500));
      expect(bill.itemsTotal, const Money.rupees(170));
      expect(bill.grandTotal, const Money.rupees(170));
      expect(bill.taxBuckets.single.rate, const TaxRate(500));
      expect(bill.paymentMode, PaymentMode.upi);
      expect(bill.customerName, 'Ravi');
    });

    test('numbers invoices in sequence and restarts each April', () async {
      final a = await bills.create(draft());
      final b = await bills.create(draft());
      now = DateTime(2027, 4, 1, 9);
      final c = await bills.create(draft());
      expect([a.invoiceNo, b.invoiceNo, c.invoiceNo], [
        'INV/26-27/0001',
        'INV/26-27/0002',
        'INV/27-28/0001',
      ]);
    });

    test('uses the invoice prefix and round-off setting', () async {
      await DriftSettingsRepository(db).save(
        const AppSettingsData(invoicePrefix: 'sk', roundToRupee: false),
      );
      final bill = await bills.create(
        const BillDraft(lines: [DraftLine(name: 'x', unitPrice: Money.paise(1234))]),
      );
      expect(bill.invoiceNo, 'SK/26-27/0001');
      expect(bill.grandTotal, const Money.paise(1234));
      expect(bill.roundOff, Money.zero);
    });

    test('cancelling keeps the number used', () async {
      final a = await bills.create(draft());
      await bills.cancel(a.id, reason: 'Wrong item');
      final cancelled = await bills.byId(a.id);
      expect(cancelled?.isCancelled, isTrue);
      expect(cancelled?.cancelReason, 'Wrong item');
      expect((await bills.create(draft())).invoiceNo, 'INV/26-27/0002');
    });

    test("lists a day's bills newest first with line counts", () async {
      final first = await bills.create(draft());
      now = now.add(const Duration(hours: 1));
      final second = await bills.create(draft());
      now = DateTime(2026, 11, 13, 9);
      await bills.create(draft()); // next day: excluded

      final day = await bills
          .watchBetween(DateTime(2026, 11, 12), DateTime(2026, 11, 13))
          .first;
      expect(day.map((b) => b.id), [second.id, first.id]);
      expect(day.first.lineCount, 2);
    });

    test('refuses an empty bill', () {
      expect(() => bills.create(const BillDraft(lines: [])), throwsArgumentError);
    });
  });

  group('Settings', () {
    test('defaults until saved, then round-trips', () async {
      final repo = DriftSettingsRepository(db);
      expect(await repo.load(), const AppSettingsData());
      const s = AppSettingsData(
        invoicePrefix: 'SK',
        upiId: 'shop@okaxis',
        paperWidth: PaperWidth.mm80,
        printerAddress: '00:11:22:33:44:55',
      );
      await repo.save(s);
      expect(await repo.load(), s);
    });

    test('UPI ID check', () {
      expect(isValidUpiId('sharma.kirana@okaxis'), isTrue);
      expect(isValidUpiId('9876543210@ybl'), isTrue);
      expect(isValidUpiId('no-at-sign'), isFalse);
      expect(isValidUpiId('a@1'), isFalse);
    });
  });
}
