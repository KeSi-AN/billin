import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/month_switcher.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Purchases by month.
class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  DateTime _month = monthStart(DateTime.now());

  /// Typed purchase (stock comes in) or just a photo of the bill.
  Future<void> _add(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final route = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const Key('addPhotoPurchase'),
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.purchaseAddPhoto),
              subtitle: Text(l10n.purchaseAddPhotoHelp),
              onTap: () => Navigator.pop(context, AppRoutes.photoPurchase),
            ),
            ListTile(
              key: const Key('addTypedPurchase'),
              leading: const Icon(Icons.edit_note_outlined),
              title: Text(l10n.purchaseAddTyped),
              subtitle: Text(l10n.purchaseAddTypedHelp),
              onTap: () => Navigator.pop(context, AppRoutes.newPurchase),
            ),
          ],
        ),
      ),
    );
    if (route != null && context.mounted) await context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.purchasesTitle),
        actions: [
          TextButton.icon(
            key: const Key('suppliersButton'),
            onPressed: () => context.push(AppRoutes.suppliers),
            icon: const Icon(Icons.local_shipping_outlined),
            label: Text(l10n.suppliersTitle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addPurchaseButton'),
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.purchaseAdd),
      ),
      body: Column(
        children: [
          MonthSwitcher(
            month: _month,
            onChanged: (m) => setState(() => _month = m),
            previousLabel: l10n.reportsPreviousMonth,
            nextLabel: l10n.reportsNextMonth,
          ),
          Expanded(
            child: StreamBuilder<List<Purchase>>(
              key: ValueKey(_month),
              stream: context.read<PurchaseRepository>().watchBetween(
                _month,
                nextMonth(_month),
              ),
              builder: (context, snapshot) {
                final list = snapshot.data;
                if (list == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final total = list
                    .where((p) => !p.isCancelled)
                    .fold(Money.zero, (s, p) => s + p.total);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(
                          l10n.purchasesMonthTotal,
                          style: text.labelLarge,
                        ),
                        trailing: Text(
                          total.format(),
                          key: const Key('purchasesTotal'),
                          style: text.titleLarge,
                        ),
                      ),
                    ),
                    if (list.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(child: Text(l10n.purchasesEmpty)),
                      ),
                    for (final p in list)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => context.push(AppRoutes.purchase(p.id)),
                        title: Text(p.supplierName ?? '—'),
                        subtitle: Text(
                          [
                            formatDate(p.purchasedAt),
                            ?p.supplierInvoiceNo,
                            if (p.lines.isEmpty && p.photoPath != null)
                              l10n.purchaseFromPhoto
                            else
                              l10n.purchaseItems(p.lines.length),
                            if (p.due.isPositive)
                              l10n.balanceYouOwe(p.due.format()),
                            if (p.isCancelled) l10n.purchaseCancelled,
                          ].join(' · '),
                        ),
                        trailing: Text(
                          p.total.format(),
                          style: text.titleSmall?.copyWith(
                            decoration: p.isCancelled
                                ? TextDecoration.lineThrough
                                : null,
                            color: p.isCancelled ? scheme.outline : null,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
