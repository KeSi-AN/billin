import 'package:intl/intl.dart';

/// An amount of money in **paise** (₹1 = 100 paise).
///
/// All money in the app is stored and calculated as whole paise, never as a
/// `double`, so bill totals and GST never pick up floating-point rounding
/// errors. Convert to text only at the edges (display, PDF, print).
extension type const Money._(int paise) {
  const Money.paise(int paise) : this._(paise);
  const Money.rupees(int rupees) : this._(rupees * 100);

  static const zero = Money._(0);

  // Up to 99,99,99,99,999 rupees: far beyond any shop bill and safe in an int.
  static final _pattern = RegExp(r'^(\d{1,11})(?:\.(\d{1,2}))?$');
  static final _grouping = NumberFormat.decimalPattern('en_IN');

  /// Parses what a user types, e.g. `"1,250.5"`, `"₹ 99"`, `"0.75"`.
  ///
  /// Returns `null` for anything that is not a non-negative amount with at
  /// most two decimal places.
  static Money? tryParse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\s,₹]'), '');
    final match = _pattern.firstMatch(cleaned);
    if (match == null) return null;
    final rupees = int.parse(match.group(1)!);
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    return Money._(rupees * 100 + int.parse(fraction));
  }

  Money operator +(Money other) => Money._(paise + other.paise);
  Money operator -(Money other) => Money._(paise - other.paise);
  Money operator -() => Money._(-paise);
  bool operator <(Money other) => paise < other.paise;
  bool operator >(Money other) => paise > other.paise;
  bool operator <=(Money other) => paise <= other.paise;
  bool operator >=(Money other) => paise >= other.paise;

  /// Multiplies by a whole number, e.g. unit price × quantity.
  Money times(int factor) => Money._(paise * factor);

  bool get isZero => paise == 0;
  bool get isNegative => paise < 0;

  /// For pre-filling an input: `1250`, `49.5`, `0.05`. No symbol, no commas.
  String toInput() {
    final rupees = paise ~/ 100;
    final fraction = paise.abs() % 100;
    if (fraction == 0) return '$rupees';
    final digits = fraction
        .toString()
        .padLeft(2, '0')
        .replaceFirst(RegExp(r'0$'), '');
    return '$rupees.$digits';
  }

  /// Indian formatting with lakh/crore grouping: `₹1,00,000.00`.
  String format({bool withSymbol = true}) {
    final abs = paise.abs();
    final rupees = _grouping.format(abs ~/ 100);
    final fraction = (abs % 100).toString().padLeft(2, '0');
    final sign = paise < 0 ? '-' : '';
    final symbol = withSymbol ? '₹' : '';
    return '$sign$symbol$rupees.$fraction';
  }
}
