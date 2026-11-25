import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/bill_actions.dart';
import 'package:shop_app/features/printing/data/bill_image_renderer.dart';
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
    required this.storageDir,
    this.shareFile = shareFileWithSystem,
    this.whatsApp = const ChannelWhatsApp(),
    this.waitForReturn = waitForAppResume,
    ChatMemory? chats,
    Future<String> Function(Bill bill)? billImage,
  }) : chats = chats ?? FileChatMemory(storageDir) {
    this.billImage = billImage ?? (b) async => (await _imageFile(b)).path;
  }

  final PrinterService printer;
  final SettingsRepository settings;
  final ShopProfileRepository shopProfiles;
  final Future<Directory> Function() tempDir;
  final ShareFile shareFile;
  final WhatsAppSender whatsApp;

  /// Where the numbers already chatted with are remembered.
  final Future<Directory> Function() storageDir;

  /// Completes when the user is back in the app (after sending in
  /// WhatsApp); `false` if they don't come back in time.
  final Future<bool> Function() waitForReturn;

  /// Numbers already chatted with on WhatsApp from this phone.
  final ChatMemory chats;

  /// Makes the bill picture; returns its file path.
  late final Future<String> Function(Bill bill) billImage;
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

  /// The bill as a picture (see [BillImageRenderer]) under `invoices/`.
  Future<File> _imageFile(Bill bill) async {
    final shop = (await shopProfiles.load())!;
    final s = await settings.load();
    Uint8List? logo;
    final logoPath = shop.logoPath;
    if (logoPath != null && File(logoPath).existsSync()) {
      logo = await File(logoPath).readAsBytes();
    }
    final png = await const BillImageRenderer().render(
      bill,
      shop,
      s,
      logo: logo,
    );
    final dir = Directory(p.join((await tempDir()).path, 'invoices'));
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, BillImageRenderer.fileName(bill)));
    await file.writeAsBytes(png, flush: true);
    return file;
  }

  /// Sends the bill picture on WhatsApp. With the customer's mobile it goes
  /// straight to their chat. WhatsApp only opens a chat directly for
  /// numbers it knows, so the first time for a number the chat is opened
  /// with a short message (works for any number, saved or not); once the
  /// user has sent it and come back, the picture follows into that chat.
  @override
  Future<void> whatsapp(BuildContext context, Bill bill) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    void say(String text, {Duration? long}) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          duration: long ?? const Duration(seconds: 4),
        ),
      );
    say(l10n.sharePreparing);
    try {
      final shop = (await shopProfiles.load())!;
      final image = await billImage(bill);
      final name = bill.customerName?.trim();
      final total = bill.grandTotal.format();
      final message = name == null || name.isEmpty || name == bill.customerPhone
          ? l10n.whatsappMessage(shop.name, bill.invoiceNo, total)
          : l10n.whatsappMessageNamed(name, shop.name, bill.invoiceNo, total);
      final phone = bill.customerPhone;
      messenger.hideCurrentSnackBar();
      if (phone == null) {
        await whatsApp.sendFile(image, null, message);
        return;
      }
      if (await chats.knows(phone)) {
        await whatsApp.sendFile(image, phone, message);
        return;
      }
      say(l10n.whatsappFirstTime, long: const Duration(seconds: 8));
      await whatsApp.openChat(phone, message);
      await chats.remember(phone);
      if (!await waitForReturn()) return;
      // WhatsApp now knows the chat: the picture goes straight in.
      await whatsApp.sendFile(image, phone, bill.invoiceNo);
    } on WhatsAppMissing {
      say(l10n.whatsappMissing);
    } on Object {
      say(l10n.shareFailed);
    }
  }
}

/// WhatsApp isn't installed on this phone.
class WhatsAppMissing implements Exception {
  const WhatsAppMissing();
}

/// Talks to WhatsApp (see `WhatsAppChannel.kt`).
abstract interface class WhatsAppSender {
  /// Opens WhatsApp with [path] attached: in [phone]'s chat when WhatsApp
  /// knows the number, otherwise its chat picker.
  Future<void> sendFile(String path, String? phone, String text);

  /// Opens the chat with [phone] (any number) with [text] ready to send.
  Future<void> openChat(String phone, String text);
}

class ChannelWhatsApp implements WhatsAppSender {
  const ChannelWhatsApp();

  static const _channel = MethodChannel('shop_app/whatsapp');

  Future<void> _call(String method, Map<String, Object?> args) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } on PlatformException catch (e) {
      if (e.code == 'NO_WHATSAPP') throw const WhatsAppMissing();
      rethrow;
    }
  }

  @override
  Future<void> sendFile(String path, String? phone, String text) =>
      _call('sendFile', {'path': path, 'phone': phone, 'text': text});

  @override
  Future<void> openChat(String phone, String text) =>
      _call('openChat', {'phone': phone, 'text': text});
}

/// Mobile numbers this phone has already opened a WhatsApp chat with.
abstract interface class ChatMemory {
  Future<bool> knows(String phone);
  Future<void> remember(String phone);
}

/// [ChatMemory] in a small file next to the database.
class FileChatMemory implements ChatMemory {
  FileChatMemory(this._dir);

  final Future<Directory> Function() _dir;

  Future<File> get _file async =>
      File(p.join((await _dir()).path, 'whatsapp_chats.json'));

  Future<Set<String>> _read() async {
    try {
      final f = await _file;
      if (!f.existsSync()) return {};
      return {...(jsonDecode(await f.readAsString()) as List).cast<String>()};
    } on Object {
      return {};
    }
  }

  @override
  Future<bool> knows(String phone) async => (await _read()).contains(phone);

  @override
  Future<void> remember(String phone) async {
    final all = await _read()
      ..add(phone);
    await (await _file).writeAsString(jsonEncode(all.toList()));
  }
}

/// Waits until the app is in front again (the user came back from
/// WhatsApp), for up to 15 minutes.
Future<bool> waitForAppResume() async {
  final back = Completer<bool>();
  // Leaving the app comes first; only a return after that counts.
  var left = false;
  final listener = AppLifecycleListener(
    onHide: () => left = true,
    onShow: () {
      if (left && !back.isCompleted) back.complete(true);
    },
  );
  try {
    return await back.future.timeout(
      const Duration(minutes: 15),
      onTimeout: () => false,
    );
  } finally {
    listener.dispose();
    // Let the app settle in front before opening WhatsApp again.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }
}
