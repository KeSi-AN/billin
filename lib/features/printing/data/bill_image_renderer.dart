import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart' show Barcode, BarcodeBar;
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// The bill as a picture for WhatsApp: what the printed bill shows (same
/// template switches: logo, phone, address, GSTIN, customer, GST summary,
/// UPI QR, footer), laid out as a clean white card.
class BillImageRenderer {
  const BillImageRenderer({this.fontFamily});

  /// `null`: the phone's normal font.
  final String? fontFamily;

  /// Drawn [width] points wide at [scale] pixels per point (1080 px).
  static const width = 600.0;
  static const scale = 1.8;

  static const _ink = Color(0xFF111111);
  static const _muted = Color(0xFF555555);
  static const _pad = 28.0;
  static final _date = DateFormat('d MMM, yyyy h:mm a', 'en_US');

  /// PNG bytes of [bill]. [logo] is the shop logo file's bytes, if any.
  Future<Uint8List> render(
    Bill bill,
    ShopProfile shop,
    AppSettingsData settings, {
    Uint8List? logo,
  }) async {
    final t = settings.receiptTemplate;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..scale(scale)
      ..drawRect(
        const Rect.fromLTWH(0, 0, width, 20000),
        Paint()..color = const Color(0xFFFFFFFF),
      );
    const inner = width - 2 * _pad;
    var y = _pad;

    TextPainter text(
      String s, {
      double size = 15,
      bool bold = false,
      Color color = _ink,
      TextAlign align = TextAlign.left,
      double maxWidth = inner,
    }) => TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          color: color,
          height: 1.3,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    void centered(String s, {double size = 15, bool bold = false}) {
      final p = text(s, size: size, bold: bold, align: TextAlign.center);
      p.paint(canvas, Offset(_pad + (inner - p.width) / 2, y));
      y += p.height + 2;
    }

    void rule() {
      y += 10;
      final paint = Paint()
        ..color = const Color(0xFFBBBBBB)
        ..strokeWidth = 1;
      for (var x = _pad; x < width - _pad; x += 6) {
        canvas.drawLine(Offset(x, y), Offset(x + 3, y), paint);
      }
      y += 12;
    }

    /// Label on the left, value on the right, on one line.
    void pair(
      String label,
      String value, {
      double size = 15,
      bool bold = false,
      Color color = _ink,
    }) {
      final v = text(value, size: size, bold: bold, color: color);
      final l = text(
        label,
        size: size,
        bold: bold,
        color: color,
        maxWidth: inner - v.width - 12,
      )..paint(canvas, Offset(_pad, y));
      // The value hugs the right edge.
      final right = Offset(width - _pad - v.width, y);
      v.paint(canvas, right);
      y += math.max(l.height, v.height) + 4;
    }

    /// `Label: value` with the value in bold.
    TextPainter field(String label, String value, {double maxWidth = inner}) =>
        TextPainter(
          text: TextSpan(
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 15,
              color: _muted,
              height: 1.3,
            ),
            children: [
              TextSpan(text: '$label: '),
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

    // Header: logo, name, phone, address, GSTIN, note.
    if (t.showLogo && logo != null) {
      final image = await _decode(logo);
      if (image != null) {
        const w = inner * 0.42;
        final h = w * image.height / image.width;
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH((width - w) / 2, y, w, h),
          Paint()..filterQuality = FilterQuality.high,
        );
        y += h + 12;
        image.dispose();
      }
    }
    if (t.showShopName) centered(shop.name, size: 17, bold: true);
    if (t.showPhone && shop.phone != null) centered(shop.phone!);
    if (t.showAddress) {
      final address = [
        shop.addressLine,
        shop.city,
        stateByCode(shop.stateCode)?.name,
        shop.pincode,
      ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
      if (address.isNotEmpty) centered('${t.addressLabel}$address', size: 14);
    }
    if (t.showGstin && shop.gstin != null) centered('GSTIN: ${shop.gstin}');
    for (final l in t.headerNote.split('\n')) {
      if (l.trim().isNotEmpty) centered(l.trim(), size: 14);
    }
    if (bill.isCancelled) centered('CANCELLED', size: 18, bold: true);
    if (shop.gstin != null) centered('TAX INVOICE', bold: true);
    rule();

    // Bill details.
    final date = field('Date', _date.format(bill.billedAt));
    if (t.showBillNo) {
      final no = field(
        'Bill No',
        bill.invoiceNo,
        maxWidth: inner - date.width - 12,
      )..paint(canvas, Offset(_pad, y));
      final right = Offset(width - _pad - date.width, y);
      date.paint(canvas, right);
      y += math.max(no.height, date.height) + 8;
    } else {
      date.paint(canvas, Offset(_pad, y));
      y += date.height + 8;
    }
    void detail(String label, String value) {
      final p = field(label, value)..paint(canvas, Offset(_pad, y));
      y += p.height + 6;
    }

    detail('Payment', _mode(bill.paymentMode));
    if (t.showCustomer) {
      if (bill.customerName case final name?
          when name.isNotEmpty && name != bill.customerPhone) {
        detail('Customer', name);
      }
      if (bill.customerPhone case final phone? when phone.isNotEmpty) {
        detail('Mobile No', phone);
      }
    }
    if (bill.buyerGstin != null) detail('Buyer GSTIN', bill.buyerGstin!);
    if (bill.placeOfSupply != null) {
      detail(
        'Place of supply',
        stateByCode(bill.placeOfSupply)?.name ?? bill.placeOfSupply!,
      );
    }
    rule();

    // Items: name (wrapping) | qty | rate | amount.
    const amountW = 100.0;
    final rateW = t.showRate ? 90.0 : 0.0;
    const qtyW = 56.0;
    final nameW = inner - amountW - rateW - qtyW;
    void cells(
      String name,
      String qty,
      String rate,
      String amount, {
      bool head = false,
    }) {
      final style = head ? _muted : _ink;
      final n = text(
        name,
        size: 15,
        bold: !head,
        color: style,
        maxWidth: nameW - 8,
      );
      final q = text(qty, size: 15, color: style);
      final r = text(rate, size: 15, color: style);
      final a = text(amount, size: 15, bold: !head, color: style);
      n.paint(canvas, Offset(_pad, y));
      q.paint(canvas, Offset(_pad + nameW + qtyW - q.width, y));
      if (rateW > 0) {
        r.paint(canvas, Offset(_pad + nameW + qtyW + rateW - r.width, y));
      }
      a.paint(canvas, Offset(width - _pad - a.width, y));
      y += math.max(n.height, a.height) + 6;
    }

    cells('Item', 'Qty', 'Rate', 'Amount', head: true);
    var subtotal = Money.zero;
    for (final l in bill.lines) {
      final gross = l.total + l.discount + l.billDiscountShare - _addedTax(l);
      subtotal += gross;
      cells(l.name, _qty(l), _amt(l.unitPrice), _amt(gross));
      if (!l.discount.isZero) {
        final d = text(
          'Discount −${_amt(l.discount)}',
          size: 13,
          color: _muted,
        );
        d.paint(canvas, Offset(width - _pad - d.width, y - 4));
        y += d.height;
      }
    }
    rule();

    // Totals.
    final added = bill.lines.fold(Money.zero, (s, l) => s + _addedTax(l));
    final extras = [
      if (!bill.totalDiscount.isZero || !added.isZero || !bill.roundOff.isZero)
        ('Subtotal', _amt(subtotal)),
      if (!bill.totalDiscount.isZero)
        ('Discount', '−${_amt(bill.totalDiscount)}'),
      if (!added.isZero) ('GST', '+${_amt(added)}'),
      if (!bill.roundOff.isZero) ('Round off', _signed(bill.roundOff)),
    ];
    for (final (label, value) in extras) {
      pair(label, value, color: _muted);
    }
    if (extras.isNotEmpty) y += 4;
    pair('TOTAL', bill.grandTotal.format(), size: 26, bold: true);
    if (bill.due.isPositive && !bill.isCancelled) {
      pair('Paid', bill.paid.format(), color: _muted);
      pair('Balance due', bill.due.format(), bold: true);
    }

    // GST summary.
    if (t.showGstSummary && shop.gstin != null && !bill.tax.isZero) {
      rule();
      for (final b in bill.taxBuckets) {
        pair(
          'Taxable @ ${b.rate.label}',
          _amt(b.taxable),
          size: 13,
          color: _muted,
        );
        if (bill.interState) {
          pair('IGST ${b.rate.label}', _amt(b.tax), size: 13, color: _muted);
        } else {
          pair(
            'CGST ${b.rate.halfLabel}',
            _amt(b.cgst),
            size: 13,
            color: _muted,
          );
          pair(
            'SGST ${b.rate.halfLabel}',
            _amt(b.sgst),
            size: 13,
            color: _muted,
          );
        }
      }
      if (added.isZero) centered('(GST included in prices)', size: 13);
    }

    // Pay by UPI.
    final upi = ReceiptFormatter.upiUri(bill, shop, settings);
    if (upi != null) {
      rule();
      const side = 180.0;
      final paint = Paint()..color = _ink;
      for (final e in Barcode.qrCode().make(upi, width: side, height: side)) {
        if (e is BarcodeBar && e.black) {
          canvas.drawRect(
            Rect.fromLTWH(
              (width - side) / 2 + e.left,
              y + e.top,
              e.width,
              e.height,
            ),
            paint,
          );
        }
      }
      y += side + 8;
      for (final l in t.qrCaption.split('\n')) {
        if (l.trim().isNotEmpty) centered(l.trim(), bold: true);
      }
    }

    // Footer.
    final footer = [
      for (final l in t.footer.split('\n'))
        if (l.trim().isNotEmpty) l.trim(),
    ];
    if (footer.isNotEmpty) {
      rule();
      for (final l in footer) {
        centered(l, size: 14);
      }
    }
    y += _pad;

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (width * scale).round(),
      (y * scale).ceil(),
    );
    picture.dispose();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return png!.buffer.asUint8List();
  }

  static Future<ui.Image?> _decode(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      codec.dispose();
      return frame.image;
    } on Object {
      return null; // not a picture: no logo, but still a bill
    }
  }

  /// File name for the picture: `Bill_INV-A-26-27-0007.png`.
  static String fileName(Bill bill) =>
      'Bill_${bill.invoiceNo.replaceAll(RegExp('[^A-Za-z0-9-]'), '-')}.png';

  static String _mode(PaymentMode m) => switch (m) {
    PaymentMode.cash => 'Cash',
    PaymentMode.upi => 'UPI',
    PaymentMode.card => 'Card',
    PaymentMode.credit => 'Credit',
  };

  static String _qty(BillLine l) {
    final q = l.quantity.format();
    return const {'pcs', 'pc', 'nos', 'no'}.contains(l.unit.toLowerCase())
        ? q
        : '$q ${l.unit}';
  }

  static Money _addedTax(BillLine l) => l.priceIncludesTax ? Money.zero : l.tax;

  /// `1,555` or `1,555.50`: grouped, decimals only when needed.
  static String _amt(Money m) {
    final s = m.format(withSymbol: false);
    return s.endsWith('.00') ? s.substring(0, s.length - 3) : s;
  }

  static String _signed(Money m) =>
      m.isNegative ? '−${_amt(-m)}' : '+${_amt(m)}';
}
