import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/inventory/presentation/category_picker.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/shop_profile/presentation/pages/shop_setup_page.dart'
    show PickImage;
import 'package:shop_app/l10n/gen/app_localizations.dart';

Future<String?> _pickPhoto(ImageSource source) async {
  final file = await ImagePicker().pickImage(
    source: source,
    maxWidth: 800,
    maxHeight: 800,
    imageQuality: 80,
  );
  return file?.path;
}

/// Add or edit an item. Pops with the saved [Item], so billing can create
/// an item for an unknown barcode and drop it straight into the bill.
class ItemFormPage extends StatefulWidget {
  const ItemFormPage({
    this.itemId,
    this.initialBarcode,
    this.pickImage = _pickPhoto,
    super.key,
  });

  final int? itemId;
  final String? initialBarcode;
  final PickImage pickImage;

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scroll = ScrollController();
  final _name = TextEditingController();
  final _barcode = TextEditingController();
  final _price = TextEditingController();
  final _mrp = TextEditingController();
  final _hsn = TextEditingController();
  final _opening = TextEditingController();
  final _openingBatch = TextEditingController();
  final _lowStock = TextEditingController();
  final _altFactor = TextEditingController();
  final _altPrice = TextEditingController();
  String _unit = itemUnits.first;
  String? _altUnit;
  DateTime? _openingExpiry;
  TaxRate _taxRate = TaxRate.zero;
  bool _priceIncludesTax = true;
  bool _trackStock = false;
  bool _tracksBatches = false;
  int? _categoryId;
  String? _imagePath;
  String? _barcodeError;
  Item? _existing;
  bool _loading = true;
  bool _saving = false;

