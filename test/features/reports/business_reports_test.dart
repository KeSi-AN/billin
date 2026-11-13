import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/data/report_loader.dart';
import 'package:shop_app/features/reports/domain/business_reports.dart';
import 'package:shop_app/features/reports/domain/report_doc.dart';
import 'package:shop_app/features/reports/domain/report_pdf.dart';
import 'package:shop_app/features/reports/presentation/period_picker.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

import '../../helpers/fakes.dart';

final AppLocalizations l10n = lookupAppLocalizations(const Locale('en'));

/// A day of trading at a small shop (all on 12 Nov 2026):
/// - cash bill: 10 Parle-G at ₹10 (5% GST included, cost ₹8 each)
/// - credit bill to Ravi: 2 kg rice at ₹60 (no GST, no cost price)
/// - a UPI bill that was cancelled
/// - 2 Parle-G returned from the cash bill (cash refund)
/// - Ravi pays ₹50 by UPI
/// - cash purchase of 24 Parle-G at ₹8 + 5%
/// - ₹500 rent in cash
Future<BusinessReports> tradingDay() async {
  final h = TestHarness(shop: testShop);
  final parle = await h.items.save(
    const Item(
      name: 'Parle-G',
      salePrice: Money.rupees(10),
      taxRate: TaxRate(500),
      costPrice: Money.rupees(8),
      trackStock: true,
    ),
  );
  h.items.setStock(parle.id!, const Quantity.whole(50));
  final rice = await h.items.save(
    const Item(name: 'Rice', salePrice: Money.rupees(60), unit: 'kg'),
  );
  final ravi = await h.parties.save(const Party(name: 'Ravi'));
  final supplier = await h.parties.save(
    const Party(name: 'Gupta', type: PartyType.supplier),
  );

  DraftLine line(Item i, int qty) => DraftLine(
    itemId: i.id,
    name: i.name,
    unit: i.unit,
    unitPrice: i.salePrice,
    taxRate: i.taxRate,
    quantity: Quantity.whole(qty),
  );
  final cashBill = await h.bills.create(BillDraft(lines: [line(parle, 10)]));
  await h.bills.create(
    BillDraft(
      lines: [line(rice, 2)],
      paymentMode: PaymentMode.credit,
      partyId: ravi.id,
      customerName: 'Ravi',
    ),
  );
  final upiBill = await h.bills.create(
    BillDraft(lines: [line(parle, 1)], paymentMode: PaymentMode.upi),
  );
  await h.bills.cancel(upiBill.id);
  await h.returns.returnItems(cashBill.id, [
    (billLineId: cashBill.lines.single.id!, quantity: const Quantity.whole(2)),
  ]);
  await h.parties.receivePayment(
    ravi.id!,
    const Money.rupees(50),
    mode: PaymentMode.upi,
  );
  await h.purchases.create(
    PurchaseDraft(
      partyId: supplier.id,
      purchasedAt: DateTime(2026, 11, 12, 9),
      lines: [
        PurchaseDraftLine(
          itemId: parle.id,
          name: parle.name,
          quantity: const Quantity.whole(24),
          unitCost: const Money.rupees(8),
          taxRate: parle.taxRate,
        ),
      ],
    ),
  );
  await h.expenses.add(
    Expense(
      spentAt: DateTime(2026, 11, 12, 18),
      category: 'Rent',
      amount: const Money.rupees(500),
    ),
  );

  final input = await ReportLoader(
    shopProfiles: h.shopProfiles,
    bills: h.bills,
    returns: h.returns,
    purchases: h.purchases,
    expenses: h.expenses,
    items: h.items,
    parties: h.parties,
  ).load(DateTime(2026, 11), DateTime(2026, 12));
  return BusinessReports(input, l10n);
}

Object? summary(ReportDoc doc, String label) =>
    doc.summary.firstWhere((s) => s.$1 == label).$2;

Money amount(ReportDoc doc, String label) =>
    (summary(doc, label)! as Amount).value;

