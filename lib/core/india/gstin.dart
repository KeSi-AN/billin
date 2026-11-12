import 'package:shop_app/core/india/indian_states.dart';

enum GstinError { length, format, unknownState, checksum }

/// GSTIN (GST identification number) helpers.
///
/// Layout: 2-digit state code, 10-character PAN, entity number, `Z`, and a
/// check character computed with the official mod-36 checksum.
abstract final class Gstin {
  static const _alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static final _format = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
  );

  /// Upper-cases and strips spaces, which is how people often type it.
  static String normalize(String raw) =>
      raw.replaceAll(RegExp(r'\s'), '').toUpperCase();

  /// Returns `null` when [raw] is a valid GSTIN, otherwise the first problem.
  static GstinError? validate(String raw) {
    final gstin = normalize(raw);
    if (gstin.length != 15) return GstinError.length;
    if (!_format.hasMatch(gstin)) return GstinError.format;
    if (stateByCode(stateCode(gstin)) == null) return GstinError.unknownState;
    if (checkCharacter(gstin.substring(0, 14)) != gstin[14]) {
      return GstinError.checksum;
    }
    return null;
  }

  static String stateCode(String gstin) => normalize(gstin).substring(0, 2);

  /// The 15th character for the first 14 characters of a GSTIN.
  static String checkCharacter(String first14) {
    const mod = 36;
    var sum = 0;
    for (var i = 0; i < 14; i++) {
      final value = _alphabet.indexOf(first14[i]);
      final product = value * (i.isEven ? 1 : 2);
      sum += product ~/ mod + product % mod;
    }
    return _alphabet[(mod - sum % mod) % mod];
  }
}
