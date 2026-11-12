import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/presentation/bill_actions.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/billing/presentation/return_sheet.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// A saved bill: shown right after checkout ([justSaved]) and from Sales.
class BillPage extends StatefulWidget {
  const BillPage({required this.billId, this.justSaved = false, super.key});

  final int billId;
  final bool justSaved;

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  late Future<Bill?> _bill = _load();

  Future<Bill?> _load() => context.read<BillRepository>().byId(widget.billId);
  late Future<List<CreditNote>> _notes = _loadNotes();

  Future<List<CreditNote>> _loadNotes() =>
      context.read<ReturnsRepository>().forBill(widget.billId);

  Future<void> _return(Bill bill) async {
    final l10n = AppLocalizations.of(context);
    final note = await showReturnSheet(context, bill);
    if (note == null || !mounted) return;
    showSnack(context, l10n.returnSaved(note.noteNo));
    setState(() {
      _bill = _load();
      _notes = _loadNotes();
    });
  }

  Future<void> _cancel(Bill bill) async {
    final l10n = AppLocalizations.of(context);
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.billCancelTitle(bill.invoiceNo)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.billCancelBody),
            const SizedBox(height: 16),
            TextField(
              controller: reason,
              decoration: InputDecoration(labelText: l10n.billCancelReason),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(64, 40),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.billCancel),
          ),
        ],
      ),
    );
    final text = reason.text;
    reason.dispose();
    if (ok != true || !mounted) return;
    await context.read<BillRepository>().cancel(bill.id, reason: text);
    setState(() {
      _bill = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<Bill?>(
      future: _bill,
      builder: (context, snapshot) {
        final bill = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(bill?.invoiceNo ?? ''),
            actions: [
              if (bill != null && !bill.isCancelled)
                PopupMenuButton<String>(
                  key: const Key('billMenu'),
                  onSelected: (v) =>
                      v == 'return' ? _return(bill) : _cancel(bill),
                  itemBuilder: (context) => [
                    if (bill.lines.any((l) => l.returnable.isPositive))
                      PopupMenuItem(
                        value: 'return',
                        child: Text(l10n.billReturn),
                      ),
                    PopupMenuItem(
                      value: 'cancel',
                      child: Text(l10n.billCancel),
                    ),
                  ],
                ),
            ],
          ),
          body: bill == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<CreditNote>>(
                  future: _notes,
                  builder: (context, notes) => _BillBody(
                    bill: bill,
                    justSaved: widget.justSaved,
                    creditNotes: notes.data ?? const [],
                  ),
                ),
          bottomNavigationBar: bill == null
              ? null
              : _BillActionBar(bill: bill, justSaved: widget.justSaved),
        );
      },
    );
  }
}

class _BillBody extends StatelessWidget {
  const _BillBody({
    required this.bill,
    required this.justSaved,
    this.creditNotes = const [],
  });

