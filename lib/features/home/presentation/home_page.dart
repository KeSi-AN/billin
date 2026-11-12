import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/widgets/shop_logo.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Phase 0 home: shows the shop and where later features will live.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<ShopProfileCubit>().state;
    if (state is! ShopProfileReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final actions = <(IconData, String)>[
      (Icons.receipt_long_outlined, l10n.actionNewBill),
      (Icons.inventory_2_outlined, l10n.actionItems),
      (Icons.people_outline, l10n.actionCustomers),
      (Icons.bar_chart_outlined, l10n.actionReports),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(state.profile.name, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            key: const Key('editShopButton'),
            tooltip: l10n.homeEditShop,
            icon: const Icon(Icons.storefront_outlined),
            onPressed: () => context.push(AppRoutes.editShop),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ShopCard(profile: state.profile),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              for (final (icon, label) in actions)
                _ActionTile(icon: icon, label: label),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.profile});

  final ShopProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final place = [
      profile.addressLine,
      profile.city,
      stateByCode(profile.stateCode)?.name,
      profile.pincode,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.editShop),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ShopLogo(path: profile.logoPath, name: profile.name, radius: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: text.titleMedium),
                    if (place.isNotEmpty) Text(place, style: text.bodySmall),
                    if (profile.phone != null)
                      Text('+91 ${profile.phone}', style: text.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      profile.gstin != null
                          ? l10n.homeGstin(profile.gstin!)
                          : l10n.homeNotGst,
                      style: text.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card.outlined(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.homeComingSoon(label))),
          ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: scheme.primary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    l10n.comingSoon,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
