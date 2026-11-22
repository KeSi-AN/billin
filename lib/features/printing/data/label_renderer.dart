import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/painting.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/domain/ean.dart';
import 'package:shop_app/features/printing/domain/label_setup.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';

/// Draws one product label the size of the label (8 dots per mm), laid out
/// like the shop's own labels (positions in mm for a 48 × 29 label, scaled
/// to other sizes):
///
/// ```text
///  ┌────────────────────────────────────────┐
///  │ ▌▌▌ ▌▌▌▌ ▌ ▌▌▌ ▌▌ ▌▌▌▌ ▌▌▌               │  barcode
///  │        38756                           │  its code
///  │                       Shifon Saree   ₹ │  item name
///  │ Dry wash only                        5 │  note lines
///  │ No guarantee for colour              6 │  price, sideways
///  └────────────────────────────────────────┘
/// ```
class LabelRenderer {
  const LabelRenderer();

  Future<MonoImage> render(
    Item item,
    LabelSetup setup, {
    String? shopName,
  }) async {
    final w = setup.widthDots;
    final h = setup.heightDots;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..drawRect(
        Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
        Paint()..color = const Color(0xFFFFFFFF),
      );

    // Layout in mm of a 48 × 29 label, scaled to this one.
    final sx = w / (48 * LabelSetup.dotsPerMm);
    final sy = h / (29 * LabelSetup.dotsPerMm);
    final s = math.min(sx, sy);
    double mm(double v) => v * LabelSetup.dotsPerMm * s;
    final left = setup.leftMm * LabelSetup.dotsPerMm + mm(0.5);
    final right = w - mm(1);

    // The price runs up the right edge; the rest stays left of it.
    final priceStrip = setup.showPrice ? mm(5.5) : 0.0;
    final textRight = right - priceStrip - mm(0.5);

    TextPainter text(
      String t,
      double sizeMm, {
      bool bold = false,
      double? maxWidth,
      TextAlign align = TextAlign.left,
    }) => TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
          color: const Color(0xFF000000),
          fontSize: mm(sizeMm),
          height: 1.05,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth ?? (textRight - left));

    var y = mm(2.5);

    // Barcode and its code, across the top (the full width: the price strip
    // only starts lower down).
    final code = item.barcode?.trim();
    if (code != null && code.isNotEmpty) {
      final barsHeight = mm(6).roundToDouble();
      final (x0, barsWidth) = _bars(
        canvas,
        code,
        left,
        right - left,
        y.roundToDouble(),
        barsHeight,
      );
      y += barsHeight;
      final digits = text(code, 3.4);
      digits.paint(canvas, Offset(x0 + (barsWidth - digits.width) / 2, y));
      y += digits.height + mm(0.6);
    } else if (setup.showShop && shopName != null && shopName.isNotEmpty) {
      final shop = text(shopName, 3.4, bold: true)
        ..paint(canvas, Offset(left, y));
      y += shop.height + mm(0.6);
    }

    // Item name, right-aligned next to the price.
    final name = text(item.name, 3.5, align: TextAlign.right);
    name.paint(canvas, Offset(textRight - name.width, y));
    y += name.height + mm(0.8);

    // The shop's fixed lines (care, returns…), as many as fit.
    for (final line in setup.note.split('\n')) {
      if (line.trim().isEmpty) continue;
      final p = text(line.trim(), 3.6);
      if (y + p.height > h - mm(0.8)) break;
      p.paint(canvas, Offset(left, y));
      y += p.height;
    }

    // Price, bold, reading bottom to top along the right edge.
    if (setup.showPrice) {
      final price = text(
        '₹ ${_rupees(item.salePrice.paise)}/-',
        4.4,
        bold: true,
        maxWidth: h - mm(11.5),
      );
      canvas
        ..save()
        ..translate(
          right - priceStrip + (priceStrip - price.height) / 2,
          h - mm(1.5),
        )
        ..rotate(-math.pi / 2);
      price.paint(canvas, Offset.zero);
      canvas.restore();
    }

    return await _toMono(recorder, w, h);
  }

  /// One label's worth of ruler: a line every mm from the top, longer and
  /// numbered every 5 mm, and a box along the label's edges. Printed once,
  /// it shows where the printer really starts and where the label ends.
  Future<MonoImage> renderRuler(LabelSetup setup) async {
    final w = setup.widthDots;
    final h = setup.heightDots;
    const d = LabelSetup.dotsPerMm;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..drawRect(
        Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
        Paint()..color = const Color(0xFFFFFFFF),
      );
    final ink = Paint()..color = const Color(0xFF000000);
    final box = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(1, 1, w - 2, h - 2), box);
    final x = setup.leftMm * d + 4;
    for (var mmY = 0; mmY * d < h; mmY++) {
      final long = mmY % 5 == 0;
      canvas.drawRect(
        Rect.fromLTWH(x, mmY * d.toDouble(), long ? 5.0 * d : 2.0 * d, 2),
        ink,
      );
      if (long && mmY > 0) {
        TextPainter(
            text: TextSpan(
              text: '$mmY',
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
          )
          ..layout()
          ..paint(canvas, Offset(x + 6.0 * d, mmY * d - 11.0));
      }
    }
    return await _toMono(recorder, w, h);
  }

  static Future<MonoImage> _toMono(
    ui.PictureRecorder recorder,
    int w,
    int h,
  ) async {
    final image = await recorder.endRecording().toImage(w, h);
    final data = await image.toByteData();
    image.dispose();
    return MonoImage.fromRgba(data!.buffer.asUint8List(), width: w, height: h);
  }

  /// Bars on whole printer dots (fractional bars blur and won't scan), as
  /// thick as fit in [maxWidth], left-aligned: EAN-13/EAN-8 when valid,
  /// otherwise Code 128. Returns where they start and their width.
  static (double, double) _bars(
    Canvas canvas,
    String data,
    double left,
    double maxWidth,
    double top,
    double height,
  ) {
    final type = Ean.isValid(data) && (data.length == 13 || data.length == 8)
        ? (data.length == 13 ? Barcode.ean13() : Barcode.ean8())
        : Barcode.code128();
    const probe = 10000.0;
    final bars = type
        .make(data, width: probe, height: 10)
        .whereType<BarcodeBar>()
        .toList();
    if (bars.isEmpty) return (left, 0);
    final module = bars.map((b) => b.width).reduce((a, b) => a < b ? a : b);
    final modules = (probe / module).round();
    final dot = (maxWidth / modules).floor().clamp(1, 3);
    final x0 = left.roundToDouble();
    final paint = Paint()..color = const Color(0xFF000000);
    for (final b in bars.where((b) => b.black)) {
      final start = (b.left / module).round() * dot;
      final width = (b.width / module).round() * dot;
      canvas.drawRect(
        Rect.fromLTWH(x0 + start, top, width.toDouble(), height),
        paint,
      );
    }
    return (x0, (modules * dot).toDouble());
  }

  static String _rupees(int paise) => paise % 100 == 0
      ? '${paise ~/ 100}'
      : '${paise ~/ 100}.${(paise % 100).toString().padLeft(2, '0')}';
}
