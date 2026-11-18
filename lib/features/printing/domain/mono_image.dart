import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:shop_app/features/settings/domain/app_settings.dart';

/// Printable dots across the paper (203 dpi heads).
int paperDots(PaperWidth w) => switch (w) {
  PaperWidth.mm58 => 384,
  PaperWidth.mm80 => 576,
};

/// A black-and-white picture for a thermal printer: [height] rows of
/// [widthBytes] bytes, most significant bit first, 1 = black dot.
class MonoImage {
  const MonoImage({
    required this.widthBytes,
    required this.height,
    required this.bits,
  });

  /// Turns a logo (PNG/JPEG, any colours, transparency allowed) into a
  /// printable image [percent] of the paper wide, centred on the full
  /// [paperDots] width so it doesn't depend on the printer's alignment.
  /// Returns `null` if the file isn't an image.
  static MonoImage? fromEncoded(
    Uint8List encoded, {
    required int paperDots,
    int percent = 60,
    int maxHeight = 320,
  }) {
    final decoded = img.decodeImage(encoded);
    if (decoded == null) return null;
    var width = (paperDots * percent.clamp(10, 100) / 100).round();
    width -= width % 8;
    var height = (decoded.height * width / decoded.width).round();
    if (height > maxHeight) {
      width = (decoded.width * maxHeight / decoded.height).round();
      width -= width % 8;
      height = maxHeight;
    }
    if (width < 8 || height < 1) return null;
    final scaled = img.copyResize(
      decoded,
      width: width,
      height: height,
      interpolation: img.Interpolation.average,
    );

    // Luminance on a white background (transparent pixels are paper).
    final lum = Float64List(width * height);
    for (final p in scaled) {
      final a = p.aNormalized;
      final l =
          0.299 * p.rNormalized + 0.587 * p.gNormalized + 0.114 * p.bNormalized;
      lum[p.y * width + p.x] = (l * a + (1 - a)) * 255;
    }

    // Floyd–Steinberg dithering: crisp line art, readable shading.
    final widthBytes = paperDots ~/ 8;
    final left = (paperDots - width) ~/ 2;
    final bits = Uint8List(widthBytes * height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = y * width + x;
        final old = lum[i];
        final black = old < 128;
        final err = old - (black ? 0 : 255);
        if (black) {
          final px = left + x;
          bits[y * widthBytes + (px >> 3)] |= 0x80 >> (px & 7);
        }
        if (x + 1 < width) lum[i + 1] += err * 7 / 16;
        if (y + 1 < height) {
          if (x > 0) lum[i + width - 1] += err * 3 / 16;
          lum[i + width] += err * 5 / 16;
          if (x + 1 < width) lum[i + width + 1] += err * 1 / 16;
        }
      }
    }
    return MonoImage(widthBytes: widthBytes, height: height, bits: bits);
  }

  final int widthBytes;
  final int height;
  final Uint8List bits;

  int get width => widthBytes * 8;

  bool isBlack(int x, int y) =>
      bits[y * widthBytes + (x >> 3)] & (0x80 >> (x & 7)) != 0;
}
