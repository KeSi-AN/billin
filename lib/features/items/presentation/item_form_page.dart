import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Add or edit an item. Pops with the saved [Item], so billing can create
/// an item for an unknown barcode and drop it straight into the bill.
class ItemFormPage extends StatefulWidget {
  const ItemFormPage({this.itemId, this.initialBarcode, super.key});

  final int? itemId;
  final String? initialBarcode;

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _barcode = TextEditingController();
  final _price = TextEditingController();
  final _mrp = TextEditingController();
  final _hsn = TextEditingController();
  String _unit = itemUnits.first;
  TaxRate _taxRate = TaxRate.zero;
  bool _priceIncludesTax = true;
  String? _barcodeError;
  Item? _existing;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _barcode.text = widget.initialBarcode ?? '';
    unawaited(_load());
  }

  Future<void> _load() async {
    final id = widget.itemId;
    if (id != null) {
      final item = await context.read<ItemRepository>().byId(id);
      if (item != null) {
        _existing = item;
        _name.text = item.name;
        _barcode.text = item.barcode ?? '';
        _price.text = item.salePrice.toInput();
        _mrp.text = item.mrp?.toInput() ?? '';
        _hsn.text = item.hsn ?? '';
        _unit = item.unit;
        _taxRate = item.taxRate;
        _priceIncludesTax = item.priceIncludesTax;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [_name, _barcode, _price, _mrp, _hsn]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _scan() async {
    final code = await context.push<String>(AppRoutes.scan);
    if (code != null) setState(() => _barcode.text = code);
  }

  Future<void> _save() async {
    setState(() => _barcodeError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final mrp = Money.tryParse(_mrp.text);
    final item = (_existing ?? const Item(name: '', salePrice: Money.zero))
        .copyWith(
          name: _name.text.trim(),
          barcode: _barcode.text.trim(),
          salePrice: Money.tryParse(_price.text)!,
          mrp: _mrp.text.trim().isEmpty ? null : mrp,
          unit: _unit,
          taxRate: _taxRate,
          priceIncludesTax: _priceIncludesTax,
          hsn: _hsn.text.trim(),
        );
    try {
      final saved = await context.read<ItemRepository>().save(item);
      if (!mounted) return;
      showSnack(context, l10n.itemSaved);
      context.pop(saved);
    } on DuplicateBarcodeException catch (e) {
      setState(() {
        _barcodeError = l10n.errDuplicateBarcode(e.existingItemName);
        _saving = false;
      });
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l10n.itemDeleteConfirm(_existing!.name),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.read<ItemRepository>().delete(_existing!.id!);
    if (!mounted) return;
    showSnack(context, l10n.itemDeleted);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemId == null ? l10n.itemNew : l10n.itemEdit),
        actions: [
          if (_existing != null)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    key: const Key('itemNameField'),
                    controller: _name,
                    autofocus: widget.itemId == null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l10n.fieldItemName),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.errRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('itemBarcodeField'),
                    controller: _barcode,
                    decoration: InputDecoration(
                      labelText: l10n.fieldBarcode,
                      helperText: l10n.optional,
                      errorText: _barcodeError,
                      suffixIcon: IconButton(
                        tooltip: l10n.scanBarcode,
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _scan,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: MoneyField(
                          key: const Key('itemPriceField'),
                          controller: _price,
                          label: l10n.fieldSalePrice,
                          isRequired: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: itemUnits.contains(_unit)
                              ? _unit
                              : itemUnits.first,
                          decoration: InputDecoration(
                            labelText: l10n.fieldUnit,
                          ),
                          items: [
                            for (final u in itemUnits)
                              DropdownMenuItem(value: u, child: Text(u)),
                          ],
                          onChanged: (u) => setState(() => _unit = u ?? _unit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MoneyField(
                    controller: _mrp,
                    label: l10n.fieldMrp,
                    helperText: l10n.optional,
                    extraValidator: (mrp) {
                      final price = Money.tryParse(_price.text);
                      return (price != null && mrp < price)
                          ? l10n.errMrpBelowPrice
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TaxRateField(
                    value: _taxRate,
                    onChanged: (r) => setState(() => _taxRate = r),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldPriceIncludesTax),
                    subtitle: Text(l10n.priceIncludesTaxHelp),
                    value: _priceIncludesTax,
                    onChanged: (v) => setState(() => _priceIncludesTax = v),
                  ),
                  TextFormField(
                    controller: _hsn,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.fieldHsn,
                      helperText: l10n.optional,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('saveItemButton'),
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? l10n.saving : l10n.save),
                  ),
                ],
              ),
            ),
    );
  }
}