  final Bill bill;
  final bool justSaved;
  final List<CreditNote> creditNotes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    Widget amountRow(String label, Money amount, {bool strong = false}) {
      final style = strong ? text.titleLarge : text.bodyMedium;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(child: Text(label, style: style)),
            Text(amount.format(), style: style),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (justSaved && !bill.isCancelled)
          Card(
            color: scheme.primaryContainer,
            child: ListTile(
              leading: Icon(
                Icons.check_circle,
                color: scheme.onPrimaryContainer,
              ),
              title: Text(
                l10n.billSaved,
                style: TextStyle(color: scheme.onPrimaryContainer),
              ),
            ),
          ),
        if (bill.isCancelled)
          Card(
            color: scheme.errorContainer,
            child: ListTile(
              leading: Icon(Icons.block, color: scheme.onErrorContainer),
              title: Text(
                l10n.billCancelledOn(formatDateTime(bill.cancelledAt!)),
                style: TextStyle(color: scheme.onErrorContainer),
              ),
              subtitle: bill.cancelReason == null
                  ? null
                  : Text(
                      bill.cancelReason!,
                      style: TextStyle(color: scheme.onErrorContainer),
                    ),
            ),
          ),
        const SizedBox(height: 8),
        Text(formatDateTime(bill.billedAt), style: text.bodyMedium),
        Text(
          l10n.billPaidBy(bill.paymentMode.label(l10n)),
          style: text.bodyMedium,
        ),
        if (bill.buyerGstin != null)
          Text(l10n.billBuyerGstin(bill.buyerGstin!), style: text.bodyMedium),
        if (bill.placeOfSupply != null)
          Text(
            l10n.billPlaceOfSupply(
              stateByCode(bill.placeOfSupply)?.name ?? bill.placeOfSupply!,
            ),
            style: text.bodyMedium,
          ),
        if (bill.customerName != null || bill.customerPhone != null)
          InkWell(
            // Linked customer: open their khata.
            onTap: bill.partyId == null
                ? null
                : () => context.push(AppRoutes.customer(bill.partyId!)),
            child: Text(
              '${l10n.billCustomer}: ${[bill.customerName, if (bill.customerPhone != null) '+91 ${bill.customerPhone}'].whereType<String>().join(' · ')}',
              style: text.bodyMedium?.copyWith(
                decoration: bill.partyId == null
                    ? null
                    : TextDecoration.underline,
              ),
            ),
          ),
        const Divider(height: 24),
        for (final line in bill.lines)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(line.name, style: text.titleSmall),
                      Text(
                        l10n.billQtyAtPrice(
                          line.quantity.format(),
                          line.unit,
                          line.unitPrice.format(),
                        ),
                        style: text.bodySmall,
                      ),
                      if (line.returned.isPositive)
                        Text(
                          '${l10n.billCreditNotes}: ${line.returned.format()} ${line.unit}',
                          style: text.bodySmall?.copyWith(color: scheme.error),
                        ),
                      if (!line.discount.isZero)
                        Text(
                          l10n.lineDiscountTag(line.discount.format()),
                          style: text.bodySmall?.copyWith(
                            color: scheme.tertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(line.total.format(), style: text.titleSmall),
              ],
            ),
          ),
        const Divider(height: 24),
        amountRow(l10n.checkoutItemsTotal, bill.itemsTotal),
        if (!bill.billDiscount.isZero)
          amountRow(l10n.checkoutBillDiscount, -bill.billDiscount),
        if (!bill.tax.isZero) ...[
          amountRow(l10n.checkoutTaxable, bill.taxable),
          for (final b in bill.taxBuckets)
            if (bill.interState)
              amountRow('${l10n.checkoutIgst} ${b.rate.label}', b.tax)
            else ...[
              amountRow('${l10n.checkoutCgst} ${b.rate.halfLabel}', b.cgst),
              amountRow('${l10n.checkoutSgst} ${b.rate.halfLabel}', b.sgst),
            ],
        ],
        if (!bill.roundOff.isZero)
          amountRow(l10n.checkoutRoundOff, bill.roundOff),
        const SizedBox(height: 4),
        amountRow(l10n.checkoutGrandTotal, bill.grandTotal, strong: true),
        if (bill.due.isPositive && !bill.isCancelled) ...[
          amountRow(l10n.billPaid, bill.paid),
          amountRow(l10n.billDue, bill.due),
        ],
        if (!bill.totalDiscount.isZero)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.billYouSaved(bill.totalDiscount.format()),
              style: text.bodySmall?.copyWith(color: scheme.tertiary),
            ),
          ),
        if (creditNotes.isNotEmpty) ...[
          const Divider(height: 24),
          Text(l10n.billCreditNotes, style: text.titleSmall),
          for (final n in creditNotes)
            ListTile(
              key: Key('creditNote${n.id}'),
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.assignment_return_outlined),
              title: Text(l10n.creditNoteLine(n.noteNo, n.total.format())),
              subtitle: Text(
                [
                  formatDate(n.issuedAt),
                  n.refundMode.label(l10n),
                  for (final l in n.lines) '${l.name} × ${l.quantity.format()}',
                  ?n.reason,
                ].join(' · '),
              ),
            ),
        ],
        // Only for the shopkeeper's eyes: not printed on receipts or PDFs.
        if (bill.profit != null && !bill.isCancelled)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              bill.profitIsPartial
                  ? l10n.billProfitPartial(bill.profit!.format())
                  : l10n.billProfit(bill.profit!.format()),
              key: const Key('billProfit'),
              style: text.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _BillActionBar extends StatelessWidget {
  const _BillActionBar({required this.bill, required this.justSaved});

  final Bill bill;
  final bool justSaved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actions = context.read<BillActions>();
    return Material(
      elevation: 3,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('printBillButton'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                  onPressed: bill.isCancelled
                      ? null
                      : () => actions.print(context, bill),
                  icon: const Icon(Icons.print_outlined),
                  label: Text(l10n.billPrint),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('shareBillButton'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                  onPressed: () => actions.share(context, bill),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(l10n.billShare),
                ),
              ),
              if (justSaved) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    key: const Key('newBillButton'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                    onPressed: () => context.pushReplacement(AppRoutes.billing),
                    child: Text(l10n.billNewBill),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
