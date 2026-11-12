import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// One saved purchase, with cancel.
class PurchasePage extends StatefulWidget {
  const PurchasePage({required this.purchaseId, super.key});

  final int purchaseId;

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late Future<Purchase?> _purchase = _load();

  Future<Purchase?> _load() =>
      context.read<PurchaseRepository>().byId(widget.purchaseId);

  Future<void> _cancel() async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l10n.purchaseCancel,
      body: l10n.purchaseCancelBody,
      confirmLabel: l10n.purchaseCancel,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.read<PurchaseRepository>().cancel(widget.purchaseId);
    setState(() {
      _purchase = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return FutureBuilder<Purchase?>(
      future: _purchase,
      builder: (context, snapshot) {
        final p = snapshot.data;
        Widget row(String label, Money amount, {bool strong = false}) => Row(
          children: [
            Expanded(
              child: Text(label, style: strong ? text.titleLarge : null),
            ),
            Text(amount.format(), style: strong ? text.titleLarge : null),
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(p?.supplierName ?? l10n.purchasesTitle),
            actions: [
              if (p != null && !p.isCancelled)
                PopupMenuButton<String>(
                  onSelected: (_) => _cancel(),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'cancel',
                      child: Text(l10n.purchaseCancel),
                    ),
                  ],
                ),
            ],
          ),
          body: p == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (p.isCancelled)
                      Card(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: ListTile(title: Text(l10n.purchaseCancelled)),
                      ),
                    Text(
                      [
                        formatDate(p.purchasedAt),
                        if (p.supplierInvoiceNo != null)
                          '#${p.supplierInvoiceNo}',
                        p.paymentMode.label(l10n),
                      ].join(' · '),
                    ),
                    if (p.supplierGstin != null)
                      Text('GSTIN ${p.supplierGstin}'),
                    const Divider(height: 24),
                    for (final l in p.lines)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.name),
                        subtitle: Text(
                          '${l.quantity.format()} ${l.unit} × ${l.unitCost.format()}'
                          '${l.taxRate.isZero ? '' : ' · GST ${l.taxRate.label}'}'
                          '${l.batchNo == null ? '' : ' · ${l.batchNo}'}',
                        ),
                        trailing: Text(l.total.format()),
                      ),
                    const Divider(height: 24),
                    row(l10n.purchaseTaxable, p.taxable),
                    row(l10n.purchaseGst, p.tax),
                    row(l10n.purchaseTotal, p.total, strong: true),
                    if (p.due.isPositive && !p.isCancelled)
                      Text(
                        l10n.balanceYouOwe(p.due.format()),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
