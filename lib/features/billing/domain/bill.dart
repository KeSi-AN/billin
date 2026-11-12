import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

enum PaymentMode { cash, upi, card, credit }

enum BillStatus { completed, cancelled }

/// A line in the cart before the bill is saved.
class DraftLine {
  const DraftLine({
    required this.name,
    required this.unitPrice,
    this.quantity = Quantity.one,
    this.itemId,
    this.unit = 'pcs',
    this.hsn,
    this.taxRate = TaxRate.zero,
    this.priceIncludesTax = true,
    this.discount = Money.zero,
    this.unitFactor = Quantity.one,
  });

  final int? itemId;
  final String name;
  final String unit;
  final String? hsn;
  final Quantity quantity;
  final Money unitPrice;
  final TaxRate taxRate;
  final bool priceIncludesTax;
  final Money discount;

  /// Base units in one [unit]: 1 normally, 12 when selling a box of 12.
  final Quantity unitFactor;

  /// Stock this line takes out, in the item's base unit.
  Quantity get baseQuantity =>
      Quantity.milli(divRound(quantity.milli * unitFactor.milli, 1000));

  BillLineInput get input => BillLineInput(
    unitPrice: unitPrice,
    quantity: quantity,
    taxRate: taxRate,
    priceIncludesTax: priceIncludesTax,
    discount: discount,
  );

  DraftLine copyWith({
    Quantity? quantity,
    Money? unitPrice,
    Money? discount,
    String? name,
    String? unit,
    Quantity? unitFactor,
  }) => DraftLine(
    itemId: itemId,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    hsn: hsn,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    taxRate: taxRate,
    priceIncludesTax: priceIncludesTax,
    discount: discount ?? this.discount,
    unitFactor: unitFactor ?? this.unitFactor,
  );
}

/// Everything needed to save a bill. Totals are computed on save.
class BillDraft {
  const BillDraft({
    required this.lines,
    this.billDiscount = Money.zero,
    this.paymentMode = PaymentMode.cash,
    this.customerName,
    this.customerPhone,
    this.partyId,
    this.paidNow = Money.zero,
  });

  final List<DraftLine> lines;
  final Money billDiscount;
  final PaymentMode paymentMode;
  final String? customerName;
  final String? customerPhone;

  /// The customer. Required for credit sales.
  final int? partyId;

  /// Credit sales only: paid at the counter; the rest becomes a due.
  final Money paidNow;
}

class BillLine {
  const BillLine({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    required this.priceIncludesTax,
    required this.discount,
    required this.billDiscountShare,
    required this.taxable,
    required this.tax,
    required this.total,
    this.itemId,
    this.hsn,
    this.unitFactor = Quantity.one,
    this.id,
    this.cost,
    this.returned = Quantity.zero,
  });

  /// Database id (needed to return goods against this line).
  final int? id;
  final int? itemId;
  final String name;
  final String unit;
  final String? hsn;
  final Quantity quantity;
  final Money unitPrice;
  final TaxRate taxRate;
  final bool priceIncludesTax;
  final Money discount;
  final Money billDiscountShare;
  final Money taxable;
  final Money tax;
  final Money total;
  final Quantity unitFactor;

  /// Cost of the goods on this line (before GST), when known.
  final Money? cost;

  /// Already returned on credit notes.
  final Quantity returned;

  Quantity get returnable => quantity - returned;

  /// Taxable value minus cost: what the shop earned on this line.
  Money? get profit => cost == null ? null : taxable - cost!;
}

/// A saved bill, exactly as it was charged.
class Bill {
  const Bill({
    required this.id,
    required this.invoiceNo,
    required this.billedAt,
    required this.lines,
    required this.itemsTotal,
    required this.billDiscount,
    required this.taxable,
    required this.tax,
    required this.roundOff,
    required this.grandTotal,
    required this.paymentMode,
    this.status = BillStatus.completed,
    this.customerName,
    this.customerPhone,
    this.cancelledAt,
    this.cancelReason,
    this.partyId,
    this.due = Money.zero,
    this.interState = false,
    this.placeOfSupply,
    this.buyerGstin,
  });

  final int id;
  final String invoiceNo;
  final int? partyId;

  /// Left to pay (credit). Zero for paid bills.
  final Money due;

  /// Sold to another state: IGST instead of CGST + SGST.
  final bool interState;

  /// GST state code of the buyer, when it isn't the shop's state.
  final String? placeOfSupply;

  /// The buyer's GSTIN: a B2B invoice.
  final String? buyerGstin;

  bool get isB2B => buyerGstin != null;

  /// Profit on the lines whose cost is known; null if none are.
  Money? get profit {
    final known = lines.where((l) => l.cost != null);
    if (known.isEmpty) return null;
    return known.fold<Money>(Money.zero, (s, l) => s + l.profit!);
  }

  bool get profitIsPartial => lines.any((l) => l.cost == null);

  Money get paid => grandTotal - due;
  final DateTime billedAt;
  final List<BillLine> lines;
  final Money itemsTotal;
  final Money billDiscount;
  final Money taxable;
  final Money tax;
  final Money roundOff;
  final Money grandTotal;
  final PaymentMode paymentMode;
  final BillStatus status;
  final String? customerName;
  final String? customerPhone;
  final DateTime? cancelledAt;
  final String? cancelReason;

  bool get isCancelled => status == BillStatus.cancelled;

  Money get totalDiscount =>
      lines.fold(billDiscount, (sum, l) => sum + l.discount);

  /// GST by rate, rebuilt from the stored lines (same as at billing time).
  List<TaxBucket> get taxBuckets {
    final byRate = <int, (Money, Money)>{};
    for (final l in lines) {
      if (l.taxRate.isZero) continue;
      final (taxable, tax) = byRate[l.taxRate.bp] ?? (Money.zero, Money.zero);
      byRate[l.taxRate.bp] = (taxable + l.taxable, tax + l.tax);
    }
    return [
      for (final rate in byRate.keys.toList()..sort())
        TaxBucket(
          rate: TaxRate(rate),
          taxable: byRate[rate]!.$1,
          tax: byRate[rate]!.$2,
        ),
    ];
  }
}

/// One row in the sales list.
class BillSummary {
  const BillSummary({
    required this.id,
    required this.invoiceNo,
    required this.billedAt,
    required this.grandTotal,
    required this.paymentMode,
    required this.status,
    required this.lineCount,
    this.customerName,
    this.due = Money.zero,
  });

  final int id;
  final String invoiceNo;
  final DateTime billedAt;
  final Money grandTotal;
  final PaymentMode paymentMode;
  final BillStatus status;
  final int lineCount;
  final String? customerName;
  final Money due;

  bool get isCancelled => status == BillStatus.cancelled;
}

abstract interface class BillRepository {
  /// Calculates totals, assigns the next invoice number for the financial
  /// year, and saves the bill and its lines in one transaction.
  Future<Bill> create(BillDraft draft);

  Future<Bill?> byId(int id);

  /// Bills with `from <= billedAt < to`, newest first.
  Stream<List<BillSummary>> watchBetween(DateTime from, DateTime to);

  /// Voids a bill. Its invoice number stays used, as GST rules require.
  Future<void> cancel(int id, {String? reason});
}
