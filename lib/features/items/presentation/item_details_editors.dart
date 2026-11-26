import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// One size row being edited on the item screen.
class SizeRow {
  SizeRow({
    this.id,
    String size = '',
    Money? price,
    this.stock = Quantity.zero,
    this.barcode,
  }) : size = TextEditingController(text: size),
       price = TextEditingController(text: price?.toInput() ?? '');

  factory SizeRow.of(ItemSize s) => SizeRow(
    id: s.id,
    size: s.size,
    price: s.price,
    stock: s.stock,
    barcode: s.barcode,
  );

  /// `null`: added now (gets opening stock); else saved before.
  final int? id;
  final TextEditingController size;
  final TextEditingController price;

  /// Opening stock for a new size.
  final opening = TextEditingController();
  final Quantity stock;
  final String? barcode;

  ItemSize toSize() => ItemSize(
    id: id,
    size: size.text.trim(),
    price: price.text.trim().isEmpty ? null : Money.tryParse(price.text),
    barcode: barcode,
  );

  void dispose() {
    size.dispose();
    price.dispose();
    opening.dispose();
  }
}

/// Ready-made size sets, one tap each.
const sizePresets = <String, List<String>>{
  'S – XXL': ['S', 'M', 'L', 'XL', 'XXL'],
  'XS – XXXL': ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
  '28 – 40': ['28', '30', '32', '34', '36', '38', '40'],
};

/// The item's sizes: name, own price (optional) and, for new sizes, the
/// opening stock. No sizes = free size.
class SizesEditor extends StatelessWidget {
  const SizesEditor({
    required this.rows,
    required this.onChanged,
    required this.trackStock,
    required this.unit,
    super.key,
  });

  final List<SizeRow> rows;
  final VoidCallback onChanged;
  final bool trackStock;
  final String unit;

