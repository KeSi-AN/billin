import 'dart:convert';
import 'dart:typed_data';

import 'package:shop_app/features/printing/domain/ean.dart';

enum PrintAlign { left, center, right }

/// Builds ESC/POS bytes: the command language virtually every cheap
/// Bluetooth thermal printer speaks.
///
/// Text is sent as plain ASCII. Thermal printers' built-in fonts rarely
/// have `₹` or Indian scripts, so [toAscii] swaps those for safe characters.
class EscPosBuilder {
  final _bytes = BytesBuilder(copy: false);

  Uint8List build() => _bytes.toBytes();

  /// Reset the printer to defaults.
  EscPosBuilder init() => _cmd([0x1B, 0x40]);

  EscPosBuilder align(PrintAlign a) => _cmd([0x1B, 0x61, a.index]);

  EscPosBuilder bold({bool on = true}) => _cmd([0x1B, 0x45, if (on) 1 else 0]);

  /// Character size multiplier, 1–8 in each direction.
  EscPosBuilder size({int width = 1, int height = 1}) {
    assert(width >= 1 && width <= 8 && height >= 1 && height <= 8, 'size 1-8');
    return _cmd([0x1D, 0x21, ((width - 1) << 4) | (height - 1)]);
  }

  /// One line of text followed by a line feed.
  EscPosBuilder line([String text = '']) {
    _bytes.add(ascii.encode(EscPosBuilder.toAscii(text)));
    return _cmd([0x0A]);
  }

  EscPosBuilder feed([int lines = 1]) => _cmd([0x1B, 0x64, lines]);

  /// A 1-D barcode with its digits printed underneath (GS k, format B).
  /// EAN-13/EAN-8 when the data is a valid EAN, otherwise Code 128, which
  /// accepts any printable text.
  EscPosBuilder barcode(String data, {int height = 80, int moduleWidth = 2}) {
    final code = data.trim();
    final List<int> payload;
    final int type;
    if (Ean.isValid(code) && code.length == 13) {
      type = 67; // EAN-13
      payload = ascii.encode(code.substring(0, 12)); // printer adds check
    } else if (Ean.isValid(code) && code.length == 8) {
      type = 68; // EAN-8
      payload = ascii.encode(code.substring(0, 7));
    } else {
      type = 73; // Code 128, code set B
      payload = [0x7B, 0x42, ...ascii.encode(toAscii(code))];
    }
    return _cmd([0x1D, 0x68, height]) // height in dots
        ._cmd([0x1D, 0x77, moduleWidth]) // bar width 2–6
        ._cmd([0x1D, 0x48, 2]) // human-readable digits below
        ._cmd([0x1D, 0x66, 0]) // font A for the digits
        ._cmd([0x1D, 0x6B, type, payload.length, ...payload])
        ._cmd([0x0A]);
  }

  /// A QR code using the printer's built-in generator (GS ( k).
  EscPosBuilder qr(String data, {int moduleSize = 6}) {
    final payload = utf8.encode(data);
    final storeLength = payload.length + 3;
    return _cmd([
          0x1D,
          0x28,
          0x6B,
          0x04,
          0x00,
          0x31,
          0x41,
          0x32,
          0x00,
        ]) // model 2
        ._cmd([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, moduleSize]) // size
        ._cmd([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 0x31]) // error level M
        ._cmd([
          0x1D,
          0x28,
          0x6B,
          storeLength & 0xFF,
          storeLength >> 8,
          0x31,
          0x50,
          0x30,
          ...payload,
        ]) // store
        ._cmd([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]); // print
  }

  /// Feed paper and cut (printers without a cutter ignore it).
  EscPosBuilder cut() => _cmd([0x1D, 0x56, 0x42, 0x00]);

  EscPosBuilder _cmd(List<int> bytes) {
    _bytes.add(bytes);
    return this;
  }

  /// Printable ASCII only: `₹` → `Rs.`, smart quotes and dashes → plain,
  /// anything else outside ASCII → `?`.
  static String toAscii(String text) {
    final replaced = text
        .replaceAll('₹', 'Rs.')
        .replaceAll(RegExp('[‘’]'), "'")
        .replaceAll(RegExp('[“”]'), '"')
        .replaceAll(RegExp('[–—−]'), '-')
        .replaceAll('×', 'x')
        .replaceAll('·', '-');
    return String.fromCharCodes(
      replaced.runes.map((r) => r >= 0x20 && r < 0x7F ? r : 0x3F),
    );
  }
}
