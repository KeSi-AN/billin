import 'dart:math' as math;
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

  /// From raw RGBA pixels (e.g. a picture drawn on a canvas), black where
  /// darker than [threshold]. No dithering: text and bars stay crisp.
  factory MonoImage.fromRgba(
    Uint8List rgba, {
    required int width,
    required int height,
    int threshold = 160,
  }) {
    final widthBytes = (width + 7) ~/ 8;
    final bits = Uint8List(widthBytes * height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        final a = rgba[i + 3] / 255;
        final l =
            (0.299 * rgba[i] + 0.587 * rgba[i + 1] + 0.114 * rgba[i + 2]) * a +
            255 * (1 - a);
        if (l < threshold) bits[y * widthBytes + (x >> 3)] |= 0x80 >> (x & 7);
      }
    }
    return MonoImage(widthBytes: widthBytes, height: height, bits: bits);
  }

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

  /// A whole label ([widthDots] x [heightDots]) showing a picture: a
  /// picture made for exactly this label size is printed dot for dot;
  /// anything else is fitted inside a [marginDots] border and centred.
  /// Black where darker than [threshold] (no dithering: logos stay crisp).
  /// Returns `null` if the file isn't an image.
  static MonoImage? labelFromEncoded(
    Uint8List encoded, {
    required int widthDots,
    required int heightDots,
    int marginDots = 12,
    int threshold = 128,
  }) {
    final raw = img.decodeImage(encoded);
    if (raw == null || raw.width < 1 || raw.height < 1) return null;
    // 8-bit RGBA whatever the file was (1-bit, palette, grey, 16-bit...), so
    // brightness and transparency read the same way for every picture.
    final decoded = raw.convert(format: img.Format.uint8, numChannels: 4);
    final widthBytes = (widthDots + 7) ~/ 8;
    final bits = Uint8List(widthBytes * heightDots);
    var picture = decoded;
    var left = 0;
    var top = 0;
    if (decoded.width != widthDots || decoded.height != heightDots) {
      final boxW = widthDots - 2 * marginDots;
      final boxH = heightDots - 2 * marginDots;
      final scale = math.min(boxW / decoded.width, boxH / decoded.height);
      final w = math.max(1, (decoded.width * scale).round());
      final h = math.max(1, (decoded.height * scale).round());
      picture = img.copyResize(
        decoded,
        width: w,
        height: h,
        interpolation: img.Interpolation.average,
      );
      left = (widthDots - w) ~/ 2;
      top = (heightDots - h) ~/ 2;
    }
    for (final p in picture) {
      final x = left + p.x;
      final y = top + p.y;
      if (x < 0 || y < 0 || x >= widthDots || y >= heightDots) continue;
      final a = p.a / 255;
      final l = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
      if (l * a + 255 * (1 - a) < threshold) {
        bits[y * widthBytes + (x >> 3)] |= 0x80 >> (x & 7);
      }
    }
    return MonoImage(widthBytes: widthBytes, height: heightDots, bits: bits);
  }

  final int widthBytes;
  final int height;
  final Uint8List bits;

  int get width => widthBytes * 8;

  bool isBlack(int x, int y) =>
      bits[y * widthBytes + (x >> 3)] & (0x80 >> (x & 7)) != 0;
}
