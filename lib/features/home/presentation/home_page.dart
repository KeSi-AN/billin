import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/inventory/presentation/stock_overview_page.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/widgets/shop_logo.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<ShopProfileCubit>().state;
    if (state is! ShopProfileReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.profile.name, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            key: const Key('settingsButton'),
            tooltip: l10n.actionSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ShopCard(profile: state.profile),
          const SizedBox(height: 12),
          const _TodayCard(),
          const SizedBox(height: 12),
          FilledButton.icon(
            key: const Key('newBillButton'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(64),
            ),
            onPressed: () => context.push(AppRoutes.billing),
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(l10n.actionNewBill),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
            children: [
              _ActionTile(
                key: const Key('salesTile'),
                icon: Icons.receipt_long_outlined,
                label: l10n.actionSales,
                onTap: () => context.push(AppRoutes.sales),
              ),
              _ActionTile(
                key: const Key('itemsTile'),
                icon: Icons.inventory_2_outlined,
                label: l10n.actionItems,
                onTap: () => context.push(AppRoutes.items),
              ),
              StreamBuilder<int>(
                stream: stockAlertCount(context.read<InventoryRepository>()),
                builder: (context, snapshot) => _ActionTile(
                  key: const Key('stockTile'),
                  icon: Icons.warehouse_outlined,
                  label: l10n.actionStock,
                  subtitle: l10n.homeStockAlerts(snapshot.data ?? 0),
                  alert: (snapshot.data ?? 0) > 0,
                  onTap: () => context.push(AppRoutes.stock),
                ),
              ),
              StreamBuilder<Money>(
                stream: context.read<PartyRepository>().watchTotalDue(),
                builder: (context, snapshot) {
                  final due = snapshot.data ?? Money.zero;
                  return _ActionTile(
                    key: const Key('customersTile'),
                    icon: Icons.people_outline,
                    label: l10n.actionCustomers,
                    subtitle: due.isPositive
                        ? l10n.homeCustomersDue(due.format())
                        : l10n.homeCustomersNone,
                    alert: due.isPositive,
                    onTap: () => context.push(AppRoutes.customers),
                  );
                },
              ),
              StreamBuilder<Money>(
                stream: context.read<PartyRepository>().watchTotalDue(
                  type: PartyType.supplier,
                ),
                builder: (context, snapshot) {
                  final owed = snapshot.data ?? Money.zero;
                  return _ActionTile(
                    key: const Key('purchasesTile'),
                    icon: Icons.local_shipping_outlined,
                    label: l10n.actionPurchases,
                    subtitle: owed.isPositive
                        ? l10n.balanceYouOwe(owed.format())
                        : null,
                    onTap: () => context.push(AppRoutes.purchases),
                  );
                },
              ),
              _ActionTile(
                key: const Key('expensesTile'),
                icon: Icons.payments_outlined,
                label: l10n.actionExpenses,
                onTap: () => context.push(AppRoutes.expenses),
              ),
              _ActionTile(
                key: const Key('reportsTile'),
                icon: Icons.bar_chart_outlined,
                label: l10n.actionReports,
                onTap: () => context.push(AppRoutes.reports),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return StreamBuilder<List<BillSummary>>(
      stream: context.read<BillRepository>().watchBetween(
        today,
        today.add(const Duration(days: 1)),
      ),
      builder: (context, snapshot) {
        final bills = (snapshot.data ?? const []).where((b) => !b.isCancelled);
        final total = bills.fold(Money.zero, (sum, b) => sum + b.grandTotal);
        return Card.outlined(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(AppRoutes.sales),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.homeToday, style: text.labelLarge),
                        Text(
                          total.format(),
                          key: const Key('todayTotal'),
                          style: text.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(l10n.homeTodaySummary(bills.length)),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
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
      profile.city,
      stateByCode(profile.stateCode)?.name,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    return Card(
      child: InkWell(
        key: const Key('editShopButton'),
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.editShop),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ShopLogo(path: profile.logoPath, name: profile.name, radius: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: text.titleMedium),
                    if (place.isNotEmpty) Text(place, style: text.bodySmall),
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
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.alert = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;

  /// Highlights the subtitle (something needs attention).
  final bool alert;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card.outlined(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.titleSmall),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: text.labelSmall?.copyWith(
                          color: alert ? scheme.error : null,
                        ),
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
