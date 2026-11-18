import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/upi.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/printing/domain/receipt_template.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// Lays a bill out as a thermal-printer receipt, following the shop's
/// [ReceiptTemplate]:
///
/// ```text
///              [logo]
///          Sadiya Fashion
///            9849985750
///  Address: 8-4-31, Nauka Nagar, ...
///       GSTIN: 37ABCDE1234F1Z5
/// ------------------------------------------------
/// Bill No: INV/26-27/0001
/// Date: 24 Sep 2026 06:43:05 PM
/// Payment: UPI
/// ------------------------------------------------
/// ITEM                    QTY.     RATE    AMOUNT
/// ------------------------------------------------
/// kurti set                  1     1555      1555
/// SAREE                      1      775       775
///                                      Disc : -75
/// ------------------------------------------------
/// Total Qty: 2
/// ------------------------------------------------
/// Subtotal:                                  2330
/// Total Discount:                             -75
/// ------------------------------------------------
/// TOTAL                                   Rs 2255
/// ------------------------------------------------
///                 [UPI QR for Rs 2255]
///                   SCAN TO PAY
/// ------------------------------------------------
///        Thank you for shopping with us!
///                  Visit again
/// ```
///
/// Pure function of its inputs: tests check the exact text, and a reprint
/// is always identical to the first print.
class ReceiptFormatter {
  const ReceiptFormatter({required this.width});

  /// Characters per line: 32 on 58mm paper, 48 on 80mm.
  final int width;

  /// Column widths: item, quantity, rate, amount (they add up to [width]).
  (int, int, int, int) _columns({required bool rate}) {
    final (item, qty, r, amount) = width >= 48 ? (22, 6, 9, 11) : (13, 4, 7, 8);
    final extra = width - (item + qty + r + amount);
    return rate
        ? (item + extra, qty, r, amount)
        : (item + extra + r, qty, 0, amount);
  }

