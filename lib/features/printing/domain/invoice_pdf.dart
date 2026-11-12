import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_app/core/format/amount_in_words.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// Fonts for the PDF. On Android we borrow the system's Roboto, which has
/// the ₹ sign; elsewhere (tests) we fall back to the built-in Helvetica and
/// write "Rs." instead.
class InvoiceFonts {
  const InvoiceFonts({this.regular, this.bold});

  static const _candidates = [
    ('/system/fonts/Roboto-Regular.ttf', '/system/fonts/Roboto-Bold.ttf'),
    ('/system/fonts/NotoSans-Regular.ttf', '/system/fonts/NotoSans-Bold.ttf'),
  ];

  static Future<InvoiceFonts> load() async {
    for (final (regular, bold) in _candidates) {
      final r = File(regular);
      if (!r.existsSync()) continue;
      final b = File(bold);
      return InvoiceFonts(
        regular: pw.Font.ttf(ByteData.sublistView(await r.readAsBytes())),
        bold: b.existsSync()
            ? pw.Font.ttf(ByteData.sublistView(await b.readAsBytes()))
            : null,
      );
    }
    return const InvoiceFonts();
  }

  final pw.Font? regular;
  final pw.Font? bold;

  bool get hasRupee => regular != null;
}

/// Builds an A4 invoice PDF for sharing (WhatsApp, email) or printing.
class InvoicePdf {
  const InvoicePdf(this.fonts);

  final InvoiceFonts fonts;

