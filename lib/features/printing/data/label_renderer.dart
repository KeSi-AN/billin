import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/painting.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/domain/ean.dart';
import 'package:shop_app/features/printing/domain/label_setup.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';

/// Draws one product label the size of the label (8 dots per mm):
///
/// ```text
///  ┌──────────────────────────────┐
///  │         Sadiya Fashion       │  shop (small)
///  │        long frock            │  item name, up to 2 lines
///  │   ₹3495     MRP ₹3999        │  price (big), MRP struck through
///  │   ▌▌▌ ▌▌▌▌ ▌ ▌▌▌ ▌▌ ▌▌▌     │  barcode on whole dots
///  │          DN143018            │
///  └──────────────────────────────┘
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
    final margin = (w * 0.03).clamp(6, 16).toDouble();
    final inner = w - margin * 2;
    var y = margin * 0.6;

    TextPainter text(
      String s,
      double size, {
      bool bold = false,
      int maxLines = 1,
      TextDecoration? decoration,
    }) => TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          color: const Color(0xFF000000),
          fontSize: size,
          height: 1.1,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          decoration: decoration,
          decorationThickness: 2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: inner);

    void draw(TextPainter p) {
      p.paint(canvas, Offset(margin + (inner - p.width) / 2, y));
      y += p.height;
    }

    final barcode = item.barcode?.trim();
    final hasBarcode = barcode != null && barcode.isNotEmpty;
    // Space for the barcode and its digits at the bottom.
    final digitsSize = h * 0.11;
    final barsHeight = hasBarcode ? (h * 0.30).roundToDouble() : 0.0;
    final bottom = hasBarcode
        ? barsHeight + digitsSize * 1.15 + margin * 0.4
        : 0;

    if (setup.showShop && shopName != null && shopName.trim().isNotEmpty) {
      draw(text(shopName.trim(), h * 0.10, bold: true));
    }
    final nameLines = h - y - bottom > h * 0.45 ? 2 : 1;
    draw(text(item.name, h * 0.12, bold: true, maxLines: nameLines));
    if (setup.showPrice) {
      final price = text(
        '₹${_rupees(item.salePrice.paise)}',
        h * 0.15,
        bold: true,
      );
      final mrp = item.mrp;
      if (setup.showMrp && mrp != null && mrp > item.salePrice) {
        final m = text(
          'MRP ₹${_rupees(mrp.paise)}',
          h * 0.10,
          decoration: TextDecoration.lineThrough,
        );
        final gap = inner * 0.06;
        final total = price.width + gap + m.width;
        final left = margin + (inner - total) / 2;
        price.paint(canvas, Offset(left, y));
        m.paint(
          canvas,
          Offset(left + price.width + gap, y + (price.height - m.height) / 2),
        );
        y += price.height;
      } else {
        draw(price);
      }
    }

    if (hasBarcode) {
      final top = (h - bottom).toDouble();
      _bars(canvas, barcode, margin, inner, top, barsHeight);
      final digits = text(barcode, digitsSize);
      digits.paint(
        canvas,
        Offset(margin + (inner - digits.width) / 2, top + barsHeight),
      );
    }

    final image = await recorder.endRecording().toImage(w, h);
    final data = await image.toByteData();
    image.dispose();
    return MonoImage.fromRgba(data!.buffer.asUint8List(), width: w, height: h);
  }

  /// Bars on whole printer dots (fractional bars blur and won't scan):
  /// EAN-13/EAN-8 when valid, otherwise Code 128.
  static void _bars(
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
    if (bars.isEmpty) return;
    final module = bars.map((b) => b.width).reduce((a, b) => a < b ? a : b);
    final modules = (probe / module).round();
    final dot = (maxWidth / modules).floor().clamp(1, 4);
    final x0 = (left + (maxWidth - modules * dot) / 2).roundToDouble();
    final paint = Paint()..color = const Color(0xFF000000);
    for (final b in bars.where((b) => b.black)) {
      final start = (b.left / module).round() * dot;
      final width = (b.width / module).round() * dot;
      canvas.drawRect(
        Rect.fromLTWH(x0 + start, top, width.toDouble(), height),
        paint,
      );
    }
  }

  static String _rupees(int paise) => paise % 100 == 0
      ? '${paise ~/ 100}'
      : '${paise ~/ 100}.${(paise % 100).toString().padLeft(2, '0')}';
}
