import 'package:flutter/foundation.dart' show immutable;

/// Indian financial year, April to March. `FinancialYear(2026)` is FY 2026-27.
@immutable
class FinancialYear {
  const FinancialYear(this.startYear);

  factory FinancialYear.of(DateTime date) =>
      FinancialYear(date.month >= 4 ? date.year : date.year - 1);

  final int startYear;

  /// `26-27`
  String get short {
    String two(int y) => (y % 100).toString().padLeft(2, '0');
    return '${two(startYear)}-${two(startYear + 1)}';
  }

  @override
  bool operator ==(Object other) =>
      other is FinancialYear && other.startYear == startYear;

  @override
  int get hashCode => startYear.hashCode;
}

/// Invoice numbers restart every financial year, as GST rules expect, and
/// stay within the 16-character limit: `INV/26-27/0001`.
abstract final class InvoiceNumber {
  static const defaultPrefix = 'INV';
  static final _prefixPattern = RegExp(r'^[A-Z0-9]{0,4}$');

  static bool isValidPrefix(String prefix) => _prefixPattern.hasMatch(prefix);

  /// `INV/26-27/0001`, or with a phone's [series] letter
  /// `INV-A/26-27/0001` (each phone of a shop numbers its own bills).
  static String format({
    required String prefix,
    required FinancialYear year,
    required int sequence,
    String? series,
  }) {
    final seq = sequence.toString().padLeft(4, '0');
    final name = [
      prefix,
      if (series != null && series.isNotEmpty) series,
    ].where((s) => s.isNotEmpty).join('-');
    final head = name.isEmpty ? '' : '$name/';
    return '$head${year.short}/$seq';
  }
}
