// Percentages as basis points (1000 = 10%, 1250 = 12.5%).

final _pattern = RegExp(r'^(\d{1,3})(?:\.(\d{1,2}))?$');

/// `"10"` → 1000, `"12.5"` → 1250; `null` if not a percentage from 0 to 100.
int? parsePercentBp(String input) {
  final m = _pattern.firstMatch(input.trim());
  if (m == null) return null;
  final whole = int.parse(m.group(1)!);
  final fraction = int.parse((m.group(2) ?? '0').padRight(2, '0'));
  final bp = whole * 100 + fraction;
  return bp > 10000 ? null : bp;
}

/// 1000 → `10%`, 1250 → `12.5%`.
String formatPercentBp(int bp) {
  final whole = bp ~/ 100;
  final fraction = bp % 100;
  if (fraction == 0) return '$whole%';
  final f = fraction.toString().padLeft(2, '0').replaceFirst(RegExp(r'0$'), '');
  return '$whole.$f%';
}

/// 1000 → `10`, 1250 → `12.5` (for an input field).
String percentInput(int bp) => formatPercentBp(bp).replaceAll('%', '');