  bool get _isNew => widget.itemId == null;

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
        _trackStock = item.trackStock;
        _tracksBatches = item.tracksBatches;
        _lowStock.text = item.lowStock?.format() ?? '';
        _categoryId = item.categoryId;
        _imagePath = item.imagePath;
        if (item.hasAltUnit) {
          _altUnit = item.altUnit;
          _altFactor.text = item.altUnitFactor!.format();
          _altPrice.text = item.altUnitPrice?.toInput() ?? '';
        }
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _scroll.dispose();
    for (final c in [
      _name,
      _barcode,
      _price,
      _mrp,
      _hsn,
      _opening,
      _openingBatch,
      _lowStock,
      _altFactor,
      _altPrice,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _scan() async {
    final code = await context.push<String>(AppRoutes.scan);
    if (code != null) setState(() => _barcode.text = code);
  }

  Future<void> _pickCategory() async {
    final picked = await showCategoryPicker(context, selected: _categoryId);
    if (picked != null) setState(() => _categoryId = picked.id);
  }

  Future<void> _photo() async {
    final l10n = AppLocalizations.of(context);
    final repo = context.read<ItemRepository>();
    final choice = await showModalBottomSheet<Object>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.logoFromCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.logoFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.itemPhotoRemove),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (choice == 'remove') {
      setState(() => _imagePath = null);
    } else if (choice is ImageSource) {
      final picked = await widget.pickImage(choice);
      if (picked != null) {
        final stored = await repo.importImage(picked);
        if (mounted) setState(() => _imagePath = stored);
      }
    }
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _openingExpiry ?? DateTime(now.year, now.month + 6),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 15),
    );
    if (picked != null) setState(() => _openingExpiry = picked);
  }

  Future<void> _save() async {
    setState(() => _barcodeError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final items = context.read<ItemRepository>();
    final inventory = context.read<InventoryRepository>();
    final altFactor = Quantity.tryParse(_altFactor.text);
    final hasAlt =
        _altUnit != null && altFactor != null && altFactor.isPositive;
    final item = (_existing ?? const Item(name: '', salePrice: Money.zero))
        .copyWith(
          name: _name.text.trim(),
          barcode: _barcode.text.trim(),
          salePrice: Money.tryParse(_price.text)!,
          mrp: _mrp.text.trim().isEmpty ? null : Money.tryParse(_mrp.text),
          unit: _unit,
          taxRate: _taxRate,
          priceIncludesTax: _priceIncludesTax,
          hsn: _hsn.text.trim(),
          trackStock: _trackStock,
          tracksBatches: _trackStock && _tracksBatches,
          lowStock: _trackStock ? Quantity.tryParse(_lowStock.text) : null,
          categoryId: _categoryId,
          imagePath: _imagePath,
          altUnit: hasAlt ? _altUnit : null,
          altUnitFactor: hasAlt ? altFactor : null,
          altUnitPrice: hasAlt ? Money.tryParse(_altPrice.text) : null,
        );
    try {
      final saved = await items.save(item);
      final opening = Quantity.tryParse(_opening.text);
      if (_isNew && saved.trackStock && opening != null && opening.isPositive) {
        await inventory.addStock(
          saved.id!,
          opening,
          opening: true,
          batchNo: _openingBatch.text,
          expiry: _openingExpiry,
        );
      }
      if (!mounted) return;
      showSnack(context, l10n.itemSaved);
      context.pop(await items.byId(saved.id!));
    } on DuplicateBarcodeException catch (e) {
      if (!mounted) return;
      final message = l10n.errDuplicateBarcode(e.existingItemName);
      setState(() {
        _barcodeError = message;
        _saving = false;
      });
      // Save is at the bottom; scroll up to the field showing the error.
      // (No snackbar: it would sit over the Save button.)
      await _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
    final text = Theme.of(context).textTheme;
    const gap = SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.itemNew : l10n.itemEdit),
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
                key: const Key('itemForm'),
                controller: _scroll,
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PhotoButton(path: _imagePath, onTap: _photo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          key: const Key('itemNameField'),
                          controller: _name,
                          autofocus: _isNew,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: l10n.fieldItemName,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.errRequired
                              : null,
                        ),
                      ),
                    ],
                  ),
                  gap,
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
                  gap,
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
                  gap,
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
                  gap,
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
                  gap,
                  StreamBuilder<List<Category>>(
                    stream: context
                        .read<InventoryRepository>()
                        .watchCategories(),
                    builder: (context, snapshot) => ListTile(
                      key: const Key('itemCategoryTile'),
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(l10n.sectionCategory),
                      subtitle: Text(
                        categoryLabel(snapshot.data ?? const [], _categoryId) ??
                            l10n.categoryNone,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _pickCategory,
                    ),
                  ),
                  const Divider(height: 32),

                  // Stock.
                  Text(l10n.sectionStock, style: text.titleMedium),
                  SwitchListTile(
                    key: const Key('trackStockSwitch'),
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldTrackStock),
                    subtitle: Text(l10n.trackStockHelp),
                    value: _trackStock,
                    onChanged: (v) => setState(() => _trackStock = v),
                  ),
                  if (_trackStock) ...[
                    if (_existing != null && _existing!.trackStock)
                      ListTile(
                        key: const Key('manageStockTile'),
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.inventory_outlined),
                        title: Text(
                          l10n.stockLabel(
                            _existing!.stock.format(),
                            _existing!.unit,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push(AppRoutes.itemStock(_existing!.id!)),
                      ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.fieldTracksBatches),
                      subtitle: Text(l10n.tracksBatchesHelp),
                      value: _tracksBatches,
                      onChanged: (v) => setState(() => _tracksBatches = v),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isNew) ...[
                          Expanded(
                            child: TextFormField(
                              key: const Key('openingStockField'),
                              controller: _opening,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l10n.fieldOpeningStock,
                                suffixText: _unit,
                              ),
                              validator: (v) =>
                                  (v ?? '').trim().isEmpty ||
                                      Quantity.tryParse(v!) != null
                                  ? null
                                  : l10n.errQuantityInvalid,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: TextFormField(
                            key: const Key('lowStockField'),
                            controller: _lowStock,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: l10n.fieldLowStock,
                              helperText: l10n.optional,
                              suffixText: _unit,
                            ),
                            validator: (v) =>
                                (v ?? '').trim().isEmpty ||
                                    Quantity.tryParse(v!) != null
                                ? null
                                : l10n.errQuantityInvalid,
                          ),
                        ),
                      ],
                    ),
                    if (_isNew && _tracksBatches) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _openingBatch,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                labelText: l10n.fieldBatchNo,
                              ),
                              validator: (v) {
                                final opening = Quantity.tryParse(
                                  _opening.text,
                                );
                                final needed =
                                    opening != null && opening.isPositive;
                                return needed && (v ?? '').trim().isEmpty
                                    ? l10n.errRequired
                                    : null;
                              },
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
                                _openingExpiry == null
                                    ? l10n.fieldExpiry
                                    : formatDate(_openingExpiry!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                  const Divider(height: 32),

                  // Second unit.
                  Text(l10n.sectionSecondUnit, style: text.titleMedium),
                  Text(l10n.secondUnitHelp, style: text.bodySmall),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          key: const Key('altUnitField'),
                          isExpanded: true,
                          initialValue: _altUnit,
                          decoration: InputDecoration(
                            labelText: l10n.fieldAltUnit,
                          ),
                          items: [
                            const DropdownMenuItem(child: Text('—')),
                            for (final u in itemUnits)
                              DropdownMenuItem(value: u, child: Text(u)),
                          ],
                          onChanged: (u) => setState(() => _altUnit = u),
                          validator: (u) => u != null && u == _unit
                              ? l10n.errAltUnitSame
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          key: const Key('altFactorField'),
                          controller: _altFactor,
                          enabled: _altUnit != null,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.fieldAltUnitFactor(_unit),
                          ),
                          validator: (v) {
                            if (_altUnit == null) return null;
                            final q = Quantity.tryParse(v ?? '');
                            return q == null || !q.isPositive
                                ? l10n.errAltUnitIncomplete
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_altUnit != null) ...[
                    const SizedBox(height: 12),
                    MoneyField(
                      key: const Key('altPriceField'),
                      controller: _altPrice,
                      label: l10n.fieldAltUnitPrice(_altUnit!),
                      isRequired: true,
                    ),
                  ],
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

class _PhotoButton extends StatelessWidget {
  const _PhotoButton({required this.path, required this.onTap});

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final file = path == null ? null : File(path!);
    final hasImage = file != null && file.existsSync();
    return Tooltip(
      message: hasImage ? l10n.itemPhoto : l10n.itemPhotoAdd,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: scheme.surfaceContainerHighest,
            image: hasImage
                ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                : null,
          ),
          child: hasImage
              ? null
              : Icon(
                  Icons.add_a_photo_outlined,
                  color: scheme.onSurfaceVariant,
                ),
        ),
      ),
    );
  }
}