  void _addAll(List<String> sizes) {
    final have = {for (final r in rows) r.size.text.trim().toUpperCase()};
    for (final s in sizes) {
      if (!have.contains(s.toUpperCase())) rows.add(SizeRow(size: s));
    }
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.sizesTitle, style: text.titleSmall),
        Text(
          rows.isEmpty ? l10n.sizesNoneHelp : l10n.sizesHelp,
          style: text.bodySmall,
        ),
        const SizedBox(height: 8),
        for (final (i, r) in rows.indexed)
          Padding(
            key: ObjectKey(r),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    key: Key('sizeName-$i'),
                    controller: r.size,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(labelText: l10n.sizeField),
                    validator: (v) {
                      final name = (v ?? '').trim().toUpperCase();
                      if (name.isEmpty) return l10n.errRequired;
                      final same = rows
                          .where(
                            (o) => o.size.text.trim().toUpperCase() == name,
                          )
                          .length;
                      return same > 1 ? l10n.sizeDuplicate : null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    key: Key('sizePrice-$i'),
                    controller: r.price,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.sizePriceField,
                      prefixText: '₹ ',
                      helperText: l10n.sizePriceHelp,
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty || Money.tryParse(v!) != null
                        ? null
                        : l10n.errAmountInvalid,
                  ),
                ),
                if (trackStock) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 84,
                    child: r.id == null
                        ? TextFormField(
                            key: Key('sizeOpening-$i'),
                            controller: r.opening,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: l10n.sizeStockField,
                              suffixText: unit,
                            ),
                            validator: (v) =>
                                (v ?? '').trim().isEmpty ||
                                    Quantity.tryParse(v!) != null
                                ? null
                                : l10n.errQuantityInvalid,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              l10n.sizeStockNow(r.stock.format(), unit),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ],
                IconButton(
                  key: Key('removeSize-$i'),
                  tooltip: l10n.sizeRemove,
                  padding: const EdgeInsets.only(top: 8),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    rows.removeAt(i);
                    onChanged();
                  },
                ),
              ],
            ),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final e in sizePresets.entries)
              ActionChip(
                key: Key('sizePreset-${e.key}'),
                avatar: const Icon(Icons.add, size: 18),
                label: Text(e.key),
                onPressed: () => _addAll(e.value),
              ),
            ActionChip(
              key: const Key('addSizeButton'),
              avatar: const Icon(Icons.add, size: 18),
              label: Text(l10n.sizeAdd),
              onPressed: () {
                rows.add(SizeRow());
                onChanged();
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Common clothing colours with their swatch codes.
const colourPresets = <ItemColour>[
  ItemColour('Black', '#000000'),
  ItemColour('White', '#ffffff'),
  ItemColour('Off-white', '#f5f0e6'),
  ItemColour('Red', '#c62828'),
  ItemColour('Maroon', '#6d1b1b'),
  ItemColour('Pink', '#e91e63'),
  ItemColour('Peach', '#f4a582'),
  ItemColour('Orange', '#ef6c00'),
  ItemColour('Yellow', '#f9d71c'),
  ItemColour('Mustard', '#d4a017'),
  ItemColour('Green', '#2e7d32'),
  ItemColour('Olive', '#6b7b2c'),
  ItemColour('Teal', '#00796b'),
  ItemColour('Sky blue', '#64b5f6'),
  ItemColour('Blue', '#1565c0'),
  ItemColour('Navy', '#1a237e'),
  ItemColour('Purple', '#6a1b9a'),
  ItemColour('Plum', '#6b3f6e'),
  ItemColour('Lavender', '#b39ddb'),
  ItemColour('Grey', '#9e9e9e'),
  ItemColour('Beige', '#e8d8b0'),
  ItemColour('Brown', '#6d4c41'),
  ItemColour('Gold', '#c9a227'),
  ItemColour('Silver', '#c0c0c0'),
  ItemColour('Multicolour'),
];

/// The colours an item comes in: tap common ones, or type a name.
class ColoursEditor extends StatefulWidget {
  const ColoursEditor({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<ItemColour> value;
  final ValueChanged<List<ItemColour>> onChanged;

  @override
  State<ColoursEditor> createState() => _ColoursEditorState();
}

class _ColoursEditorState extends State<ColoursEditor> {
  final _custom = TextEditingController();

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  bool _has(String name) =>
      widget.value.any((c) => c.name.toLowerCase() == name.toLowerCase());

  void _toggle(ItemColour c) => widget.onChanged(
    _has(c.name)
        ? [
            for (final x in widget.value)
              if (x.name.toLowerCase() != c.name.toLowerCase()) x,
          ]
        : [...widget.value, c],
  );

  void _addCustom() {
    final name = _custom.text.trim();
    if (name.isEmpty || _has(name)) return;
    final preset = colourPresets
        .where((c) => c.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;
    widget.onChanged([...widget.value, preset ?? ItemColour(name)]);
    _custom.clear();
  }

  static Widget _swatch(ItemColour c) => Container(
    width: 18,
    height: 18,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: c.hex == null
          ? null
          : Color(int.parse('ff${c.hex!.substring(1)}', radix: 16)),
      gradient: c.hex == null
          ? const SweepGradient(
              colors: [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.red,
              ],
            )
          : null,
      border: Border.all(color: Colors.black26),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final others = widget.value.where(
      (c) => !colourPresets.any((p) => p.name == c.name),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.coloursTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            for (final c in [...colourPresets, ...others])
              FilterChip(
                key: Key('colour-${c.name}'),
                avatar: _swatch(c),
                label: Text(c.name),
                selected: _has(c.name),
                onSelected: (_) => _toggle(c),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('customColourField'),
          controller: _custom,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.colourOther,
            suffixIcon: IconButton(
              tooltip: l10n.colourAdd,
              icon: const Icon(Icons.add),
              onPressed: _addCustom,
            ),
          ),
          onSubmitted: (_) => _addCustom(),
        ),
      ],
    );
  }
}
