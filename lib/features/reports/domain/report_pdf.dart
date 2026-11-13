import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/reports/domain/report_doc.dart';

/// Labels the PDF needs (kept out of the domain so they can be translated).
typedef ReportPdfLabels = ({String amountsIn, String generated});

/// Any [ReportDoc] as an A4 PDF (landscape when tables are wide).
class ReportPdf {
  const ReportPdf(this.fonts);

  final InvoiceFonts fonts;

  Future<Uint8List> build(
    ReportDoc report, {
    required String shopName,
    required ReportPdfLabels labels,
    DateTime? generatedAt,
  }) {
    final rupee = fonts.hasRupee ? '₹' : 'Rs.';
    // The ₹ sign needs a system font; tables just show numbers.
    String text(Object? v) => cellText(v, symbol: false);
    String summaryText(Object v) =>
        v is Amount ? '$rupee${cellText(v, symbol: false)}' : cellText(v);

    final wide = report.tables.any((t) => t.columns.length > 6);
    final theme = pw.ThemeData.withFont(
      base: fonts.regular ?? pw.Font.helvetica(),
      bold: fonts.bold ?? fonts.regular ?? pw.Font.helveticaBold(),
    );
    const small = pw.TextStyle(fontSize: 8.5);
    final smallBold = small.copyWith(fontWeight: pw.FontWeight.bold);
    const grey = PdfColors.grey700;

    pw.Widget cell(String s, {bool right = false, pw.TextStyle? style}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
          child: pw.Text(
            s,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: style ?? small,
          ),
        );

    pw.Widget table(ReportTable t) {
      final numeric = t.numericColumns;
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 12),
          pw.Text(t.title, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 4),
          pw.Table(
            border: const pw.TableBorder(
              horizontalInside: pw.BorderSide(
                color: PdfColors.grey300,
                width: 0.5,
              ),
              top: pw.BorderSide(width: 0.5),
              bottom: pw.BorderSide(width: 0.5),
            ),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  for (var c = 0; c < t.columns.length; c++)
                    cell(
                      t.columns[c],
                      right: numeric.contains(c),
                      style: smallBold,
                    ),
                ],
              ),
              for (final r in t.rows)
                pw.TableRow(
                  children: [
                    for (var c = 0; c < t.columns.length; c++)
                      cell(
                        c < r.length ? text(r[c]) : '',
                        right: numeric.contains(c),
                      ),
                  ],
                ),
              if (t.totals != null)
                pw.TableRow(
                  children: [
                    for (var c = 0; c < t.columns.length; c++)
                      cell(
                        c < t.totals!.length ? text(t.totals![c]) : '',
                        right: numeric.contains(c),
                        style: smallBold,
                      ),
                  ],
                ),
            ],
          ),
        ],
      );
    }

    final doc = pw.Document(title: report.title, author: shopName)
      ..addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: wide ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(28),
            theme: theme,
          ),
          footer: (context) => pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  '${labels.generated} ${formatDateTime(generatedAt ?? DateTime.now())}',
                  style: small.copyWith(color: grey),
                ),
              ),
              pw.Text(
                '${context.pageNumber} / ${context.pagesCount}',
                style: small.copyWith(color: grey),
              ),
            ],
          ),
          build: (context) => [
            pw.Text(
              shopName,
              style: const pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${report.title} · ${report.periodLabel}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              '${labels.amountsIn} ($rupee)',
              style: small.copyWith(color: grey),
            ),
            if (report.summary.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Container(
                width: 280,
                child: pw.Column(
                  children: [
                    for (final (label, value) in report.summary)
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
                        child: pw.Row(
                          children: [
                            pw.Expanded(child: pw.Text(label)),
                            pw.Text(summaryText(value)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            for (final n in report.notes)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4),
                child: pw.Text('• $n', style: small.copyWith(color: grey)),
              ),
            for (final t in report.tables) table(t),
          ],
        ),
      );
    return doc.save();
  }
}
