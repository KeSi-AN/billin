import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/customers/domain/customer_actions.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/presentation/balance_text.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// One customer: balance, actions, and their khata.
class CustomerPage extends StatelessWidget {
  const CustomerPage({required this.partyId, super.key});

  final int partyId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = context.read<PartyRepository>();
    return StreamBuilder<Party?>(
      stream: repo.watch(partyId),
      builder: (context, snapshot) {
        final party = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(party?.name ?? ''),
            actions: [
              if (party != null)
                IconButton(
                  key: const Key('editCustomerButton'),
                  tooltip: l10n.customerEdit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.push(AppRoutes.editParty(party.type, partyId)),
                ),
            ],
          ),
          body: party == null
              ? const Center(child: CircularProgressIndicator())
              : _Body(party: party),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.party});

  final Party party;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final actions = context.read<CustomerActions>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (party.phone != null)
                  Text('+91 ${party.phone}', style: text.bodyMedium),
                if (party.addressLine != null)
                  Text(party.addressLine!, style: text.bodySmall),
                const SizedBox(height: 8),
                BalanceText(
                  party.balance,
                  key: const Key('customerBalance'),
                  style: text.headlineSmall,
                  supplier: party.type == PartyType.supplier,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      key: const Key('receivePaymentButton'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 44),
                      ),
                      onPressed: () => showReceivePaymentSheet(context, party),
                      icon: const Icon(Icons.payments_outlined),
                      label: Text(
                        party.type == PartyType.supplier
                            ? l10n.paySupplier
                            : l10n.receivePayment,
                      ),
                    ),
                    if (party.type == PartyType.customer)
                      OutlinedButton.icon(
                        key: const Key('remindButton'),
                        onPressed: party.phone == null || !party.hasDue
                            ? null
                            : () => actions.remind(context, party),
                        icon: const Icon(Icons.chat_outlined),
                        label: Text(l10n.remindWhatsApp),
                      ),
                    OutlinedButton.icon(
                      key: const Key('statementButton'),
                      onPressed: () => actions.shareStatement(context, party),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(l10n.statement),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(l10n.ledgerTitle, style: text.titleMedium),
        StreamBuilder<List<PartyEntry>>(
          stream: context.read<PartyRepository>().watchEntries(party.id!),
          builder: (context, snapshot) {
            final entries = snapshot.data ?? const <PartyEntry>[];
            if (entries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text(l10n.ledgerEmpty)),
              );
            }
            return Column(
              children: [for (final e in entries) EntryTile(entry: e)],
            );
          },
        ),
      ],
    );
  }
}

class EntryTile extends StatelessWidget {
  const EntryTile({required this.entry, super.key});

  final PartyEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final e = entry;
    final invoice = e.invoiceNo ?? '';
    final title = switch (e.type) {
      EntryType.opening => l10n.entryOpening,
      EntryType.sale => l10n.entrySale(invoice),
      EntryType.payment when e.billId != null => l10n.entryPaidAtBilling(
        invoice,
      ),
      EntryType.payment => l10n.entryPayment,
      EntryType.cancel => l10n.entryCancel(invoice),
      EntryType.adjust => l10n.entryAdjust,
      EntryType.purchase => l10n.entryPurchase,
      EntryType.salesReturn => l10n.entryReturn(invoice),
    };
    final sub = [
      formatDateTime(e.at),
      if (e.paymentMode != null && e.billId == null) e.paymentMode!.label(l10n),
      // Bill-linked entries already say what they are in the title.
      if (e.billId == null) ?e.note,
      l10n.balanceAfter(e.balanceAfter.format()),
    ].join(' · ');
    final owesMore = e.amount.isPositive;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: e.billId == null
          ? null
          : () => context.push(AppRoutes.bill(e.billId!)),
      title: Text(title),
      subtitle: Text(sub),
      trailing: Text(
        '${owesMore ? '+' : '−'}${(owesMore ? e.amount : -e.amount).format()}',
        style: TextStyle(
          color: owesMore ? scheme.error : scheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Record money received from a customer.
Future<void> showReceivePaymentSheet(BuildContext context, Party party) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RepositoryProvider.value(
        value: context.read<PartyRepository>(),
        child: _PaymentSheet(party: party),
      ),
    );

class _PaymentSheet extends StatefulWidget {
  const _PaymentSheet({required this.party});

  final Party party;

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.party.hasDue ? widget.party.balance.toInput() : '',
  );
  final _note = TextEditingController();
  PaymentMode _mode = PaymentMode.cash;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final amount = Money.tryParse(_amount.text)!;
    await context.read<PartyRepository>().receivePayment(
      widget.party.id!,
      amount,
      mode: _mode,
      note: _note.text,
    );
    if (!mounted) return;
    Navigator.pop(context);
    showSnack(context, l10n.paymentSaved(amount.format()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final due = widget.party.balance;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.party.type == PartyType.supplier
                    ? l10n.paySupplierTitle(widget.party.name)
                    : l10n.receivePaymentTitle(widget.party.name),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BalanceText(
                due,
                supplier: widget.party.type == PartyType.supplier,
              ),
              const SizedBox(height: 16),
              MoneyField(
                key: const Key('paymentAmountField'),
                controller: _amount,
                label: widget.party.type == PartyType.supplier
                    ? l10n.paymentMade
                    : l10n.paymentAmount,
                isRequired: true,
                autofocus: true,
                extraValidator: (m) =>
                    m.isPositive ? null : l10n.errPaymentZero,
              ),
              if (due.isPositive)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ActionChip(
                    label: Text(l10n.payFull(due.format())),
                    onPressed: () =>
                        setState(() => _amount.text = due.toInput()),
                  ),
                ),
              const SizedBox(height: 12),
              SegmentedButton<PaymentMode>(
                showSelectedIcon: false,
                segments: [
                  for (final m in [
                    PaymentMode.cash,
                    PaymentMode.upi,
                    PaymentMode.card,
                  ])
                    ButtonSegment(
                      value: m,
                      label: Text(m.label(l10n)),
                      icon: Icon(m.icon),
                    ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                decoration: InputDecoration(labelText: l10n.stockNote),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('savePaymentButton'),
                onPressed: _saving ? null : _save,
                child: Text(_saving ? l10n.saving : l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
