import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/flavor.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/theme/app_theme.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Root widget. Takes its repositories from outside so tests can pass fakes.
class ShopApp extends StatefulWidget {
  const ShopApp({
    required this.shopProfileRepository,
    this.flavor,
    super.key,
  });

  final ShopProfileRepository shopProfileRepository;
  final Flavor? flavor;

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  late final ShopProfileCubit _profileCubit = ShopProfileCubit(
    widget.shopProfileRepository,
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
    return RepositoryProvider.value(
      value: widget.shopProfileRepository,
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
