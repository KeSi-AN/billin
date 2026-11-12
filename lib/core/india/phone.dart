/// Indian mobile number helpers.
abstract final class IndianPhone {
  static final _mobile = RegExp(r'^[6-9]\d{9}$');

  /// Reduces `+91 98765 43210`, `098765-43210`, etc. to `9876543210`.
  static String normalize(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 12 && digits.startsWith('91')) {
      return digits.substring(2);
    }
    if (digits.length == 11 && digits.startsWith('0')) {
      return digits.substring(1);
    }
    return digits;
  }

  static bool isValidMobile(String raw) => _mobile.hasMatch(normalize(raw));
}

/// Indian postal PIN codes: 6 digits, never starting with 0.
bool isValidPincode(String raw) => RegExp(r'^[1-9]\d{5}$').hasMatch(raw.trim());