  Future<Uint8List> build(
    Bill bill,
    ShopProfile shop,
    AppSettingsData settings,
  ) async {
    final rupee = fonts.hasRupee ? '₹' : 'Rs.';
    String money(Money m) => m.format(withSymbol: false);
    final isGst = shop.gstin != null;

    final logo = _logo(shop.logoPath);
    final upi = ReceiptFormatter.upiUri(bill, shop, settings);
    final theme = pw.ThemeData.withFont(
      base: fonts.regular ?? pw.Font.helvetica(),
      bold: fonts.bold ?? fonts.regular ?? pw.Font.helveticaBold(),
    );
    const small = pw.TextStyle(fontSize: 9);
    const bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    const grey = PdfColors.grey700;

    final doc = pw.Document(
      title: bill.invoiceNo,
      author: shop.name,
      creator: 'Shop App',
    );

    pw.Widget cell(String text, {bool right = false, bool header = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: pw.Text(
            text,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: header
                ? small.copyWith(fontWeight: pw.FontWeight.bold)
                : small,
          ),
        );

    pw.Widget totalRow(String label, String value, {bool strong = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
          child: pw.Row(
            children: [
              pw.Expanded(child: pw.Text(label, style: strong ? bold : null)),
              pw.Text(
                value,
                style: strong ? bold.copyWith(fontSize: 13) : null,
              ),
            ],
          ),
        );

    final showHsn = bill.lines.any((l) => l.hsn != null);
    final showTax = !bill.tax.isZero;

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: theme,
          buildForeground: bill.isCancelled
              ? (context) => pw.Center(
                  child: pw.Transform.rotateBox(
                    angle: 0.5,
                    child: pw.Text(
                      'CANCELLED',
                      style: const pw.TextStyle(
                        fontSize: 80,
                        color: PdfColor.fromInt(0x33D32F2F),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        build: (context) => [
          // Shop header.
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logo != null)
                pw.Container(
                  width: 56,
                  height: 56,
                  margin: const pw.EdgeInsets.only(right: 12),
                  child: pw.Image(logo),
                ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(shop.name, style: bold.copyWith(fontSize: 18)),
                    pw.Text(
                      [
                            shop.addressLine,
                            shop.city,
                            stateByCode(shop.stateCode)?.name,
                            shop.pincode,
                          ]
                          .whereType<String>()
                          .where((s) => s.isNotEmpty)
                          .join(', '),
                    ),
                    if (shop.phone != null) pw.Text('Phone: +91 ${shop.phone}'),
                    if (isGst) pw.Text('GSTIN: ${shop.gstin}', style: bold),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    isGst ? 'TAX INVOICE' : 'BILL OF SUPPLY',
                    style: bold.copyWith(
                      fontSize: 14,
                      color: PdfColors.teal800,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('Invoice No: ${bill.invoiceNo}'),
                  pw.Text(
                    'Date: ${DateFormat('dd MMM yyyy, h:mm a', appLocale).format(bill.billedAt)}',
                  ),
                  pw.Text(
                    'Place of supply: ${stateByCode(bill.placeOfSupply ?? shop.stateCode)?.name ?? ''} (${bill.placeOfSupply ?? shop.stateCode})',
                    style: small,
                  ),
                ],
              ),
            ],
          ),
          pw.Divider(color: PdfColors.grey400),
          if (bill.customerName != null || bill.customerPhone != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Bill to', style: small.copyWith(color: grey)),
                  if (bill.customerName != null)
                    pw.Text(bill.customerName!, style: bold),
                  if (bill.customerPhone != null)
                    pw.Text('+91 ${bill.customerPhone}'),
                  if (bill.buyerGstin != null)
                    pw.Text('GSTIN: ${bill.buyerGstin}', style: bold),
                ],
              ),
            ),

          // Items.
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(22),
              1: const pw.FlexColumnWidth(4),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  cell('#', header: true),
                  cell('Item', header: true),
                  if (showHsn) cell('HSN', header: true),
                  cell('Qty', header: true, right: true),
                  cell('Rate', header: true, right: true),
                  cell('Disc.', header: true, right: true),
                  if (showTax) cell('Taxable', header: true, right: true),
                  if (showTax) cell('GST', header: true, right: true),
                  cell('Amount ($rupee)', header: true, right: true),
                ],
              ),
              for (var i = 0; i < bill.lines.length; i++)
                pw.TableRow(
                  children: [
                    cell('${i + 1}'),
                    cell(bill.lines[i].name),
                    if (showHsn) cell(bill.lines[i].hsn ?? ''),
                    cell(
                      '${bill.lines[i].quantity.format()} ${bill.lines[i].unit}',
                      right: true,
                    ),
                    cell(money(bill.lines[i].unitPrice), right: true),
                    cell(
                      bill.lines[i].discount.isZero
                          ? ''
                          : money(bill.lines[i].discount),
                      right: true,
                    ),
                    if (showTax)
                      cell(money(bill.lines[i].taxable), right: true),
                    if (showTax) cell(bill.lines[i].taxRate.label, right: true),
                    cell(money(bill.lines[i].total), right: true),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 12),

          // GST summary + totals.
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: showTax
                    ? pw.Table(
                        border: pw.TableBorder.all(
                          color: PdfColors.grey400,
                          width: 0.5,
                        ),
                        children: [
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.grey200,
                            ),
                            children: [
                              cell('GST rate', header: true),
                              cell('Taxable', header: true, right: true),
                              if (bill.interState)
                                cell('IGST', header: true, right: true)
                              else ...[
                                cell('CGST', header: true, right: true),
                                cell('SGST', header: true, right: true),
                              ],
                            ],
                          ),
                          for (final b in bill.taxBuckets)
                            pw.TableRow(
                              children: [
                                cell(b.rate.label),
                                cell(money(b.taxable), right: true),
                                if (bill.interState)
                                  cell(
                                    '${b.rate.label}: ${money(b.tax)}',
                                    right: true,
                                  )
                                else ...[
                                  cell(
                                    '${b.rate.halfLabel}: ${money(b.cgst)}',
                                    right: true,
                                  ),
                                  cell(
                                    '${b.rate.halfLabel}: ${money(b.sgst)}',
                                    right: true,
                                  ),
                                ],
                              ],
                            ),
                        ],
                      )
                    : pw.SizedBox(),
              ),
              pw.SizedBox(width: 16),
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    totalRow('Items total', money(bill.itemsTotal)),
                    if (!bill.billDiscount.isZero)
                      totalRow('Bill discount', '-${money(bill.billDiscount)}'),
                    if (showTax) ...[
                      totalRow('Taxable value', money(bill.taxable)),
                      if (bill.interState)
                        totalRow('IGST', money(bill.tax))
                      else ...[
                        totalRow(
                          'CGST',
                          money(
                            bill.taxBuckets.fold(
                              Money.zero,
                              (s, b) => s + b.cgst,
                            ),
                          ),
                        ),
                        totalRow(
                          'SGST',
                          money(
                            bill.taxBuckets.fold(
                              Money.zero,
                              (s, b) => s + b.sgst,
                            ),
                          ),
                        ),
                      ],
                    ],
                    if (!bill.roundOff.isZero)
                      totalRow('Round off', money(bill.roundOff)),
                    pw.Divider(color: PdfColors.grey400),
                    totalRow(
                      'Total',
                      '$rupee ${money(bill.grandTotal)}',
                      strong: true,
                    ),
                    if (bill.due.isPositive && !bill.isCancelled) ...[
                      totalRow('Paid', money(bill.paid)),
                      totalRow(
                        'Balance due',
                        '$rupee ${money(bill.due)}',
                        strong: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(amountInWords(bill.grandTotal), style: small),
          pw.Text(
            'Payment: ${bill.paymentMode.name.toUpperCase()}',
            style: small,
          ),
          if (!isGst)
            pw.Text(
              'Supplier not registered under GST.',
              style: small.copyWith(color: grey),
            ),
          pw.SizedBox(height: 16),

          // UPI QR and footer.
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (upi != null)
                pw.Column(
                  children: [
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: upi,
                      width: 96,
                      height: 96,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Scan to pay with UPI', style: small),
                  ],
                ),
              pw.Spacer(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('For ${shop.name}', style: bold),
                  pw.SizedBox(height: 24),
                  pw.Text('Authorised signatory', style: small),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Center(
            child: pw.Text(
              settings.receiptFooter ?? 'Thank you for your business!',
              style: small.copyWith(color: grey),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'This is a computer-generated invoice.',
              style: small.copyWith(color: grey, fontSize: 7),
            ),
          ),
        ],
      ),
    );
    final bytes = await doc.save();
    return bytes;
  }

  static pw.MemoryImage? _logo(String? path) {
    if (path == null) return null;
    final file = File(path);
    if (!file.existsSync()) return null;
    try {
      return pw.MemoryImage(file.readAsBytesSync());
    } on Object {
      return null;
    }
  }

  /// A safe file name for sharing: `Invoice_INV-26-27-0001.pdf`.
  static String fileName(Bill bill) =>
      'Invoice_${bill.invoiceNo.replaceAll(RegExp('[^A-Za-z0-9-]'), '-')}.pdf';
}
