import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: StreamBuilder<AppSettingsData>(
        stream: context.read<SettingsRepository>().watch(),
        builder: (context, snapshot) {
          final settings = snapshot.data ?? const AppSettingsData();
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: Text(l10n.settingsShop),
                onTap: () => context.push(AppRoutes.editShop),
              ),
              ListTile(
                key: const Key('billingSettingsTile'),
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(l10n.settingsBilling),
                subtitle: Text(l10n.settingsBillingSubtitle),
                onTap: () => context.push(AppRoutes.billingSettings),
              ),
              ListTile(
                key: const Key('printerSettingsTile'),
                leading: const Icon(Icons.print_outlined),
                title: Text(l10n.settingsPrinter),
                subtitle: Text(
                  settings.printerName ?? l10n.settingsPrinterNone,
                ),
                onTap: () => context.push(AppRoutes.printerSettings),
              ),
            ],
          );
        },
      ),
    );
  }
}
