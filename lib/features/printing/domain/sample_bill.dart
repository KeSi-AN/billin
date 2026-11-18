import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

/// A made-up bill for previewing and test-printing the bill template. It is
/// never saved, so it uses no invoice number.
Bill sampleBill({required bool gst, DateTime? at}) {
  final rate = gst ? const TaxRate(500) : TaxRate.zero;
  final items = [
    ('kurti set', const Money.rupees(1555), Money.zero),
    ('SAREE', const Money.rupees(775), const Money.rupees(75)),
  ];
  final totals = BillCalculator.calculate([
    for (final (_, price, discount) in items)
      BillLineInput(
        unitPrice: price,
        quantity: Quantity.one,
        taxRate: rate,
        discount: discount,
      ),
  ]);
  return Bill(
    id: 0,
    invoiceNo: 'SAMPLE',
    billedAt: at ?? DateTime.now(),
    lines: [
      for (var i = 0; i < items.length; i++)
        BillLine(
          name: items[i].$1,
          unit: 'pcs',
          quantity: Quantity.one,
          unitPrice: items[i].$2,
          taxRate: rate,
          priceIncludesTax: true,
          discount: totals.lines[i].discount,
          billDiscountShare: totals.lines[i].billDiscountShare,
          taxable: totals.lines[i].taxable,
          tax: totals.lines[i].tax,
          total: totals.lines[i].total,
        ),
    ],
    itemsTotal: totals.itemsTotal,
    billDiscount: totals.billDiscount,
    taxable: totals.taxable,
    tax: totals.tax,
    roundOff: totals.roundOff,
    grandTotal: totals.grandTotal,
    paymentMode: PaymentMode.upi,
  );
}
