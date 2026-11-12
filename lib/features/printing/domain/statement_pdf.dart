import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// A customer's account statement: every entry with debit, credit and
/// running balance, ending at their current balance.
class StatementPdf {
  const StatementPdf(this.fonts);

  final InvoiceFonts fonts;

  Future<Uint8List> build({
    required Party party,
    required ShopProfile shop,
    required List<PartyEntry> entries,
    required DateTime generatedAt,
  }) async {
    final rupee = fonts.hasRupee ? '₹' : 'Rs.';
    String money(Money m) => m.format(withSymbol: false);
    const bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    const small = pw.TextStyle(fontSize: 9);
    final dateFmt = DateFormat('dd MMM yyyy', appLocale);

    String particulars(PartyEntry e) {
      final inv = e.invoiceNo ?? '';
      return switch (e.type) {
            EntryType.opening => 'Opening balance',
            EntryType.sale => 'Bill $inv',
            EntryType.payment when e.billId != null => 'Paid at billing ($inv)',
            EntryType.payment =>
              'Payment received${e.paymentMode == null ? '' : ' (${e.paymentMode!.name.toUpperCase()})'}',
            EntryType.cancel => 'Bill $inv cancelled',
            EntryType.adjust => 'Adjustment',
            EntryType.purchase => 'Purchase',
            EntryType.salesReturn => 'Goods returned (bill $inv)',
          } +
          (e.note != null && e.billId == null ? ' - ${e.note}' : '');
    }

    pw.Widget cell(String t, {bool right = false, bool header = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: pw.Text(
            t,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: header
                ? small.copyWith(fontWeight: pw.FontWeight.bold)
                : small,
          ),
        );

    final debits = entries
        .where((e) => e.amount.isPositive)
        .fold(Money.zero, (s, e) => s + e.amount);
    final credits = entries
        .where((e) => e.amount.isNegative)
        .fold(Money.zero, (s, e) => s - e.amount);

    final doc = pw.Document(title: 'Statement ${party.name}', author: shop.name)
      ..addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            theme: pw.ThemeData.withFont(
              base: fonts.regular ?? pw.Font.helvetica(),
              bold: fonts.bold ?? fonts.regular ?? pw.Font.helveticaBold(),
            ),
          ),
          build: (context) => [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(shop.name, style: bold.copyWith(fontSize: 16)),
                      pw.Text(
                        [
                          shop.addressLine,
                          shop.city,
                          stateByCode(shop.stateCode)?.name,
                        ].whereType<String>().join(', '),
                      ),
                      if (shop.phone != null)
                        pw.Text('Phone: +91 ${shop.phone}'),
                      if (shop.gstin != null) pw.Text('GSTIN: ${shop.gstin}'),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'ACCOUNT STATEMENT',
                      style: bold.copyWith(
                        fontSize: 13,
                        color: PdfColors.teal800,
                      ),
                    ),
                    pw.Text('As on ${dateFmt.format(generatedAt)}'),
                  ],
                ),
              ],
            ),
            pw.Divider(color: PdfColors.grey400),
            pw.Text(
              'Customer',
              style: small.copyWith(color: PdfColors.grey700),
            ),
            pw.Text(party.name, style: bold),
            if (party.phone != null) pw.Text('+91 ${party.phone}'),
            if (party.addressLine != null) pw.Text(party.addressLine!),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              columnWidths: {1: const pw.FlexColumnWidth(3)},
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    cell('Date', header: true),
                    cell('Particulars', header: true),
                    cell('Debit ($rupee)', header: true, right: true),
                    cell('Credit ($rupee)', header: true, right: true),
                    cell('Balance ($rupee)', header: true, right: true),
                  ],
                ),
                for (final e in entries)
                  pw.TableRow(
                    children: [
                      cell(dateFmt.format(e.at)),
                      cell(particulars(e)),
                      cell(
                        e.amount.isPositive ? money(e.amount) : '',
                        right: true,
                      ),
                      cell(
                        e.amount.isNegative ? money(-e.amount) : '',
                        right: true,
                      ),
                      cell(money(e.balanceAfter), right: true),
                    ],
                  ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    cell(''),
                    cell('Total', header: true),
                    cell(money(debits), header: true, right: true),
                    cell(money(credits), header: true, right: true),
                    cell(money(party.balance), header: true, right: true),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                party.balance.isNegative
                    ? 'Advance with ${shop.name}: $rupee ${money(-party.balance)}'
                    : 'Balance due: $rupee ${money(party.balance)}',
                style: bold.copyWith(fontSize: 13),
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Center(
              child: pw.Text(
                'This is a computer-generated statement.',
                style: small.copyWith(color: PdfColors.grey700, fontSize: 7),
              ),
            ),
          ],
        ),
      );
    final bytes = await doc.save();
    return bytes;
  }
}
