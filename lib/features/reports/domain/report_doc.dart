import 'package:intl/intl.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';

// [Money] and [Quantity] are extension types over `int`, so at runtime a
// cell can't tell them from each other (or from a count). Report cells wrap
// them in these small classes instead.

/// A rupee amount in a report cell.
class Amount {
  const Amount(this.value);

  final Money value;

  bool get isNegative => value.isNegative;
}

/// A quantity in a report cell.
class Qty {
  const Qty(this.value);

  final Quantity value;
}

/// A calendar day in a report cell (shown without a time).
class Day {
  const Day(this.date);

  final DateTime date;
}

/// One table of a report. Cells are [Amount], [Qty], [int] (a count),
/// [DateTime], [Day], [String] or `null`, so each output (screen, PDF,
/// Excel) can format them its own way.
class ReportTable {
  const ReportTable({
    required this.title,
    required this.columns,
    required this.rows,
    this.totals,
  });

  final String title;
  final List<String> columns;
  final List<List<Object?>> rows;

  /// Optional last row (first cell is usually a label).
  final List<Object?>? totals;

  /// Columns holding numbers (right-aligned; numeric in Excel).
  Set<int> get numericColumns => {
    for (var c = 0; c < columns.length; c++)
      if (_isNumeric(c)) c,
  };

  bool _isNumeric(int c) {
    var any = false;
    for (final row in [...rows, ?totals]) {
      final v = c < row.length ? row[c] : null;
      if (v == null || (identical(row, totals) && v is String)) continue;
      if (v is Amount || v is Qty || v is int) {
        any = true;
      } else {
        return false;
      }
    }
    return any;
  }
}

/// A finished report: headline figures, tables and notes.
class ReportDoc {
  const ReportDoc({
    required this.title,
    required this.from,
    required this.to,
    this.summary = const [],
    this.tables = const [],
    this.notes = const [],
  });

  final String title;

  /// Period covered: [from] inclusive, [to] exclusive.
  final DateTime from;
  final DateTime to;

  /// Headline figures: label and an [Amount] or a count.
  final List<(String, Object)> summary;
  final List<ReportTable> tables;
  final List<String> notes;

  /// `1 Nov 2026 – 30 Nov 2026`, or a single day.
  String get periodLabel {
    final last = to.subtract(const Duration(days: 1));
    final same =
        last.year == from.year &&
        last.month == from.month &&
        last.day == from.day;
    return same
        ? formatDate(from)
        : '${formatDate(from)} – ${formatDate(last)}';
  }

  /// For Excel: a Summary sheet, then one sheet per table.
  List<SheetData> sheets(String summaryLabel, String valueLabel) => [
    (
      name: summaryLabel,
      rows: [
        [summaryLabel, valueLabel],
        [title, periodLabel],
        for (final (label, value) in summary) [label, excelCell(value)],
        for (final n in notes) ['', n],
      ],
      numericColumns: const {1},
    ),
    for (final t in tables)
      (
        name: t.title,
        rows: [
          t.columns,
          for (final r in t.rows) [for (final v in r) excelCell(v)],
          if (t.totals != null) [for (final v in t.totals!) excelCell(v)],
        ],
        numericColumns: t.numericColumns,
      ),
  ];
}

/// Text for the screen and PDF.
String cellText(Object? v, {bool symbol = true}) => switch (v) {
  null => '',
  Amount(:final value) => value.format(withSymbol: symbol),
  Qty(:final value) => value.format(),
  Day(:final date) => formatDate(date),
  final DateTime t => formatDateTime(t),
  _ => v.toString(),
};

final _excelDate = DateFormat('dd-MM-yyyy HH:mm');
final _excelDay = DateFormat('dd-MM-yyyy');

/// Plain values for spreadsheets: `1234.50`, not `₹1,234.50`.
String excelCell(Object? v) => switch (v) {
  null => '',
  Amount(:final value) => (value.paise / 100).toStringAsFixed(2),
  Qty(:final value) => (value.milli / 1000).toString().replaceFirst(
    RegExp(r'\.0$'),
    '',
  ),
  Day(:final date) => _excelDay.format(date),
  final DateTime t => _excelDate.format(t),
  _ => v.toString(),
};
