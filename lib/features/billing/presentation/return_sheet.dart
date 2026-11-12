import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Choose what came back from [bill]; issues a credit note.
/// Returns the note, or `null` if dismissed.
Future<CreditNote?> showReturnSheet(BuildContext context, Bill bill) =>
    showModalBottomSheet<CreditNote>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => RepositoryProvider.value(
        value: context.read<ReturnsRepository>(),
        child: _ReturnSheet(bill: bill),
      ),
    );

class _ReturnSheet extends StatefulWidget {
  const _ReturnSheet({required this.bill});

  final Bill bill;

  @override
  State<_ReturnSheet> createState() => _ReturnSheetState();
}

class _ReturnSheetState extends State<_ReturnSheet> {
  late final List<BillLine> _lines = [
    for (final l in widget.bill.lines)
      if (l.id != null && l.returnable.isPositive) l,
  ];
  late final List<TextEditingController> _qty = [
    for (final _ in _lines) TextEditingController(),
  ];
  final _reason = TextEditingController();
  late PaymentMode _mode =
      widget.bill.partyId != null &&
          widget.bill.paymentMode == PaymentMode.credit
      ? PaymentMode.credit
      : (widget.bill.paymentMode == PaymentMode.credit
            ? PaymentMode.cash
            : widget.bill.paymentMode);
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _qty) {
      c.dispose();
    }
    _reason.dispose();
    super.dispose();
  }

  Quantity? _parsed(int i) {
    final t = _qty[i].text.trim();
    if (t.isEmpty) return Quantity.zero;
    return Quantity.tryParse(t);
  }

  bool _valid(int i) {
    final q = _parsed(i);
    return q != null && !(q > _lines[i].returnable);
  }

  /// Preview only; the repository computes the exact credit note.
  Money get _estimate {
    var paise = 0;
    for (var i = 0; i < _lines.length; i++) {
      final q = _parsed(i);
      if (q == null || !q.isPositive) continue;
      final l = _lines[i];
      paise += divRound(l.total.paise * q.milli, l.quantity.milli);
    }
    return Money.paise(paise);
  }

  List<ReturnLine> get _selection => [
    for (var i = 0; i < _lines.length; i++)
      if (_parsed(i)?.isPositive ?? false)
        (billLineId: _lines[i].id!, quantity: _parsed(i)!),
  ];

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final note = await context.read<ReturnsRepository>().returnItems(
        widget.bill.id,
        _selection,
        refundMode: _mode,
        reason: _reason.text,
      );
      if (mounted) Navigator.pop(context, note);
    } on ReturnTooLargeException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showSnack(context, e.toString());
    } on Object {
      if (!mounted) return;
      setState(() => _saving = false);
      showSnack(context, l10n.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final bill = widget.bill;
    final allValid = [for (var i = 0; i < _lines.length; i++) _valid(i)]
        .every((v) => v);
    final estimate = _estimate;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.returnTitle(bill.invoiceNo), style: text.titleLarge),
            const SizedBox(height: 4),
            Text(
              _lines.isEmpty ? l10n.returnNothingLeft : l10n.returnChooseQty,
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < _lines.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_lines[i].name, style: text.titleSmall),
                          Text(
                            l10n.returnLeft(
                              _lines[i].returnable.format(),
                              _lines[i].unit,
                            ),
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 96,
                      child: TextField(
                        key: Key('returnQty$i'),
                        controller: _qty[i],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                        ],
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixText: _lines[i].unit,
                          errorText: _valid(i) ? null : l10n.errQuantityInvalid,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    IconButton(
                      key: Key('returnAll$i'),
                      tooltip: l10n.returnLeft(
                        _lines[i].returnable.format(),
                        _lines[i].unit,
                      ),
                      icon: const Icon(Icons.done_all),
                      onPressed: () => setState(
                        () => _qty[i].text = _lines[i].returnable.format(),
                      ),
                    ),
                  ],
                ),
              ),
            if (_lines.isNotEmpty) ...[
              Text(l10n.returnRefund, style: text.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<PaymentMode>(
                showSelectedIcon: false,
                segments: [
                  for (final m in [
                    PaymentMode.cash,
                    PaymentMode.upi,
                    PaymentMode.card,
                  ])
                    ButtonSegment(value: m, label: Text(m.label(l10n))),
                  if (bill.partyId != null)
                    ButtonSegment(
                      value: PaymentMode.credit,
                      label: Text(PaymentMode.credit.label(l10n)),
                    ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              if (_mode == PaymentMode.credit)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.returnOffDues(bill.customerName ?? ''),
                    style: text.bodySmall,
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _reason,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.returnReason),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('saveReturnButton'),
                onPressed: _saving || !allValid || _selection.isEmpty
                    ? null
                    : _save,
                child: Text(l10n.returnSave(estimate.format())),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
