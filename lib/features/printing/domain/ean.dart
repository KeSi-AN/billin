/// EAN-8 / EAN-13 barcode numbers.
abstract final class Ean {
  static final _digits = RegExp(r'^\d+$');

  /// Check digit for the digits before it (GS1 mod-10, weights 3 and 1
  /// from the right).
  static int checkDigit(String body) {
    var sum = 0;
    for (var i = 0; i < body.length; i++) {
      final digit = body.codeUnitAt(body.length - 1 - i) - 48;
      sum += i.isEven ? digit * 3 : digit;
    }
    return (10 - sum % 10) % 10;
  }

  static bool isValid(String code) {
    if (!_digits.hasMatch(code)) return false;
    if (code.length != 8 && code.length != 13) return false;
    final body = code.substring(0, code.length - 1);
    return checkDigit(body) == code.codeUnitAt(code.length - 1) - 48;
  }

  /// A barcode for an item the shop packs itself (loose rice, sweets).
  /// GS1 reserves EAN-13 numbers starting with 2 for in-store use, so these
  /// never clash with a manufacturer's barcode.
  static String inStore(int itemId) {
    final body = '2${itemId.toString().padLeft(11, '0')}';
    return '$body${checkDigit(body)}';
  }
}
