import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// What to tell the shopkeeper when printing fails. A failed connection
/// includes Android's own reason, so a problem can be diagnosed from a
/// screenshot.
String printErrorText(AppLocalizations l10n, PrintException e) =>
    switch (e.error) {
      PrintError.notConfigured => l10n.printErrNotConfigured,
      PrintError.permissionDenied => l10n.printErrPermission,
      PrintError.bluetoothOff => l10n.printErrBluetoothOff,
      PrintError.unsupported => l10n.printErrUnsupported,
      PrintError.failed when e.detail != null && e.detail!.isNotEmpty =>
        l10n.printErrFailedDetail(e.detail!),
      PrintError.failed => l10n.printErrFailed,
    };
