import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

/// One line as the shopkeeper entered it.
class BillLineInput {
  const BillLineInput({
    required this.unitPrice,
    required this.quantity,
    this.taxRate = TaxRate.zero,
    this.priceIncludesTax = true,
    this.discount = Money.zero,
  });

  final Money unitPrice;
  final Quantity quantity;
  final TaxRate taxRate;

  /// `true`: the price already contains GST (MRP-style, the usual case for
  /// retail). `false`: GST is added on top.
  final bool priceIncludesTax;

  /// Discount on this line, in money.
  final Money discount;
}

/// A calculated line. Every amount is exact paise.
class LineAmounts {
  const LineAmounts({
    required this.gross,
    required this.discount,
    required this.billDiscountShare,
    required this.taxable,
    required this.tax,
    required this.total,
  });

  /// Price × quantity.
  final Money gross;

  /// Line discount actually applied (capped at [gross]).
  final Money discount;

  /// This line's part of the bill-level discount.
  final Money billDiscountShare;

  /// Value before GST.
  final Money taxable;
  final Money tax;

  /// What the customer pays for this line.
  final Money total;
}

/// GST collected at one rate, for the invoice's tax summary.
class TaxBucket {
  const TaxBucket({required this.rate, required this.taxable, required this.tax});

  final TaxRate rate;
  final Money taxable;
  final Money tax;

  /// Same-state sale: GST is split equally into CGST and SGST. Any odd paisa
  /// goes to SGST so the two always add up to [tax].
  Money get cgst => Money.paise(tax.paise ~/ 2);
  Money get sgst => tax - cgst;
}

class BillTotals {
  const BillTotals({
    required this.lines,
    required this.itemsTotal,
    required this.billDiscount,
    required this.taxable,
    required this.tax,
    required this.taxBuckets,
    required this.beforeRounding,
    required this.roundOff,
    required this.grandTotal,
  });

  final List<LineAmounts> lines;

  /// Sum of line amounts after line discounts, before the bill discount.
  final Money itemsTotal;

  /// Bill discount actually applied (capped at [itemsTotal]).
  final Money billDiscount;
  final Money taxable;
  final Money tax;

  /// Non-zero GST rates, lowest first.
  final List<TaxBucket> taxBuckets;
  final Money beforeRounding;

  /// Added (positive) or removed (negative) to reach a whole rupee.
  final Money roundOff;
  final Money grandTotal;

  Money get cgst => taxBuckets.fold(Money.zero, (sum, b) => sum + b.cgst);
  Money get sgst => taxBuckets.fold(Money.zero, (sum, b) => sum + b.sgst);

  /// Line discounts plus the bill discount.
  Money get totalDiscount =>
      lines.fold(billDiscount, (sum, l) => sum + l.discount);
}

/// Bill arithmetic. Pure and deterministic: the same inputs always give the
/// same paise, which is what makes saved bills, PDFs and prints agree.
abstract final class BillCalculator {
  static BillTotals calculate(
    List<BillLineInput> inputs, {
    Money billDiscount = Money.zero,
    bool roundToRupee = true,
  }) {
    // 1. Gross and line discount.
    final gross = [
      for (final l in inputs)
        Money.paise(divRound(l.unitPrice.paise * l.quantity.milli, 1000)),
    ];
    final lineDiscount = [
      for (var i = 0; i < inputs.length; i++)
        _clamp(inputs[i].discount, Money.zero, gross[i]),
    ];
    final afterLineDiscount = [
      for (var i = 0; i < inputs.length; i++) gross[i] - lineDiscount[i],
    ];
    final itemsTotal = afterLineDiscount.fold(Money.zero, (a, b) => a + b);

    // 2. Spread the bill discount over lines in proportion to their value.
    final appliedBillDiscount = _clamp(billDiscount, Money.zero, itemsTotal);
    final shares = _allocate(appliedBillDiscount, afterLineDiscount);

    // 3. GST per line.
    final lines = <LineAmounts>[];
    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      final net = afterLineDiscount[i] - shares[i];
      final rate = input.taxRate.bp;
      final Money taxable;
      final Money tax;
      if (input.priceIncludesTax) {
        taxable = Money.paise(divRound(net.paise * 10000, 10000 + rate));
        tax = net - taxable;
      } else {
        taxable = net;
        tax = Money.paise(divRound(net.paise * rate, 10000));
      }
      lines.add(
        LineAmounts(
          gross: gross[i],
          discount: lineDiscount[i],
          billDiscountShare: shares[i],
          taxable: taxable,
          tax: tax,
          total: taxable + tax,
        ),
      );
    }

    // 4. Tax summary by rate.
    final byRate = <int, (Money, Money)>{};
    for (var i = 0; i < inputs.length; i++) {
      final rate = inputs[i].taxRate.bp;
      if (rate == 0) continue;
      final (taxable, tax) = byRate[rate] ?? (Money.zero, Money.zero);
      byRate[rate] = (taxable + lines[i].taxable, tax + lines[i].tax);
    }
    final buckets = [
      for (final rate in byRate.keys.toList()..sort())
        TaxBucket(
          rate: TaxRate(rate),
          taxable: byRate[rate]!.$1,
          tax: byRate[rate]!.$2,
        ),
    ];

    // 5. Totals and round-off.
    final taxable = lines.fold(Money.zero, (sum, l) => sum + l.taxable);
    final tax = lines.fold(Money.zero, (sum, l) => sum + l.tax);
    final beforeRounding = taxable + tax;
    final grandTotal = roundToRupee
        ? Money.paise(divRound(beforeRounding.paise, 100) * 100)
        : beforeRounding;

    return BillTotals(
      lines: lines,
      itemsTotal: itemsTotal,
      billDiscount: appliedBillDiscount,
      taxable: taxable,
      tax: tax,
      taxBuckets: buckets,
      beforeRounding: beforeRounding,
      roundOff: grandTotal - beforeRounding,
      grandTotal: grandTotal,
    );
  }

  /// Splits [amount] across [weights] proportionally. Uses the largest-
  /// remainder method so the shares always add up to [amount] exactly.
  static List<Money> _allocate(Money amount, List<Money> weights) {
    final base = weights.fold(0, (sum, w) => sum + w.paise);
    if (amount.isZero || base == 0) {
      return List.filled(weights.length, Money.zero);
    }
    final shares = <int>[];
    final remainders = <(int, int)>[]; // (remainder, index)
    for (var i = 0; i < weights.length; i++) {
      final product = amount.paise * weights[i].paise;
      shares.add(product ~/ base);
      remainders.add((product % base, i));
    }
    var leftover = amount.paise - shares.fold(0, (a, b) => a + b);
    remainders.sort((a, b) {
      final byRemainder = b.$1.compareTo(a.$1);
      return byRemainder != 0 ? byRemainder : a.$2.compareTo(b.$2);
    });
    for (final (_, index) in remainders) {
      if (leftover == 0) break;
      shares[index]++;
      leftover--;
    }
    return [for (final s in shares) Money.paise(s)];
  }

  static Money _clamp(Money value, Money min, Money max) =>
      value < min ? min : (value > max ? max : value);
}