  /// The receipt as lines (also what [bytes] prints).
  List<ReceiptLine> lines(
    Bill bill,
    ShopProfile shop,
    AppSettingsData settings,
  ) {
    final t = settings.receiptTemplate;
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
    void right(String s) => out.add(ReceiptLine(_fit(s, width, right: true)));
    void rule() => out.add(ReceiptLine('-' * width));
    void lines(String s, {bool bold = false}) {
      for (final l in s.split('\n')) {
        if (l.trim().isNotEmpty) {
          text(l.trim(), align: PrintAlign.center, bold: bold);
        }
      }
    }

    // Header.
    final logo = t.showLogo && shop.logoPath != null;
    if (logo) out.add(const ReceiptLine.logo());
    if (t.showShopName) {
      // Under a logo the name is a plain line; on its own it stands out.
      text(shop.name, align: PrintAlign.center, bold: !logo, big: !logo);
    }
    if (t.showPhone && shop.phone != null) {
      text(shop.phone!, align: PrintAlign.center);
    }
    if (t.showAddress) {
      final address = [
        shop.addressLine,
        shop.city,
        stateByCode(shop.stateCode)?.name,
        shop.pincode,
      ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
      if (address.isNotEmpty) {
        text('${t.addressLabel}$address', align: PrintAlign.center);
      }
    }
    if (t.showGstin && shop.gstin != null) {
      text('GSTIN: ${shop.gstin}', align: PrintAlign.center);
    }
    lines(t.headerNote);
    if (bill.isCancelled) {
      text('*** CANCELLED ***', align: PrintAlign.center, bold: true);
    }
    if (shop.gstin != null) {
      text('TAX INVOICE', align: PrintAlign.center, bold: true);
    }
    rule();

    // Bill details.
    if (t.showBillNo) text('Bill No: ${bill.invoiceNo}');
    text('Date: ${_date.format(bill.billedAt)}');
    text('Payment: ${_mode(bill.paymentMode)}');
    if (t.showCustomer) {
      final customer = [
        bill.customerName,
        bill.customerPhone,
      ].whereType<String>().join(', ');
      if (customer.isNotEmpty) text('Customer: $customer');
    }
    if (bill.buyerGstin != null) text('Buyer GSTIN: ${bill.buyerGstin}');
    if (bill.placeOfSupply != null) {
      text(
        'Place of supply: ${stateByCode(bill.placeOfSupply)?.name ?? bill.placeOfSupply}',
      );
    }
    rule();

    // Items.
    final (itemW, qtyW, rateW, amountW) = _columns(rate: t.showRate);
    String row(String item, String qty, String rate, String amount) =>
        '${_fit(item, itemW - 1)} ${_fit(qty, qtyW, right: true)}${rateW == 0 ? '' : _fit(rate, rateW, right: true)}${_fit(amount, amountW, right: true)}';
    out.add(ReceiptLine(row('ITEM', 'QTY.', 'RATE', 'AMOUNT')));
    rule();
    var subtotal = Money.zero;
    for (final l in bill.lines) {
      final gross =
          l.total + l.discount + l.billDiscountShare - _taxAddedOnTop(l);
      subtotal += gross;
      final name = _wrap(l.name, itemW - 1);
      out.add(
        ReceiptLine(row(name.first, _qty(l), _amt(l.unitPrice), _amt(gross))),
      );
      for (final more in name.skip(1)) {
        out.add(ReceiptLine(more));
      }
      if (!l.discount.isZero) right('Disc : -${_amt(l.discount)}');
    }
    rule();
    if (t.showTotalQty) {
      text('Total Qty: ${_totalQty(bill)}');
      rule();
    }

    // Totals.
    pair('Subtotal:', _amt(subtotal));
    if (!bill.totalDiscount.isZero) {
      pair('Total Discount:', '-${_amt(bill.totalDiscount)}');
    }
    final addedTax = _exclusiveTax(bill);
    if (!addedTax.isZero) pair('GST:', '+${_amt(addedTax)}');
    if (!bill.roundOff.isZero) pair('Round off:', _signed(bill.roundOff));
    rule();
    pair('TOTAL', 'Rs ${_amt(bill.grandTotal)}', bold: true, big: t.bigTotal);
    if (bill.due.isPositive && !bill.isCancelled) {
      pair('Paid:', _amt(bill.paid));
      pair('Balance due:', 'Rs ${_amt(bill.due)}', bold: true);
    }

    // GST summary (GST invoices only).
    if (t.showGstSummary && shop.gstin != null && !bill.tax.isZero) {
      rule();
      for (final b in bill.taxBuckets) {
        pair('Taxable @${b.rate.label}:', _amt(b.taxable));
        if (bill.interState) {
          pair('  IGST ${b.rate.label}:', _amt(b.tax));
        } else {
          pair('  CGST ${b.rate.halfLabel}:', _amt(b.cgst));
          pair('  SGST ${b.rate.halfLabel}:', _amt(b.sgst));
        }
      }
      if (addedTax.isZero) text('(GST included in prices)');
    }
    rule();

    // Pay by UPI.
    final upi = upiUri(bill, shop, settings);
    if (upi != null) {
      out.add(ReceiptLine.qr(upi));
      lines(t.qrCaption, bold: true);
      rule();
    }

    // Footer.
    lines(t.footer);
    return out;
  }

  /// ESC/POS bytes for the receipt, ready to send to the printer. [logo] is
  /// the shop logo already converted for this paper (see [MonoImage]).
  Uint8List bytes(
    Bill bill,
    ShopProfile shop,
    AppSettingsData settings, {
    MonoImage? logo,
  }) {
    final b = EscPosBuilder().init();
    for (final l in lines(bill, shop, settings)) {
      switch (l) {
        case ReceiptLine(isLogo: true):
          if (logo != null) {
            b
              ..raster(
                logo.bits,
                widthBytes: logo.widthBytes,
                height: logo.height,
              )
              ..feed();
          }
        case ReceiptLine(qrData: final String data):
          b
            ..align(PrintAlign.center)
            ..qr(data, moduleSize: width >= 48 ? 8 : 6)
            ..align(PrintAlign.left);
        default:
          b
            ..align(l.align)
            ..bold(on: l.bold)
            ..size(width: l.big ? 2 : 1, height: l.big ? 2 : 1)
            ..line(l.text)
            ..size()
            ..bold(on: false);
      }
    }
    return b.align(PrintAlign.left).feed(3).cut().build();
  }

  static final _date = DateFormat('dd MMM yyyy hh:mm:ss a', 'en_US');

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

  /// The pay-by-UPI link printed as a QR, for exactly the amount to pay
  /// (what's still due on a credit bill), or `null` when the template or
  /// the bill doesn't call for one.
  static String? upiUri(Bill bill, ShopProfile shop, AppSettingsData s) {
    final id = s.upiId;
    if (id == null || id.trim().isEmpty || bill.isCancelled) return null;
    final credit = bill.paymentMode == PaymentMode.credit;
    final show = switch (s.receiptTemplate.qrMode) {
      QrMode.off => false,
      QrMode.upiAndCredit => bill.paymentMode == PaymentMode.upi || credit,
      QrMode.always => true,
    };
    final amount = credit ? bill.due : bill.grandTotal;
    if (!show || !amount.isPositive) return null;
    return upiPaymentUri(
      upiId: id,
      payeeName: shop.name,
      amount: amount,
      note: bill.invoiceNo,
    );
  }

  // GST added on top of tax-exclusive lines, shown inside the items total so
  // the printed numbers add up to TOTAL.
  static Money _taxAddedOnTop(BillLine l) =>
      l.priceIncludesTax ? Money.zero : l.tax;
  static Money _exclusiveTax(Bill b) =>
      b.lines.fold(Money.zero, (s, l) => s + _taxAddedOnTop(l));

  /// `1555`, `1555.50`, `-75`: no grouping, decimals only when needed, so
  /// numbers fit their columns.
  static String _amt(Money m) {
    final abs = m.paise.abs();
    final sign = m.isNegative ? '-' : '';
    final paise = abs % 100;
    return paise == 0
        ? '$sign${abs ~/ 100}'
        : '$sign${abs ~/ 100}.${paise.toString().padLeft(2, '0')}';
  }

  static String _qty(BillLine l) {
    final q = l.quantity.format();
    return const {'pcs', 'pc', 'nos', 'no'}.contains(l.unit.toLowerCase())
        ? q
        : '$q${l.unit}';
  }

  /// Sum of quantities when every line uses the same unit, else the number
  /// of lines (adding kg to pieces means nothing).
  static String _totalQty(Bill b) {
    final units = b.lines.map((l) => l.unit.toLowerCase()).toSet();
    if (units.length > 1) return '${b.lines.length}';
    return b.lines.fold(Quantity.zero, (s, l) => s + l.quantity).format();
  }

  /// [s] cut or padded to exactly [w] characters.
  static String _fit(String s, int w, {bool right = false}) {
    final a = EscPosBuilder.toAscii(s);
    if (a.length >= w) {
      return right ? a.substring(a.length - w) : a.substring(0, w);
    }
    return right ? a.padLeft(w) : a.padRight(w);
  }

  static String _signed(Money m) =>
      m.isNegative ? '-${_amt(-m)}' : '+${_amt(m)}';

  static String _mode(PaymentMode m) => switch (m) {
    PaymentMode.cash => 'Cash',
    PaymentMode.upi => 'UPI',
    PaymentMode.card => 'Card',
    PaymentMode.credit => 'Credit',
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
  }) : qrData = null,
       isLogo = false;

  const ReceiptLine.qr(String data)
    : text = '',
      align = PrintAlign.center,
      bold = false,
      big = false,
      qrData = data,
      isLogo = false;

  /// Where the shop logo goes.
  const ReceiptLine.logo()
    : text = '',
      align = PrintAlign.center,
      bold = false,
      big = false,
      qrData = null,
      isLogo = true;

  final String text;
  final PrintAlign align;
  final bool bold;

  /// Double width and height.
  final bool big;
  final String? qrData;
  final bool isLogo;

  @override
  String toString() => isLogo
      ? '[LOGO]'
      : qrData != null
      ? '[QR $qrData]'
      : text;
}
