import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/home/presentation/home_page.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/pages/shop_setup_page.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const setup = '/setup';
  static const home = '/home';
  static const editShop = '/settings/shop';
}

/// Routes, plus the first-launch rule: no shop profile → setup screen.
GoRouter buildRouter(ShopProfileCubit profile) => GoRouter(
  initialLocation: AppRoutes.splash,
  // Re-check redirects only when the *kind* of state changes (loading →
  // missing → ready). Re-running them on every profile edit would rebuild
  // the route stack mid-navigation and undo a `pop()`.
  refreshListenable: _StreamListenable(
    profile.stream.map((s) => s.runtimeType).distinct(),
  ),
  redirect: (context, state) {
    final at = state.matchedLocation;
    return switch (profile.state) {
      ShopProfileLoading() => at == AppRoutes.splash ? null : AppRoutes.splash,
      ShopProfileMissing() => at == AppRoutes.setup ? null : AppRoutes.setup,
      ShopProfileReady() =>
        at == AppRoutes.splash || at == AppRoutes.setup
            ? AppRoutes.home
            : null,
    };
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: AppRoutes.setup,
      builder: (context, state) => const ShopSetupPage(isEditing: false),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.editShop,
      builder: (context, state) => const ShopSetupPage(isEditing: true),
    ),
  ],
);

class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
