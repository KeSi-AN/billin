import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/data/drift_returns_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/data/drift_party_repository.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/data/drift_expense_repository.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/purchases/data/drift_purchase_repository.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/data/report_loader.dart';
import 'package:shop_app/features/reports/domain/gst_report.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

String gstin(String first14) => first14 + Gstin.checkCharacter(first14);

double cell(List<List<String>> rows, int row, String column) =>
    double.parse(rows[row][rows.first.indexOf(column)]);

double columnSum(List<List<String>> rows, String column) => rows
    .skip(1)
    .fold(0, (s, r) => s + double.parse(r[rows.first.indexOf(column)]));

void main() {
  late AppDatabase db;
  late ReportLoader loader;
  late DriftBillRepository bills;
  late DriftReturnsRepository returns;
  late DriftPartyRepository parties;
  late DriftItemRepository items;
  late DriftPurchaseRepository purchases;
  late DriftExpenseRepository expenses;
  var now = DateTime(2026, 11, 2, 10);
  DateTime clock() => now = now.add(const Duration(hours: 1));

  setUpAll(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await initDateFormatting();
  });

  setUp(() async {
    now = DateTime(2026, 11, 2, 10);
    db = AppDatabase(NativeDatabase.memory());
    final shops = DriftShopProfileRepository(
      db,
      storageDir: () => throw UnimplementedError(),
    );
    await shops.save(
      ShopProfile(
        name: 'Sharma Kirana',
        stateCode: '27',
        gstin: gstin('27AAPFU0939F1Z'),
      ),
    );
    bills = DriftBillRepository(db, clock: clock);
    returns = DriftReturnsRepository(db, clock: clock);
    parties = DriftPartyRepository(db, clock: clock);
    items = DriftItemRepository(db, clock: clock);
    purchases = DriftPurchaseRepository(db, clock: clock);
    expenses = DriftExpenseRepository(db);
    loader = ReportLoader(
      shopProfiles: shops,
      bills: bills,
      returns: returns,
      purchases: purchases,
      expenses: expenses,
    );
  });
  tearDown(() => db.close());

  test('a month of trading: GSTR-1 sheets, summary and consistency', () async {
    final biscuits = await items.save(
      const Item(
        name: 'Biscuits',
        salePrice: Money.rupees(118),
        taxRate: TaxRate(1800),
        hsn: '1905',
        costPrice: Money.rupees(80),
      ),
    );
    final rice = await items.save(
      const Item(
        name: 'Rice',
        salePrice: Money.rupees(105),
        taxRate: TaxRate(500),
        hsn: '1006',
        unit: 'kg',
      ),
    );
    final b2bKarnataka = await parties.save(
      Party(name: 'Karnataka Traders', gstin: gstin('29ABCDE1234F1Z')),
    );
    final b2bLocal = await parties.save(
      Party(name: 'Pune Mart', gstin: gstin('27ABCDE1234F1Z')),
    );
    final delhiWalkIn = await parties.save(
      const Party(name: 'Tourist', stateCode: '07'),
    );

    DraftLine line(Item i, int qty) => DraftLine(
      itemId: i.id,
      name: i.name,
      unit: i.unit,
      hsn: i.hsn,
      unitPrice: i.salePrice,
      taxRate: i.taxRate,
      quantity: Quantity.whole(qty),
    );
    Future<Bill> sell(List<DraftLine> lines, {Party? to}) => bills.create(
      BillDraft(lines: lines, partyId: to?.id, customerName: to?.name),
    );

    final interB2b = await sell([
      line(biscuits, 10),
      line(rice, 4),
    ], to: b2bKarnataka);
    await sell([line(biscuits, 2)], to: b2bLocal);
    final localB2c = await sell([line(biscuits, 3), line(rice, 2)]);
    final bigInterB2c = await sell([
      line(biscuits, 1000),
    ], to: delhiWalkIn); // ₹1,18,000
    await sell([line(rice, 1)], to: delhiWalkIn); // small inter-state B2C
    final cancelled = await sell([line(biscuits, 1)]);
    await bills.cancel(cancelled.id);

    await returns.returnItems(interB2b.id, [
      (billLineId: interB2b.lines.first.id!, quantity: const Quantity.whole(2)),
    ]);
    await returns.returnItems(localB2c.id, [
      (billLineId: localB2c.lines.last.id!, quantity: Quantity.one),
    ]);

    final registered = await parties.save(
      Party(
        name: 'Metro',
        type: PartyType.supplier,
        gstin: gstin('27AAACM1234F1Z'),
      ),
    );
    await purchases.create(
      PurchaseDraft(
        partyId: registered.id,
        lines: [
          PurchaseDraftLine(
            itemId: biscuits.id,
            name: 'Biscuits',
            quantity: const Quantity.whole(100),
            unitCost: const Money.rupees(80),
            taxRate: const TaxRate(1800),
          ),
        ],
      ),
    );
    await purchases.create(
      const PurchaseDraft(
        lines: [
          PurchaseDraftLine(
            name: 'Bags',
            quantity: Quantity.whole(100),
            unitCost: Money.rupees(2),
          ),
        ],
      ),
    );
    await expenses.add(
      Expense(
        spentAt: DateTime(2026, 11, 5),
        category: 'Rent',
        amount: const Money.rupees(8000),
      ),
    );

    final input = await loader.load(DateTime(2026, 11), DateTime(2026, 12));
    final report = GstReport(input);
    final s = report.summary();
    final sheets = {for (final sh in report.workbook()) sh.name: sh.rows};

    // B2B: Karnataka invoice has 2 rates → 2 IGST rows; Pune → 1 CGST/SGST row.
    final b2b = sheets['B2B']!;
    expect(b2b.length - 1, 3);
    final karnatakaRows = b2b
        .where((r) => r.contains(interB2b.invoiceNo))
        .toList();
    expect(karnatakaRows, hasLength(2));
    expect(
      karnatakaRows.every(
        (r) => r[5] == '29-Karnataka' && r[11] == '0.00' && r[12] == '0.00',
      ),
      isTrue,
    );
    final puneRow = b2b.firstWhere((r) => r[0] == gstin('27ABCDE1234F1Z'));
    expect(puneRow[10], '0.00'); // no IGST in-state
    expect(
      double.parse(puneRow[11]) + double.parse(puneRow[12]),
      36.0,
    ); // 2 × ₹18

    // B2CL: only the big Delhi invoice.
    final b2cl = sheets['B2CL']!;
    expect(b2cl.length - 1, 1);
    expect(b2cl[1][0], bigInterB2c.invoiceNo);
    expect(b2cl[1][3], '07-Delhi');

    // CDNR: the B2B return, IGST.
    final cdnr = sheets['CDNR']!;
    expect(cdnr.length - 1, 1);
    expect(cdnr[1][2], 'CN/26-27/0001');
    expect(cell(cdnr, 1, 'Taxable Value'), 200.0);
    expect(cell(cdnr, 1, 'Integrated Tax'), 36.0);

    // Docs: 6 invoices, 1 cancelled; 2 credit notes.
    final docs = sheets['Docs']!;
    expect(docs[1].sublist(3), ['6', '1']);
    expect(docs[2].sublist(1, 4), ['CN/26-27/0001', 'CN/26-27/0002', '2']);

    // Consistency: what the GST tables declare equals sales − returns.
    final declaredTaxable =
        columnSum(b2b, 'Taxable Value') +
        columnSum(b2cl, 'Taxable Value') +
        columnSum(sheets['B2CS']!, 'Taxable Value') -
        columnSum(cdnr, 'Taxable Value');
    final returnsTaxable = input.creditNotes.fold(
      Money.zero,
      (t, n) => t + n.taxable,
    );
    expect(
      declaredTaxable,
      closeTo((s.salesTaxable - returnsTaxable).paise / 100, 0.001),
    );
    final hsnTaxable =
        columnSum(sheets['HSN B2B']!, 'Taxable Value') +
        columnSum(sheets['HSN B2C']!, 'Taxable Value');
    expect(hsnTaxable, closeTo(declaredTaxable, 0.001));

    // Summary: GST payable = output − returns − ITC (registered supplier only).
    expect(s.billCount, 5);
    expect(s.cancelledCount, 1);
    expect(s.totalInputTax, const Money.rupees(1440)); // 18% on ₹8,000
    expect(s.gstPayable, s.netOutputTax - s.totalInputTax);
    expect(s.expenses, const Money.rupees(8000));
    expect(s.profitIsPartial, isTrue); // rice has no cost
    expect(s.purchases, const Money.rupees(9640));

    // Writes a real workbook that opens and reads back by tab name.
    final bytes = writeWorkbook(report.workbook());
    final b2bBack = readXlsx(bytes, sheetName: 'B2B');
    expect(b2bBack.length, b2b.length);
    expect(readXlsx(bytes, sheetName: 'Summary')[1], ['Shop', 'Sharma Kirana']);
  });

  test('missing HSN is flagged; a non-GST shop is noted', () async {
    await DriftShopProfileRepository(
      db,
      storageDir: () => throw UnimplementedError(),
    ).save(const ShopProfile(name: 'Small Shop', stateCode: '27'));
    await bills.create(
      const BillDraft(
        lines: [
          DraftLine(
            name: 'Soap',
            unitPrice: Money.rupees(118),
            taxRate: TaxRate(1800),
          ),
        ],
      ),
    );
    final report = GstReport(
      await loader.load(DateTime(2026, 11), DateTime(2026, 12)),
    );
    expect(report.warnings(), [
      'Missing HSN code on: Soap',
      'The shop has no GSTIN: these are not GST invoices.',
    ]);
  });

  test('tax split keeps every paisa', () {
    final t = splitTax(const Money.paise(1525), interState: false);
    expect(t.cgst + t.sgst, const Money.paise(1525));
    expect(
      splitTax(const Money.paise(1525), interState: true).igst,
      const Money.paise(1525),
    );
  });
}
