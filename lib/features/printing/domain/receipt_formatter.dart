import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/upi.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// Lays a bill out as a thermal-printer receipt.
///
/// Pure function of its inputs: tests check the exact text, and a reprint
/// is always identical to the first print.
class ReceiptFormatter {
  const ReceiptFormatter({required this.width});

  /// Characters per line: 32 on 58mm paper, 48 on 80mm.
  final int width;

  /// The receipt as plain text lines (also what [bytes] prints).
  List<ReceiptLine> lines(
    Bill bill,
    ShopProfile shop,
    AppSettingsData settings,
  ) {
    final out = <ReceiptLine>[];
    void text(
      String s, {
      PrintAlign align = PrintAlign.left,
      bool bold = false,
      bool big = false,
    }) {
      for (final part in _wrap(s, big ? width ~/ 2 : width)) {
        out.add(ReceiptLine(part, align: align, bold: bold, big: big));
      }
    }

    void pair(
      String left,
      String right, {
      bool bold = false,
      bool big = false,
    }) => out.add(
      ReceiptLine(
        _pair(left, right, big ? width ~/ 2 : width),
        bold: bold,
        big: big,
      ),
    );
    void rule() => out.add(ReceiptLine('-' * width));

    // Header.
    text(shop.name, align: PrintAlign.center, bold: true, big: true);
    final address = [
      shop.addressLine,
      shop.city,
      stateByCode(shop.stateCode)?.name,
      shop.pincode,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
    if (address.isNotEmpty) text(address, align: PrintAlign.center);
    if (shop.phone != null) text('Ph: ${shop.phone}', align: PrintAlign.center);
    if (shop.gstin != null) {
      text('GSTIN: ${shop.gstin}', align: PrintAlign.center);
    }
    out.add(const ReceiptLine(''));
    text(
      bill.isCancelled
          ? '*** CANCELLED ***'
          : (shop.gstin != null ? 'TAX INVOICE' : 'BILL'),
      align: PrintAlign.center,
      bold: true,
    );
    pair('No: ${bill.invoiceNo}', '');
    pair(
      DateFormat('dd/MM/yyyy', appLocale).format(bill.billedAt),
      DateFormat('h:mm a', appLocale).format(bill.billedAt).toLowerCase(),
    );
    if (bill.customerName != null) text('Customer: ${bill.customerName}');
    if (bill.customerPhone != null) text('Ph: ${bill.customerPhone}');
    rule();
    pair('Item', 'Amount', bold: true);
    rule();

    // Lines.
    for (final l in bill.lines) {
      text(l.name);
      pair(
        '  ${l.quantity.format()} ${l.unit} x ${_amt(l.unitPrice)}',
        _amt(l.total + l.discount + l.billDiscountShare - _taxAddedOnTop(l)),
      );
      if (!l.discount.isZero) pair('  Discount', '-${_amt(l.discount)}');
      if (!l.priceIncludesTax && !l.tax.isZero) {
        pair('  + GST ${l.taxRate.label}', _amt(l.tax));
      }
    }
    rule();

    // Totals.
    pair('Items total', _amt(bill.itemsTotal + _exclusiveTax(bill)));
    if (!bill.billDiscount.isZero) {
      pair('Bill discount', '-${_amt(bill.billDiscount)}');
    }
    if (!bill.roundOff.isZero) pair('Round off', _signed(bill.roundOff));
    pair('TOTAL', 'Rs.${_amt(bill.grandTotal)}', bold: true, big: true);
    text('Paid by ${_mode(bill.paymentMode)}');
    final saved = bill.totalDiscount;
    if (!saved.isZero) text('You saved Rs.${_amt(saved)}');

    // GST summary.
    if (!bill.tax.isZero) {
      rule();
      text('GST summary', bold: true);
      for (final b in bill.taxBuckets) {
        pair('Taxable @${b.rate.label}', _amt(b.taxable));
        pair('  CGST ${b.rate.halfLabel}', _amt(b.cgst));
        pair('  SGST ${b.rate.halfLabel}', _amt(b.sgst));
      }
    }

    // Footer.
    rule();
    final upi = upiUri(bill, shop, settings);
    if (upi != null) {
      text('Scan to pay with any UPI app', align: PrintAlign.center);
      out.add(ReceiptLine.qr(upi));
    }
    text(
      settings.receiptFooter ?? 'Thank you! Visit again.',
      align: PrintAlign.center,
    );
    return out;
  }

  /// ESC/POS bytes for the receipt, ready to send to the printer.
  Uint8List bytes(Bill bill, ShopProfile shop, AppSettingsData settings) {
    final b = EscPosBuilder().init();
    for (final l in lines(bill, shop, settings)) {
      if (l.qrData != null) {
        b
          ..align(PrintAlign.center)
          ..qr(l.qrData!, moduleSize: width >= 48 ? 8 : 6)
          ..align(PrintAlign.left);
        continue;
      }
      b
        ..align(l.align)
        ..bold(on: l.bold)
        ..size(width: l.big ? 2 : 1, height: l.big ? 2 : 1)
        ..line(l.text)
        ..size()
        ..bold(on: false);
    }
    return b.align(PrintAlign.left).feed(3).cut().build();
  }

  /// A short test page for the printer settings screen.
  Uint8List testPage(String printerName) {
    final b = EscPosBuilder()
      ..init()
      ..align(PrintAlign.center)
      ..bold()
      ..size(width: 2, height: 2)
      ..line('Test print')
      ..size()
      ..bold(on: false)
      ..line(printerName)
      ..line('${width == 48 ? 80 : 58}mm paper, $width characters')
      ..align(PrintAlign.left)
      ..line('-' * width)
      ..line(_pair('Left', 'Right', width))
      ..line('0123456789' * (width ~/ 10))
      ..line('-' * width)
      ..align(PrintAlign.center)
      ..line('If this looks right, you are set!');
    return b.feed(3).cut().build();
  }

  static String? upiUri(Bill bill, ShopProfile shop, AppSettingsData s) {
    final id = s.upiId;
    // Only useful when the money is still to come by UPI: UPI and credit.
    final payable =
        bill.paymentMode == PaymentMode.upi ||
        bill.paymentMode == PaymentMode.credit;
    if (id == null || bill.isCancelled || !payable) return null;
    return upiPaymentUri(
      upiId: id,
      payeeName: shop.name,
      amount: bill.grandTotal,
      note: bill.invoiceNo,
    );
  }

  // GST added on top of tax-exclusive lines, shown inside the items total so
  // the printed numbers add up to TOTAL.
  static Money _taxAddedOnTop(BillLine l) =>
      l.priceIncludesTax ? Money.zero : l.tax;
  static Money _exclusiveTax(Bill b) =>
      b.lines.fold(Money.zero, (s, l) => s + _taxAddedOnTop(l));

  static String _amt(Money m) => m.format(withSymbol: false);
  static String _signed(Money m) =>
      m.isNegative ? '-${_amt(-m)}' : '+${_amt(m)}';

  static String _mode(PaymentMode m) => switch (m) {
    PaymentMode.cash => 'Cash',
    PaymentMode.upi => 'UPI',
    PaymentMode.card => 'Card',
    PaymentMode.credit => 'Credit (due)',
  };

  /// `left ........ right` padded to [width]. If both don't fit, the left
  /// side is shortened.
  static String _pair(String left, String right, int width) {
    final l = EscPosBuilder.toAscii(left);
    final r = EscPosBuilder.toAscii(right);
    final room = width - r.length - 1;
    if (room <= 0) return r.padLeft(width);
    final trimmed = l.length > room ? l.substring(0, room) : l;
    return trimmed + ' ' * (width - trimmed.length - r.length) + r;
  }

  /// Word-wraps to [width] characters.
  static List<String> _wrap(String text, int width) {
    final words = EscPosBuilder.toAscii(text).split(' ');
    final lines = <String>[];
    var current = '';
    for (var word in words) {
      while (word.length > width) {
        if (current.isNotEmpty) {
          lines.add(current);
          current = '';
        }
        lines.add(word.substring(0, width));
        word = word.substring(width);
      }
      if (current.isEmpty) {
        current = word;
      } else if (current.length + 1 + word.length <= width) {
        current = '$current $word';
      } else {
        lines.add(current);
        current = word;
      }
    }
    if (current.isNotEmpty || lines.isEmpty) lines.add(current);
    return lines;
  }
}

class ReceiptLine {
  const ReceiptLine(
    this.text, {
    this.align = PrintAlign.left,
    this.bold = false,
    this.big = false,
  }) : qrData = null;

  const ReceiptLine.qr(String data)
    : text = '',
      align = PrintAlign.center,
      bold = false,
      big = false,
      qrData = data;

  final String text;
  final PrintAlign align;
  final bool bold;

  /// Double width and height.
  final bool big;
  final String? qrData;

  @override
  String toString() => qrData != null ? '[QR $qrData]' : text;
}
