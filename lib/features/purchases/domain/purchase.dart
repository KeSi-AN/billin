import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

/// One line of a supplier's bill, as entered.
class PurchaseDraftLine {
  const PurchaseDraftLine({
    required this.name,
    required this.quantity,
    required this.unitCost,
    this.itemId,
    this.unit = 'pcs',
    this.hsn,
    this.taxRate = TaxRate.zero,
    this.costIncludesTax = false,
    this.batchNo,
    this.expiry,
  });

  final int? itemId;
  final String name;
  final String unit;
  final String? hsn;

  /// In the item's base unit.
  final Quantity quantity;

  /// Per base unit, as on the supplier's bill.
  final Money unitCost;

  /// Suppliers usually quote before GST, so this is off by default.
  final bool costIncludesTax;
  final TaxRate taxRate;
  final String? batchNo;
  final DateTime? expiry;
}

class PurchaseDraft {
  const PurchaseDraft({
    required this.lines,
    this.partyId,
    this.supplierInvoiceNo,
    this.purchasedAt,
    this.paymentMode = PaymentMode.cash,
    this.paidNow = Money.zero,
    this.note,
    this.photoPath,
    this.supplierName,
    this.amount = Money.zero,
  });

  /// A photo-only purchase ([photoPath] set) has no lines: just the photo
  /// of the supplier's bill, its date, the supplier and maybe [amount].
  const PurchaseDraft.photo({
    required String this.photoPath,
    required DateTime this.purchasedAt,
    this.supplierName,
    this.partyId,
    this.amount = Money.zero,
    this.note,
  }) : lines = const [],
       supplierInvoiceNo = null,
       paymentMode = PaymentMode.cash,
       paidNow = Money.zero;

  final List<PurchaseDraftLine> lines;

  /// The supplier. Required when buying on credit.
  final int? partyId;
  final String? supplierInvoiceNo;

  /// The supplier bill's date; defaults to now.
  final DateTime? purchasedAt;
  final PaymentMode paymentMode;

  /// Credit purchases only: paid now; the rest is owed to the supplier.
  final Money paidNow;
  final String? note;

  /// Photo of the supplier's bill (already copied into app storage).
  final String? photoPath;

  /// Typed supplier name, when no saved supplier ([partyId]) is chosen.
  final String? supplierName;

  /// Bill total for a photo-only purchase (lines give it otherwise).
  final Money amount;
}

class PurchaseLine {
  const PurchaseLine({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.unitCost,
    required this.costIncludesTax,
    required this.taxRate,
    required this.taxable,
    required this.tax,
    required this.total,
    this.itemId,
    this.hsn,
    this.batchNo,
    this.expiry,
  });

  final int? itemId;
  final String name;
  final String unit;
  final String? hsn;
  final Quantity quantity;
  final Money unitCost;
  final bool costIncludesTax;
  final TaxRate taxRate;
  final Money taxable;
  final Money tax;
  final Money total;
  final String? batchNo;
  final DateTime? expiry;
}

class Purchase {
  const Purchase({
    required this.id,
    required this.purchasedAt,
    required this.lines,
    required this.taxable,
    required this.tax,
    required this.total,
    required this.paymentMode,
    this.partyId,
    this.supplierName,
    this.supplierGstin,
    this.supplierInvoiceNo,
    this.interState = false,
    this.due = Money.zero,
    this.note,
    this.isCancelled = false,
    this.photoPath,
  });

  final int id;
  final int? partyId;
  final String? supplierName;
  final String? supplierGstin;
  final String? supplierInvoiceNo;
  final DateTime purchasedAt;
  final List<PurchaseLine> lines;
  final bool interState;
  final Money taxable;

  /// GST paid to the supplier: input tax credit when they're registered.
  final Money tax;
  final Money total;
  final Money due;
  final PaymentMode paymentMode;
  final String? note;
  final bool isCancelled;

  /// Photo of the supplier's bill, if one was saved.
  final String? photoPath;
}

class SupplierRequiredException implements Exception {
  const SupplierRequiredException();

  @override
  String toString() => 'Choose a supplier to buy on credit';
}

abstract interface class PurchaseRepository {
  /// Saves the purchase, brings the stock in (into a batch where the item
  /// keeps batches), updates each item's cost price, and puts any unpaid
  /// amount on the supplier's account. All in one transaction.
  Future<Purchase> create(PurchaseDraft draft);

  Future<Purchase?> byId(int id);

  /// Newest first; `from <= purchasedAt < to`.
  Stream<List<Purchase>> watchBetween(DateTime from, DateTime to);

  /// Undoes a purchase: takes the stock back out and reverses what it put
  /// on the supplier's account.
  Future<void> cancel(int id);
}
