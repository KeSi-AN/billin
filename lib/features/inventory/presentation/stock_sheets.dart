import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Receive stock. Returns `true` when saved.
Future<bool> showAddStockSheet(BuildContext context, Item item) async =>
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RepositoryProvider.value(
        value: context.read<InventoryRepository>(),
        child: _StockSheet(item: item, adjust: false),
      ),
    ) ??
    false;

/// Set stock (or one batch) to a counted quantity. Returns `true` when saved.
Future<bool> showAdjustStockSheet(
  BuildContext context,
  Item item, {
  StockBatch? batch,
}) async =>
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RepositoryProvider.value(
        value: context.read<InventoryRepository>(),
        child: _StockSheet(item: item, adjust: true, batch: batch),
      ),
    ) ??
    false;

class _StockSheet extends StatefulWidget {
  const _StockSheet({required this.item, required this.adjust, this.batch});

  final Item item;
  final bool adjust;
  final StockBatch? batch;

  @override
  State<_StockSheet> createState() => _StockSheetState();
}

class _StockSheetState extends State<_StockSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _qty = TextEditingController(
    text: widget.adjust
        ? (widget.batch?.quantity ?? widget.item.stock).format()
        : '',
  );
  final _batchNo = TextEditingController();
  final _note = TextEditingController();
  DateTime? _expiry;
  bool _saving = false;

  bool get _needsBatch => !widget.adjust && widget.item.tracksBatches;

  @override
  void dispose() {
    _qty.dispose();
    _batchNo.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiry ?? DateTime(now.year, now.month + 6),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 15),
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final inventory = context.read<InventoryRepository>();
    final qty = Quantity.tryParse(_qty.text)!;
    if (widget.adjust) {
      await inventory.adjustStock(
        widget.item.id!,
        qty,
        batchId: widget.batch?.id,
        note: _note.text,
      );
    } else {
      await inventory.addStock(
        widget.item.id!,
        qty,
        batchNo: _batchNo.text,
        expiry: _expiry,
        note: _note.text,
      );
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = widget.item.unit;
    final title = widget.adjust
        ? (widget.batch == null
              ? l10n.stockAdjustTitle
              : '${l10n.stockAdjustTitle} · ${widget.batch!.batchNo}')
        : l10n.stockAddTitle;
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
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(widget.item.name),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('stockQtyField'),
                controller: _qty,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: widget.adjust
                      ? l10n.stockCounted(unit)
                      : l10n.stockAddQty(unit),
                ),
                validator: (v) {
                  final q = Quantity.tryParse(v ?? '');
                  if (q == null) return l10n.errQuantityInvalid;
                  if (!widget.adjust && !q.isPositive) {
                    return l10n.errQuantityInvalid;
                  }
                  return null;
                },
              ),
              if (_needsBatch) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('batchNoField'),
                        controller: _batchNo,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: l10n.fieldBatchNo,
                        ),
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? l10n.errRequired : null,
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
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _note,
                decoration: InputDecoration(
                  labelText: l10n.stockNote,
                  hintText: l10n.stockNoteHint,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('saveStockButton'),
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

/// Shows a snackbar after a stock change.
void stockSaved(BuildContext context) =>
    showSnack(context, AppLocalizations.of(context).stockSaved);
