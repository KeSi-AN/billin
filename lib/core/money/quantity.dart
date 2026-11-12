/// A quantity in **thousandths** (1000 = 1 unit), so 0.5 kg or 1.25 m are
/// exact. Like `Money`, never use a `double` for quantities.
extension type const Quantity._(int milli) {
  const Quantity.milli(int milli) : this._(milli);
  const Quantity.whole(int units) : this._(units * 1000);

  static const zero = Quantity._(0);
  static const one = Quantity._(1000);

  static final _pattern = RegExp(r'^(\d{1,7})(?:\.(\d{1,3}))?$');

  /// Parses `"2"`, `"0.5"`, `"1.250"`. Up to 3 decimals, non-negative.
  static Quantity? tryParse(String input) {
    final match = _pattern.firstMatch(input.trim());
    if (match == null) return null;
    final whole = int.parse(match.group(1)!);
    final fraction = (match.group(2) ?? '').padRight(3, '0');
    return Quantity._(whole * 1000 + int.parse(fraction));
  }

  Quantity operator +(Quantity other) => Quantity._(milli + other.milli);
  Quantity operator -(Quantity other) => Quantity._(milli - other.milli);
  bool operator >(Quantity other) => milli > other.milli;
  bool operator <(Quantity other) => milli < other.milli;

  bool get isZero => milli == 0;
  bool get isPositive => milli > 0;

  /// `2`, `0.5`, `1.25`: no trailing zeros.
  String format() {
    final whole = milli ~/ 1000;
    final fraction = milli % 1000;
    if (fraction == 0) return '$whole';
    final digits = fraction
        .toString()
        .padLeft(3, '0')
        .replaceFirst(RegExp(r'0+$'), '');
    return '$whole.$digits';
  }
}
