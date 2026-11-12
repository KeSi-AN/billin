import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/flavor.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/theme/app_theme.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/bill_actions.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/inventory/domain/stock_alerts.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Everything the screens need from outside. `main.dart` passes the real
/// implementations; tests pass fakes.
class AppServices {
  const AppServices({
    required this.shopProfiles,
    required this.items,
    required this.bills,
    required this.settings,
    required this.billActions,
    required this.printer,
    required this.inventory,
    required this.stockAlerts,
  });

  final ShopProfileRepository shopProfiles;
  final ItemRepository items;
  final BillRepository bills;
  final SettingsRepository settings;
  final BillActions billActions;
  final PrinterService printer;
  final InventoryRepository inventory;
  final StockAlerts stockAlerts;
}

class ShopApp extends StatefulWidget {
  const ShopApp({required this.services, this.flavor, super.key});

  final AppServices services;
  final Flavor? flavor;

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  late final ShopProfileCubit _profileCubit = ShopProfileCubit(
    widget.services.shopProfiles,
  );
  late final GoRouter _router = buildRouter(_profileCubit);

  @override
  void dispose() {
    _router.dispose();
    unawaited(_profileCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flavor = widget.flavor ?? Flavor.current;
    final s = widget.services;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: s.shopProfiles),
        RepositoryProvider.value(value: s.items),
        RepositoryProvider.value(value: s.bills),
        RepositoryProvider.value(value: s.settings),
        RepositoryProvider.value(value: s.billActions),
        RepositoryProvider.value(value: s.printer),
        RepositoryProvider.value(value: s.inventory),
        RepositoryProvider.value(value: s.stockAlerts),
      ],
      child: BlocProvider.value(
        value: _profileCubit,
        child: MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final page = child ?? const SizedBox.shrink();
            return flavor.isDev
                ? Banner(
                    message: AppLocalizations.of(context).devBanner,
                    location: BannerLocation.topEnd,
                    child: page,
                  )
                : page;
          },
        ),
      ),
    );
  }
}
