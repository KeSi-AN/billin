import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/india/phone.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/presentation/billing_cubit.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
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
  final _customerName = TextEditingController();
  final _customerPhone = TextEditingController();
  PaymentMode _mode = PaymentMode.cash;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_discount, _cashReceived, _customerName, _customerPhone]) {
      c.dispose();
    }
    super.dispose();
  }

  Money get _billDiscount => Money.tryParse(_discount.text) ?? Money.zero;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    try {
      final bill = await context.read<BillingCubit>().save(
        paymentMode: _mode,
        billDiscount: _billDiscount,
        customerName: _customerName.text,
        customerPhone: _customerPhone.text.trim().isEmpty
            ? null
            : IndianPhone.normalize(_customerPhone.text),
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
            const SizedBox(height: 16),
            Text(l10n.checkoutCustomer, style: text.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('customerNameField'),
              controller: _customerName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.fieldCustomerName),
              validator: (v) =>
                  _mode == PaymentMode.credit && (v ?? '').trim().isEmpty
                  ? l10n.checkoutCreditNeedsCustomer
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _customerPhone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.fieldCustomerPhone,
                prefixText: '+91 ',
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty || IndianPhone.isValidMobile(v!)
                  ? null
                  : l10n.errPhoneInvalid,
            ),
            const SizedBox(height: 24),
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
