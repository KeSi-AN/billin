import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/presentation/billing_cubit.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/presentation/customer_picker.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Discount, payment mode and customer, then save. Pops with the saved
/// [Bill], or `null` if closed.
Future<Bill?> showCheckoutSheet(BuildContext context) =>
    showModalBottomSheet<Bill>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<BillingCubit>(),
        child: const _CheckoutSheet(),
      ),
    );

class _CheckoutSheet extends StatefulWidget {
  const _CheckoutSheet();

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  final _formKey = GlobalKey<FormState>();
  final _discount = TextEditingController();
  final _cashReceived = TextEditingController();
  final _paidNow = TextEditingController();
  PaymentMode _mode = PaymentMode.cash;
  Party? _customer;
  bool _customerMissing = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_discount, _cashReceived, _paidNow]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Phone and current due under the chosen customer, or nothing (an empty
  /// second line would push the name up).
  Widget? _customerDetails(AppLocalizations l10n) {
    final c = _customer;
    if (c == null) return null;
    final details = [
      if (c.phone != null) '+91 ${c.phone}',
      if (c.hasDue) l10n.customerCurrentDue(c.balance.format()),
    ];
    return details.isEmpty ? null : Text(details.join(' · '));
  }

  Future<void> _pickCustomer() async {
    final party = await showCustomerPicker(context);
    if (party != null && mounted) {
      setState(() {
        _customer = party;
        _customerMissing = false;
      });
    }
  }

  Money get _billDiscount => Money.tryParse(_discount.text) ?? Money.zero;

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    final needsCustomer = _mode == PaymentMode.credit && _customer == null;
    setState(() => _customerMissing = needsCustomer);
    if (!valid || needsCustomer) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    try {
      final bill = await context.read<BillingCubit>().save(
        paymentMode: _mode,
        billDiscount: _billDiscount,
        customer: _customer,
        paidNow: _mode == PaymentMode.credit
            ? (Money.tryParse(_paidNow.text) ?? Money.zero)
            : Money.zero,
      );
      if (mounted) Navigator.pop(context, bill);
    } on Object {
      if (!mounted) return;
      setState(() => _saving = false);
      showSnack(context, l10n.checkoutSaveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final totals = context.read<BillingCubit>().preview(_billDiscount);
    final cash = Money.tryParse(_cashReceived.text);
    final change = cash == null ? null : cash - totals.grandTotal;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(l10n.checkoutTitle, style: text.titleLarge),
            const SizedBox(height: 12),
            TotalsTable(totals: totals),
            const Divider(height: 24),
            MoneyField(
              key: const Key('billDiscountField'),
              controller: _discount,
              label: l10n.checkoutBillDiscount,
              helperText: l10n.optional,
              onChanged: (_) => setState(() {}),
              extraValidator: (d) =>
                  d > totals.itemsTotal ? l10n.errAmountInvalid : null,
            ),
            const SizedBox(height: 16),
            Text(l10n.checkoutPayment, style: text.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<PaymentMode>(
              showSelectedIcon: false,
              segments: [
                for (final m in PaymentMode.values)
                  ButtonSegment(
                    value: m,
                    label: Text(m.label(l10n)),
                    icon: Icon(m.icon),
                  ),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            if (_mode == PaymentMode.cash) ...[
              const SizedBox(height: 16),
              MoneyField(
                controller: _cashReceived,
                label: l10n.checkoutCashReceived,
                helperText: change != null && !change.isNegative
                    ? l10n.checkoutChange(change.format())
                    : l10n.optional,
                onChanged: (_) => setState(() {}),
              ),
            ],
            if (_mode == PaymentMode.credit) ...[
              const SizedBox(height: 16),
              MoneyField(
                key: const Key('paidNowField'),
                controller: _paidNow,
                label: l10n.checkoutPaidNow,
                helperText: () {
                  final paid = Money.tryParse(_paidNow.text) ?? Money.zero;
                  final due = totals.grandTotal - paid;
                  return due.isPositive
                      ? l10n.checkoutDueAfter(due.format())
                      : l10n.checkoutPaidNowHelp;
                }(),
                onChanged: (_) => setState(() {}),
                extraValidator: (m) =>
                    m > totals.grandTotal ? l10n.errAmountInvalid : null,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              _mode == PaymentMode.credit
                  ? l10n.customerPickerTitle
                  : l10n.checkoutCustomer,
              style: text.titleSmall,
            ),
            ListTile(
              key: const Key('pickCustomerTile'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline),
              title: Text(_customer?.name ?? l10n.checkoutPickCustomer),
              subtitle: _customerMissing
                  ? Text(
                      l10n.checkoutCustomerNeeded,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : _customerDetails(l10n),
              trailing: _customer == null
                  ? const Icon(Icons.chevron_right)
                  : IconButton(
                      tooltip: l10n.cancel,
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _customer = null),
                    ),
              onTap: _pickCustomer,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('saveBillButton'),
              onPressed: _saving ? null : _save,
              child: Text(
                _saving
                    ? l10n.saving
                    : '${l10n.checkoutSave} · ${totals.grandTotal.format()}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Items total → discounts → GST → round-off → total. Used at checkout and
/// on the saved bill.
class TotalsTable extends StatelessWidget {
  const TotalsTable({required this.totals, super.key});

  final BillTotals totals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget row(String label, Money amount, {bool strong = false, Key? key}) {
      final style = strong ? text.titleLarge : text.bodyMedium;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(child: Text(label, style: style)),
            Text(amount.format(), key: key, style: style),
          ],
        ),
      );
    }

    return Column(
      children: [
        row(l10n.checkoutItemsTotal, totals.itemsTotal),
        if (!totals.billDiscount.isZero)
          row(l10n.checkoutBillDiscount, -totals.billDiscount),
        if (!totals.tax.isZero) ...[
          row(l10n.checkoutTaxable, totals.taxable),
          row(l10n.checkoutCgst, totals.cgst),
          row(l10n.checkoutSgst, totals.sgst),
        ],
        if (!totals.roundOff.isZero)
          row(l10n.checkoutRoundOff, totals.roundOff),
        const SizedBox(height: 4),
        row(
          l10n.checkoutGrandTotal,
          totals.grandTotal,
          strong: true,
          key: const Key('grandTotal'),
        ),
      ],
    );
  }
}
