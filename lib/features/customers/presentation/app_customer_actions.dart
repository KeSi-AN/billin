import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/customers/domain/customer_actions.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/domain/reminder.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/printing/domain/statement_pdf.dart';
import 'package:shop_app/features/printing/presentation/app_bill_actions.dart'
    show ShareFile;
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

typedef OpenUrl = Future<bool> Function(Uri uri);

Future<bool> _openExternal(Uri uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);

class AppCustomerActions implements CustomerActions {
  AppCustomerActions({
    required this.parties,
    required this.shopProfiles,
    required this.settings,
    required this.tempDir,
    required this.shareFile,
    this.openUrl = _openExternal,
    this.clock = DateTime.now,
  });

  final PartyRepository parties;
  final ShopProfileRepository shopProfiles;
  final SettingsRepository settings;
  final Future<Directory> Function() tempDir;
  final ShareFile shareFile;
  final OpenUrl openUrl;
  final DateTime Function() clock;
  Future<InvoiceFonts>? _fonts;

  @override
  Future<void> remind(BuildContext context, Party party) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final shop = await shopProfiles.load();
    final s = await settings.load();
    final message = reminderMessage(
      party: party,
      shopName: shop?.name ?? '',
      upiId: s.upiId,
    );
    final opened = await openUrl(whatsAppUri(party.phone!, message));
    if (!opened) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.whatsAppMissing)));
    }
  }

  @override
  Future<void> shareStatement(BuildContext context, Party party) async {
    final l10n = AppLocalizations.of(context);
    showSnack(context, l10n.sharePreparing);
    try {
      final shop = (await shopProfiles.load())!;
      final entries = (await parties.watchEntries(party.id!).first).reversed
          .toList();
      final pdf = await StatementPdf(
        await (_fonts ??= InvoiceFonts.load()),
      ).build(party: party, shop: shop, entries: entries, generatedAt: clock());
      final dir = Directory(p.join((await tempDir()).path, 'statements'));
      await dir.create(recursive: true);
      final safe = party.name.replaceAll(RegExp('[^A-Za-z0-9]+'), '_');
      final file = File(p.join(dir.path, 'Statement_$safe.pdf'));
      await file.writeAsBytes(pdf, flush: true);
      await shareFile(
        file.path,
        l10n.statementShareText(party.name, shop.name),
      );
    } on Object {
      if (context.mounted) showSnack(context, l10n.shareFailed);
    }
  }
}
