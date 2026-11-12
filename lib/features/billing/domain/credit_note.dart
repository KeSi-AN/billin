import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

/// How much of one bill line is coming back.
typedef ReturnLine = ({int billLineId, Quantity quantity});

class CreditNoteLine {
  const CreditNoteLine({
    required this.billLineId,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.taxRate,
    required this.taxable,
    required this.tax,
    required this.total,
    this.hsn,
  });

  final int billLineId;
  final String name;
  final String unit;
  final String? hsn;
  final Quantity quantity;
  final TaxRate taxRate;
  final Money taxable;
  final Money tax;
  final Money total;
}

/// Goods returned against a bill. Reduces sales and output GST.
class CreditNote {
  const CreditNote({
    required this.id,
    required this.noteNo,
    required this.billId,
    required this.invoiceNo,
    required this.issuedAt,
    required this.lines,
    required this.taxable,
    required this.tax,
    required this.total,
    required this.refundMode,
    this.reason,
  });

  final int id;

  /// `CN/26-27/0001`
  final String noteNo;
  final int billId;
  final String invoiceNo;
  final DateTime issuedAt;
  final List<CreditNoteLine> lines;
  final Money taxable;
  final Money tax;
  final Money total;

  /// `credit` when taken off the customer's dues; otherwise how cash went
  /// back.
  final PaymentMode refundMode;
  final String? reason;
}

class ReturnTooLargeException implements Exception {
  const ReturnTooLargeException(this.itemName);

  final String itemName;

  @override
  String toString() => 'More "$itemName" than is left to return';
}

abstract interface class ReturnsRepository {
  /// Issues a credit note: puts tracked stock back, and either reduces the
  /// customer's dues (credit bills) or records a refund by [refundMode].
  /// Throws [ReturnTooLargeException] if a line returns more than is left.
  Future<CreditNote> returnItems(
    int billId,
    List<ReturnLine> lines, {
    PaymentMode refundMode = PaymentMode.cash,
    String? reason,
  });

  Future<List<CreditNote>> forBill(int billId);

  /// Oldest first; `from <= issuedAt < to`.
  Future<List<CreditNote>> between(DateTime from, DateTime to);
}
