import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

BillLineInput line(
  int pricePaise, {
  int qtyMilli = 1000,
  int taxBp = 0,
  bool inclusive = true,
  int discountPaise = 0,
}) => BillLineInput(
  unitPrice: Money.paise(pricePaise),
  quantity: Quantity.milli(qtyMilli),
  taxRate: TaxRate(taxBp),
  priceIncludesTax: inclusive,
  discount: Money.paise(discountPaise),
);

void main() {
  test('tax-inclusive price: GST is carved out of the price', () {
    // ₹100 incl. 18% → taxable 84.75, GST 15.25.
    final t = BillCalculator.calculate([line(10000, taxBp: 1800)]);
    expect(t.lines.single.taxable, const Money.paise(8475));
    expect(t.lines.single.tax, const Money.paise(1525));
    expect(t.grandTotal, const Money.rupees(100));
    expect(t.roundOff, Money.zero);
  });

  test('tax-exclusive price: GST is added on top', () {
    final t = BillCalculator.calculate([line(10000, taxBp: 1800, inclusive: false)]);
    expect(t.taxable, const Money.rupees(100));
    expect(t.tax, const Money.rupees(18));
    expect(t.grandTotal, const Money.rupees(118));
  });

  test('fractional quantity rounds to the nearest paisa', () {
    // 0.5 kg × ₹45.99 = ₹22.995 → ₹23.00
    final t = BillCalculator.calculate(
      [line(4599, qtyMilli: 500)],
      roundToRupee: false,
    );
    expect(t.lines.single.gross, const Money.paise(2300));
  });

  test('line discount is applied and capped at the line value', () {
    final t = BillCalculator.calculate([
      line(5000, discountPaise: 500),
      line(1000, discountPaise: 99999),
    ]);
    expect(t.lines[0].total, const Money.paise(4500));
    expect(t.lines[1].discount, const Money.paise(1000));
    expect(t.lines[1].total, Money.zero);
    expect(t.totalDiscount, const Money.paise(1500));
  });

  test('bill discount is shared proportionally and adds up exactly', () {
    final t = BillCalculator.calculate(
      [line(10000), line(20000), line(30000)],
      billDiscount: const Money.paise(100),
      roundToRupee: false,
    );
    expect(
      t.lines.map((l) => l.billDiscountShare.paise),
      [17, 33, 50],
    );
    expect(t.grandTotal, const Money.paise(59900));
  });

  test('bill discount cannot exceed the bill', () {
    final t = BillCalculator.calculate(
      [line(1000)],
      billDiscount: const Money.rupees(50),
    );
    expect(t.billDiscount, const Money.rupees(10));
    expect(t.grandTotal, Money.zero);
  });

  test('rounds to the nearest rupee, half up', () {
    var t = BillCalculator.calculate([line(12345)]);
    expect(t.grandTotal, const Money.paise(12300));
    expect(t.roundOff, const Money.paise(-45));
    t = BillCalculator.calculate([line(12350)]);
    expect(t.grandTotal, const Money.paise(12400));
    expect(t.roundOff, const Money.paise(50));
  });

  test('groups GST by rate and splits CGST/SGST without losing a paisa', () {
    final t = BillCalculator.calculate([
      line(10000, taxBp: 1800),
      line(10500, taxBp: 500),
      line(5000),
    ]);
    expect(t.taxBuckets.map((b) => b.rate), [const TaxRate(500), const TaxRate(1800)]);
    final gst18 = t.taxBuckets.last;
    expect(gst18.tax, const Money.paise(1525));
    expect(gst18.cgst, const Money.paise(762));
    expect(gst18.sgst, const Money.paise(763));
    expect(t.cgst + t.sgst, t.tax);
  });

  test('empty bill is zero', () {
    final t = BillCalculator.calculate([]);
    expect(t.grandTotal, Money.zero);
    expect(t.taxBuckets, isEmpty);
  });

  test('invariants hold for 2,000 random bills', () {
    final random = Random(42);
    for (var run = 0; run < 2000; run++) {
      final inputs = [
        for (var i = 0; i < 1 + random.nextInt(8); i++)
          line(
            random.nextInt(500000),
            qtyMilli: 1 + random.nextInt(20000),
            taxBp: TaxRate.choices[random.nextInt(TaxRate.choices.length)].bp,
            inclusive: random.nextBool(),
            discountPaise: random.nextInt(3) == 0 ? random.nextInt(50000) : 0,
          ),
      ];
      final t = BillCalculator.calculate(
        inputs,
        billDiscount: Money.paise(random.nextInt(100000)),
        roundToRupee: random.nextBool(),
      );
      final shareSum = t.lines.fold(Money.zero, (s, l) => s + l.billDiscountShare);
      final lineSum = t.lines.fold(Money.zero, (s, l) => s + l.total);
      final bucketTax = t.taxBuckets.fold(Money.zero, (s, b) => s + b.tax);

      expect(shareSum, t.billDiscount, reason: 'run $run');
      expect(lineSum, t.beforeRounding, reason: 'run $run');
      expect(bucketTax, t.tax, reason: 'run $run');
      expect(t.itemsTotal - t.billDiscount, t.beforeRounding - _exclusiveTax(inputs, t), reason: 'run $run');
      expect(t.roundOff.paise.abs() <= 50, isTrue, reason: 'run $run');
      expect(t.lines.every((l) => !l.total.isNegative && !l.tax.isNegative), isTrue);
    }
  });
}

/// GST added on top of tax-exclusive lines (inclusive lines add none).
Money _exclusiveTax(List<BillLineInput> inputs, BillTotals t) {
  var sum = Money.zero;
  for (var i = 0; i < inputs.length; i++) {
    if (!inputs[i].priceIncludesTax) sum = sum + t.lines[i].tax;
  }
  return sum;
}
