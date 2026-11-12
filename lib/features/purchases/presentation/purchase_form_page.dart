import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/presentation/customer_picker.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/presentation/item_picker.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Enter a supplier's bill: items, cost, GST, payment.
class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNo = TextEditingController();
  final _paidNow = TextEditingController();
  final _lines = <PurchaseDraftLine>[];
  Party? _supplier;
  DateTime _date = DateTime.now();
  PaymentMode _mode = PaymentMode.cash;
  bool _supplierMissing = false;
  bool _saving = false;

  @override
  void dispose() {
    _invoiceNo.dispose();
    _paidNow.dispose();
    super.dispose();
  }

  BillTotals get _totals => BillCalculator.calculate([
    for (final l in _lines)
      BillLineInput(
        unitPrice: l.unitCost,
        quantity: l.quantity,
        taxRate: l.taxRate,
        priceIncludesTax: l.costIncludesTax,
      ),
  ], roundToRupee: false);

  Future<void> _pickSupplier() async {
    final p = await showCustomerPicker(context, type: PartyType.supplier);
    if (p != null && mounted) {
      setState(() {
        _supplier = p;
        _supplierMissing = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) {
      setState(
        () => _date = DateTime(
          picked.year,
          picked.month,
          picked.day,
          now.hour,
          now.minute,
        ),
      );
    }
  }

  Future<void> _addItem() async {
    final item = await showItemPicker(context);
    if (item == null || !mounted) return;
    final line = await showPurchaseLineSheet(context, item);
    if (line != null) setState(() => _lines.add(line));
  }

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    final needsSupplier = _mode == PaymentMode.credit && _supplier == null;
    setState(() => _supplierMissing = needsSupplier);
    if (!valid || needsSupplier || _lines.isEmpty) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    await context.read<PurchaseRepository>().create(
      PurchaseDraft(
        lines: _lines,
        partyId: _supplier?.id,
        supplierInvoiceNo: _invoiceNo.text,
        purchasedAt: _date,
        paymentMode: _mode,
        paidNow: _mode == PaymentMode.credit
            ? (Money.tryParse(_paidNow.text) ?? Money.zero)
            : Money.zero,
      ),
    );
    if (!mounted) return;
    showSnack(context, l10n.purchaseSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final totals = _totals;
    final paid = Money.tryParse(_paidNow.text) ?? Money.zero;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.purchaseNew)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              key: const Key('pickSupplierTile'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.local_shipping_outlined),
              title: Text(_supplier?.name ?? l10n.pickSupplier),
              subtitle: _supplierMissing
                  ? Text(
                      l10n.supplierNeeded,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : (_supplier?.gstin == null
                        ? null
                        : Text('GSTIN ${_supplier!.gstin}')),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickSupplier,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('supplierInvoiceField'),
                    controller: _invoiceNo,
                    decoration: InputDecoration(
                      labelText: l10n.fieldSupplierInvoice,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                  ),
                  onPressed: _pickDate,
                  icon: const Icon(Icons.event_outlined),
                  label: Text(formatDate(_date)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_lines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.purchaseNoLines, textAlign: TextAlign.center),
              ),
            for (var i = 0; i < _lines.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_lines[i].name),
                subtitle: Text(
                  '${_lines[i].quantity.format()} ${_lines[i].unit} × ${_lines[i].unitCost.format()}'
                  '${_lines[i].taxRate.isZero ? '' : ' + GST ${_lines[i].taxRate.label}'}'
                  '${_lines[i].batchNo == null ? '' : ' · ${_lines[i].batchNo}'}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(totals.lines[i].total.format()),
                    IconButton(
                      tooltip: l10n.lineRemove,
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _lines.removeAt(i)),
                    ),
                  ],
                ),
              ),
            OutlinedButton.icon(
              key: const Key('purchaseAddItemButton'),
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: Text(l10n.purchaseAddItem),
            ),
            const Divider(height: 32),
            _row(l10n.purchaseTaxable, totals.taxable, text.bodyMedium),
            _row(l10n.purchaseGst, totals.tax, text.bodyMedium),
            _row(l10n.purchaseTotal, totals.grandTotal, text.titleLarge),
            const SizedBox(height: 16),
            SegmentedButton<PaymentMode>(
              showSelectedIcon: false,
              segments: [
                for (final m in PaymentMode.values)
                  ButtonSegment(value: m, label: Text(m.label(l10n))),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            if (_mode == PaymentMode.credit) ...[
              const SizedBox(height: 12),
              MoneyField(
                controller: _paidNow,
                label: l10n.purchasePaidNow,
                helperText: (totals.grandTotal - paid).isPositive
                    ? l10n.purchaseDueAfter((totals.grandTotal - paid).format())
                    : l10n.optional,
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('savePurchaseButton'),
              onPressed: _saving || _lines.isEmpty ? null : _save,
              child: Text(l10n.purchaseSave(totals.grandTotal.format())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, Money amount, TextStyle? style) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(amount.format(), style: style),
      ],
    ),
  );
}

/// Quantity, cost, GST and (for batch items) batch/expiry of one line.
Future<PurchaseDraftLine?> showPurchaseLineSheet(
  BuildContext context,
  Item item,
) => showModalBottomSheet<PurchaseDraftLine>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _LineSheet(item: item),
);

class _LineSheet extends StatefulWidget {
  const _LineSheet({required this.item});

  final Item item;

  @override
  State<_LineSheet> createState() => _LineSheetState();
}

class _LineSheetState extends State<_LineSheet> {
  final _formKey = GlobalKey<FormState>();
  final _qty = TextEditingController();
  late final _cost = TextEditingController(
    text: widget.item.costPrice?.toInput() ?? '',
  );
  final _batch = TextEditingController();
  late TaxRate _rate = widget.item.taxRate;
  bool _includesTax = false;
  DateTime? _expiry;

  @override
  void dispose() {
    _qty.dispose();
    _cost.dispose();
    _batch.dispose();
    super.dispose();
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiry ?? DateTime(now.year, now.month + 6),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 15),
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  void _done() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final item = widget.item;
    Navigator.pop(
      context,
      PurchaseDraftLine(
        itemId: item.id,
        name: item.name,
        unit: item.unit,
        hsn: item.hsn,
        quantity: Quantity.tryParse(_qty.text)!,
        unitCost: Money.tryParse(_cost.text)!,
        costIncludesTax: _includesTax,
        taxRate: _rate,
        batchNo: _batch.text.trim().isEmpty ? null : _batch.text.trim(),
        expiry: _expiry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
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
              Text(item.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: QuantityField(
                      key: const Key('purchaseQtyField'),
                      controller: _qty,
                      label: '${l10n.fieldQuantity} (${item.unit})',
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoneyField(
                      key: const Key('purchaseCostField'),
                      controller: _cost,
                      label: l10n.fieldUnitCost(item.unit),
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TaxRateField(
                value: _rate,
                onChanged: (r) => setState(() => _rate = r),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.fieldCostIncludesTax),
                value: _includesTax,
                onChanged: (v) => setState(() => _includesTax = v),
              ),
              if (item.tracksBatches)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _batch,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: l10n.fieldBatchNo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 56),
                        ),
                        onPressed: _pickExpiry,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(
                          _expiry == null
                              ? l10n.fieldExpiry
                              : formatDate(_expiry!),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('purchaseLineDoneButton'),
                onPressed: _done,
                child: Text(l10n.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
