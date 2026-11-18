import 'package:barcode/barcode.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';

/// A receipt drawn the way the thermal printer will print it: fixed-width
/// text, the dithered logo and the real QR code.
class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({
    required this.lines,
    required this.charsPerLine,
    this.logo,
    super.key,
  });

  final List<ReceiptLine> lines;
  final int charsPerLine;
  final MonoImage? logo;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      const pad = 12.0;
      final inner = box.maxWidth - pad * 2;
      // Measure this phone's monospace font so exactly [charsPerLine]
      // characters fill the width, like on paper.
      // No letter spacing: the theme's would widen every line.
      const base = TextStyle(
        fontFamily: 'monospace',
        fontSize: 100,
        letterSpacing: 0,
        wordSpacing: 0,
      );
      final probe = TextPainter(
        text: TextSpan(text: 'M' * 40, style: base),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final perChar = probe.width / 40 / 100;
      probe.dispose();
      final fontSize = inner / (charsPerLine * perChar) * 0.99;
      final style = base.copyWith(
        fontSize: fontSize,
        height: 1.25,
        color: Colors.black,
      );
      Widget text(ReceiptLine l) {
        final s = style.copyWith(
          fontWeight: l.bold ? FontWeight.bold : FontWeight.normal,
          fontSize: l.big ? fontSize * 2 : fontSize,
        );
        return SizedBox(
          width: inner,
          child: Text(
            l.text,
            style: s,
            softWrap: false,
            // Paper doesn't follow the phone's font size setting.
            textScaler: TextScaler.noScaling,
            textAlign: switch (l.align) {
              PrintAlign.left => TextAlign.left,
              PrintAlign.center => TextAlign.center,
              PrintAlign.right => TextAlign.right,
            },
          ),
        );
      }

      return Container(
        key: const Key('receiptPreview'),
        color: Colors.white,
        padding: const EdgeInsets.all(pad),
        child: Column(
          children: [
            for (final l in lines)
              if (l.isLogo)
                if (logo != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: SizedBox(
                      width: inner,
                      height: inner * logo!.height / logo!.width,
                      child: CustomPaint(painter: _MonoPainter(logo!)),
                    ),
                  )
                else
                  const SizedBox.shrink()
              else if (l.qrData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SizedBox.square(
                    dimension: inner * 0.55,
                    child: CustomPaint(painter: _QrPainter(l.qrData!)),
                  ),
                )
              else
                text(l),
          ],
        ),
      );
    },
  );
}

class _MonoPainter extends CustomPainter {
  _MonoPainter(this.image);

  final MonoImage image;

  @override
  void paint(Canvas canvas, Size size) {
    final dot = size.width / image.width;
    final paint = Paint()..color = Colors.black;
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        if (image.isBlack(x, y)) {
          canvas.drawRect(Rect.fromLTWH(x * dot, y * dot, dot, dot), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_MonoPainter old) => old.image != image;
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.data);

  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    for (final e in Barcode.qrCode().make(
      data,
      width: size.width,
      height: size.height,
    )) {
      if (e is BarcodeBar && e.black) {
        canvas.drawRect(Rect.fromLTWH(e.left, e.top, e.width, e.height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.data != data;
}