void main() {
  setUpAll(initDateFormatting);

  test('sales: counts completed bills, takes returns off', () async {
    final doc = (await tradingDay()).sales();
    expect(summary(doc, l10n.rpBills), 2);
    expect(amount(doc, l10n.rpSalesAmount), const Money.rupees(220));
    expect(amount(doc, l10n.rpReturns), const Money.rupees(20));
    expect(amount(doc, l10n.rpNetSales), const Money.rupees(200));
    // ₹4.76 on the cash bill − ₹0.95 on the return.
    expect(amount(doc, l10n.rpGstCollected), const Money.paise(381));
    expect(amount(doc, l10n.rpAverageBill), const Money.rupees(110));
    expect(doc.notes, ['1 cancelled bill is not counted']);

    final byDay = doc.tables.first;
    expect(byDay.rows, hasLength(1));
    expect(cellText(byDay.totals!.last), '₹220.00');
    expect(byDay.numericColumns, {1, 2, 3, 4, 5, 6});
  });

  test('profit & loss: cost of goods only where cost is known', () async {
    final doc = (await tradingDay()).profitLoss();
    // 95.24 + 120 − 19.05 (returned share of the cash bill).
    expect(amount(doc, l10n.rpSalesExGst), const Money.paise(19619));
    // 8 Parle-G kept at ₹8.
    expect(amount(doc, l10n.rpCogs), const Money.rupees(-64));
    // (95.24 − 19.05) − 64; rice has no cost so it's left out.
    expect(amount(doc, l10n.rpGrossProfit), const Money.paise(1219));
    expect(amount(doc, l10n.rpExpenses), const Money.rupees(-500));
    expect(amount(doc, l10n.rpNetProfit), const Money.paise(-48781));
    expect(doc.notes.single, contains('₹120.00'));
    expect(doc.tables.single.rows.single.first, 'Rent');
  });

  test('item-wise: net of returns, biggest seller first', () async {
    final rows = (await tradingDay()).itemWise().tables.single.rows;
    expect(rows.map((r) => r.first), ['Rice', 'Parle-G']);
    expect(cellText(rows[1][1]), '8');
    expect(cellText(rows[1][3]), '₹80.00');
    expect(cellText(rows[1][4]), '₹12.19');
    expect(rows[0][4], isNull); // no cost price, no profit
  });

  test('customer-wise: walk-ins grouped, payments and dues', () async {
    final rows = (await tradingDay()).customerWise().tables.single.rows;
    expect(rows.map((r) => r.first), ['Ravi', 'Walk-in customers']);
    expect(cellText(rows[0][2]), '₹120.00');
    expect(cellText(rows[0][4]), '₹50.00');
    expect(cellText(rows[0][5]), '₹70.00');
    expect(cellText(rows[1][3]), '₹20.00'); // the return
  });

  test('day book: money in and out by mode, in time order', () async {
    final doc = (await tradingDay()).dayBook();
    expect(amount(doc, l10n.rpIn), const Money.rupees(150));
    expect(amount(doc, l10n.rpOut), const Money.paise(72160));
    expect(amount(doc, l10n.rpCashNet), const Money.paise(-62160));
    expect(amount(doc, l10n.rpUpiNet), const Money.rupees(50));
    final entries = doc.tables.single.rows.map((r) => r[1]).toList();
    expect(entries.first, 'Purchase'); // 9 am
    expect(entries.last, 'Expense'); // 6 pm
    expect(entries, contains('Sale on credit'));
    expect(entries, contains('Payment received'));
    expect(entries, contains('Return'));
  });

  test('stock value at cost and at sale price', () async {
    final doc = (await tradingDay()).stockValue();
    final row = doc.tables.single.rows.single; // only Parle-G tracks stock
    final stock = (row[1]! as Qty).value;
    expect((row[4]! as Amount).value, Money.paise(stock.milli * 800 ~/ 1000));
    expect((row[6]! as Amount).value, Money.paise(stock.milli * 1000 ~/ 1000));
  });

  test('purchases: list and per-supplier totals', () async {
    final doc = (await tradingDay()).purchases();
    expect(amount(doc, l10n.rpTotal), const Money.paise(20160));
    expect(doc.tables.last.rows.single.first, 'Gupta');
  });

  test('every report exports to Excel and PDF', () async {
    final reports = await tradingDay();
    for (final kind in ReportKind.values) {
      final doc = reports.build(kind);
      final xlsx = writeWorkbook(doc.sheets('Summary', 'Value'));
      final summaryRows = readXlsx(xlsx, sheetName: 'Summary');
      expect(summaryRows[1], [doc.title, doc.periodLabel]);
      final pdf = await const ReportPdf(InvoiceFonts()).build(
        doc,
        shopName: 'Sharma Kirana',
        labels: (amountsIn: 'Amounts in rupees', generated: 'Generated'),
      );
      expect(String.fromCharCodes(pdf.take(4)), '%PDF');
    }
  });

  test('periods: week from Monday, financial year from April', () {
    final now = DateTime(2026, 11, 13, 15); // a Friday
    final week = Period.of(PeriodPreset.thisWeek, now);
    expect(week.from, DateTime(2026, 11, 9));
    expect(week.to, DateTime(2026, 11, 14));
    final last = Period.of(PeriodPreset.lastMonth, now);
    expect((last.from, last.to), (DateTime(2026, 10), DateTime(2026, 11)));
    expect(Period.of(PeriodPreset.thisYear, now).from, DateTime(2026, 4));
    expect(
      Period.of(PeriodPreset.thisYear, DateTime(2027, 2)).from,
      DateTime(2026, 4),
    );
  });
}
