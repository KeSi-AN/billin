import 'dart:io';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/bill_actions.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/printing/presentation/print_error_text.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

typedef ShareFile = Future<void> Function(String path, String text);

/// Opens the system share sheet for a file.
Future<void> shareFileWithSystem(String path, String text) async {
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(path, mimeType: 'application/pdf')],
      text: text,
    ),
  );
}

/// Real print (Bluetooth ESC/POS) and share (PDF) for bills.
class AppBillActions implements BillActions {
  AppBillActions({
    required this.printer,
    required this.settings,
    required this.shopProfiles,
    required this.tempDir,
    this.shareFile = shareFileWithSystem,
    this.sendWhatsApp = sendWhatsAppWithChannel,
  });

  final PrinterService printer;
  final SettingsRepository settings;
  final ShopProfileRepository shopProfiles;
  final Future<Directory> Function() tempDir;
  final ShareFile shareFile;
  final SendWhatsApp sendWhatsApp;
  Future<InvoiceFonts>? _fonts;

  @override
  Future<void> print(BuildContext context, Bill bill) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    void say(String text, {SnackBarAction? action}) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), action: action, persist: false),
      );

    final s = await settings.load();
    final shop = (await shopProfiles.load())!;
    final bytes = ReceiptFormatter(width: s.paperWidth.charsPerLine)
        .bytes(bill, shop, s, logo: await printer.logos.logoFor(shop, s));
    say(l10n.printing);
    try {
      await printer.printBytes(bytes);
      say(l10n.printed);
    } on PrintException catch (e) {
      say(
        printErrorText(l10n, e),
        action: e.error == PrintError.unsupported
            ? null
            : SnackBarAction(
                label: l10n.setUpPrinter,
                onPressed: () => router.push(AppRoutes.printerSettings),
              ),
      );
    }
  }

  /// Writes the bill's PDF under the cache's `invoices/` folder.
  Future<File> _pdfFile(Bill bill) async {
    final shop = (await shopProfiles.load())!;
    final s = await settings.load();
    final pdf = await InvoicePdf(await (_fonts ??= InvoiceFonts.load()))
        .build(bill, shop, s);
    final dir = Directory(p.join((await tempDir()).path, 'invoices'));
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, InvoicePdf.fileName(bill)));
    await file.writeAsBytes(pdf, flush: true);
    return file;
  }

  Future<String> _text(AppLocalizations l10n, Bill bill) async {
    final shop = (await shopProfiles.load())!;
    return l10n.shareText(bill.invoiceNo, shop.name, bill.grandTotal.format());
  }

  @override
  Future<void> share(BuildContext context, Bill bill) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.sharePreparing)));
    try {
      final file = await _pdfFile(bill);
      final text = await _text(l10n, bill);
      messenger.hideCurrentSnackBar();
      await shareFile(file.path, text);
    } on Object {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
    }
  }

  @override
  Future<void> whatsapp(BuildContext context, Bill bill) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.sharePreparing)));
    try {
      final file = await _pdfFile(bill);
      final text = await _text(l10n, bill);
      messenger.hideCurrentSnackBar();
      await sendWhatsApp(file.path, bill.customerPhone, text);
    } on WhatsAppMissing {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.whatsappMissing)));
    } on Object {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
    }
  }
}

/// WhatsApp isn't installed on this phone.
class WhatsAppMissing implements Exception {
  const WhatsAppMissing();
}

typedef SendWhatsApp = Future<void> Function(
  String path,
  String? phone,
  String text,
);

/// Opens WhatsApp (Business preferred) with the PDF; see
/// `WhatsAppChannel.kt`.
Future<void> sendWhatsAppWithChannel(
  String path,
  String? phone,
  String text,
) async {
  try {
    await const MethodChannel('shop_app/whatsapp').invokeMethod<void>(
      'sendFile',
      {'path': path, 'phone': phone, 'text': text},
    );
  } on PlatformException catch (e) {
    if (e.code == 'NO_WHATSAPP') throw const WhatsAppMissing();
    rethrow;
  }
}
