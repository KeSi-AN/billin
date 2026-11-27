import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// One cell of the versions grid (a colour and a size) being edited.
class VersionCell {
  VersionCell({this.id, this.stock = Quantity.zero, this.price, this.barcode});

  /// `null`: added now (its opening stock is typed in [opening]).
  final int? id;
  final Quantity stock;
  Money? price;
  final String? barcode;
  final opening = TextEditingController();

  void dispose() => opening.dispose();
}

/// The versions of a product being edited: its colours (rows) × sizes
/// (columns). No colours and no sizes: free size, no versions.
class VersionsDraft {
  VersionsDraft();

  /// From the product's colours and its saved versions.
  factory VersionsDraft.of(List<ItemColour> colours, List<ItemSize> versions) {
    final d = VersionsDraft()..colours = [...colours];
    for (final v in versions) {
      final c = v.colour;
      if (c != null &&
          !d.colours.any((x) => x.name.toLowerCase() == c.toLowerCase())) {
        d.colours.add(ItemColour(c, v.colourHex));
      }
      if (v.size.isNotEmpty &&
          !d.sizes.any((x) => x.toLowerCase() == v.size.toLowerCase())) {
        d.sizes.add(v.size);
      }
      d.cells[key(c, v.size)] = VersionCell(
        id: v.id,
        stock: v.stock,
        price: v.price,
        barcode: v.barcode,
      );
    }
    return d;
  }

  List<ItemColour> colours = [];
  final sizes = <String>[];
  final cells = <String, VersionCell>{};

  static String key(String? colour, String size) =>
      '${(colour ?? '').toLowerCase()}|${size.toLowerCase()}';

  bool get isEmpty => colours.isEmpty && sizes.isEmpty;

  /// Grid rows: the colours, or one row without a colour.
  List<ItemColour?> get rows => colours.isEmpty ? const [null] : colours;

  /// Grid columns: the sizes, or one column without a size.
  List<String> get columns => sizes.isEmpty ? const [''] : sizes;

  VersionCell cell(ItemColour? colour, String size) =>
      cells.putIfAbsent(key(colour?.name, size), VersionCell.new);

  /// The versions in grid order (row by row), for saving.
  List<ItemSize> toVersions() => [
    if (!isEmpty)
      for (final c in rows)
        for (final s in columns)
          ItemSize(
            id: cell(c, s).id,
            colour: c?.name,
            colourHex: c?.hex,
            size: s,
            price: cell(c, s).price,
            barcode: cell(c, s).barcode,
          ),
  ];

  /// New versions with opening stock typed in: (colour, size, quantity).
  Iterable<(String?, String, Quantity)> get openingStock sync* {
    if (isEmpty) return;
    for (final c in rows) {
      for (final s in columns) {
        final cell = this.cell(c, s);
        final q = Quantity.tryParse(cell.opening.text);
        if (cell.id == null && q != null && q.isPositive) yield (c?.name, s, q);
      }
    }
  }

  void dispose() {
    for (final c in cells.values) {
      c.dispose();
    }
  }
}

/// Ready-made size sets, one tap each.
const sizePresets = <String, List<String>>{
  'S – XXL': ['S', 'M', 'L', 'XL', 'XXL'],
  'XS – XXXL': ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
  '28 – 40': ['28', '30', '32', '34', '36', '38', '40'],
};

Color? swatchColour(String? hex) =>
    hex == null ? null : Color(int.parse('ff${hex.substring(1)}', radix: 16));

/// Colours (tap the common ones) and sizes (presets or typed), then a grid
/// of every colour × size: its opening stock (new versions) or stock, and
/// its own price if it differs. Tap a size or colour heading to price the
/// whole column or row at once.
class VersionsEditor extends StatefulWidget {
  const VersionsEditor({
    required this.draft,
    required this.onChanged,
    required this.trackStock,
    required this.unit,
    required this.itemPrice,
    this.unplacedStock = Quantity.zero,
    super.key,
  });

  final VersionsDraft draft;
  final VoidCallback onChanged;
  final bool trackStock;
  final String unit;

  /// The product's price, shown where a version has none of its own.
  final Money? itemPrice;

  /// Stock of an existing item not in any version yet.
  final Quantity unplacedStock;

  @override
  State<VersionsEditor> createState() => _VersionsEditorState();
}

class _VersionsEditorState extends State<VersionsEditor> {
  final _newSize = TextEditingController();

  VersionsDraft get _d => widget.draft;

  @override
  void dispose() {
    _newSize.dispose();
    super.dispose();
  }

  void _addSizes(Iterable<String> sizes) {
    for (final s in sizes) {
      final clean = s.trim().toUpperCase();
      if (clean.isEmpty) continue;
      if (!_d.sizes.any((x) => x.toLowerCase() == clean.toLowerCase())) {
        _d.sizes.add(clean);
      }
    }
    widget.onChanged();
  }

  void _addTyped() {
    _addSizes(_newSize.text.split(RegExp(r'[,\s]+')));
    _newSize.clear();
  }

  /// Asks for a price and gives it to [cells] (empty: back to the
  /// product's price).
  Future<void> _price(String title, List<VersionCell> cells) async {
    final current = cells.map((c) => c.price).toSet();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _PriceDialog(
        title: title,
        initial: current.length == 1 ? (current.single?.toInput() ?? '') : '',
      ),
    );
    if (result == null) return;
    final price = result.trim().isEmpty ? null : Money.tryParse(result);
    if (result.trim().isNotEmpty && price == null) return;
    for (final c in cells) {
      c.price = price;
    }
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.versionsTitle, style: text.titleSmall),
        Text(
          _d.isEmpty ? l10n.versionsNoneHelp : l10n.versionsHelp,
          style: text.bodySmall,
        ),
        const SizedBox(height: 12),
        ColoursEditor(
          value: _d.colours,
          onChanged: (c) {
            _d.colours = c;
            widget.onChanged();
          },
        ),
        const SizedBox(height: 16),
        Text(l10n.sizesTitle, style: text.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            for (final s in _d.sizes)
              InputChip(
                key: Key('sizeChip-$s'),
                label: Text(s),
                onDeleted: () {
                  _d.sizes.remove(s);
                  widget.onChanged();
                },
              ),
            for (final e in sizePresets.entries)
              ActionChip(
                key: Key('sizePreset-${e.key}'),
                avatar: const Icon(Icons.add, size: 18),
                label: Text(e.key),
                onPressed: () => _addSizes(e.value),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('newSizeField'),
          controller: _newSize,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: l10n.sizeAdd,
            hintText: l10n.sizeAddHint,
            suffixIcon: IconButton(
              key: const Key('addSizeButton'),
              tooltip: l10n.sizeAdd,
              icon: const Icon(Icons.add),
              onPressed: _addTyped,
            ),
          ),
          onSubmitted: (_) => _addTyped(),
        ),
        if (!_d.isEmpty) ...[
          const SizedBox(height: 16),
          Text(
            widget.trackStock ? l10n.versionsGridStock : l10n.versionsGridPrice,
            style: text.bodySmall,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(78),
              columnWidths: const {0: FixedColumnWidth(104)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Heading: tap a size to price the whole column.
                TableRow(
                  children: [
                    const SizedBox.shrink(),
                    for (final s in _d.columns)
                      TextButton(
                        key: Key('sizeHeading-$s'),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 40),
                        ),
                        onPressed: () => _price(
                          l10n.versionPriceFor(s.isEmpty ? l10n.versionAll : s),
                          [for (final c in _d.rows) _d.cell(c, s)],
                        ),
                        child: Text(s.isEmpty ? '—' : s),
                      ),
                  ],
                ),
                for (final c in _d.rows)
                  TableRow(
                    children: [
                      // Tap a colour to price the whole row.
                      InkWell(
                        key: Key('colourHeading-${c?.name ?? ''}'),
                        onTap: () => _price(
                          l10n.versionPriceFor(c?.name ?? l10n.versionAll),
                          [for (final s in _d.columns) _d.cell(c, s)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              if (c != null) ...[
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor:
                                      swatchColour(c.hex) ?? Colors.grey,
                                ),
                                const SizedBox(width: 6),
                              ],
                              Expanded(
                                child: Text(
                                  c?.name ?? '—',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      for (final s in _d.columns) _cell(context, c, s, scheme),
                    ],
                  ),
              ],
            ),
          ),
          if (widget.unplacedStock.isPositive)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.versionsUnplaced(
                  widget.unplacedStock.format(),
                  widget.unit,
                ),
                style: text.bodySmall?.copyWith(color: scheme.error),
              ),
            ),
        ],
      ],
    );
  }

  Widget _cell(
    BuildContext context,
    ItemColour? c,
    String s,
    ColorScheme scheme,
  ) {
    final l10n = AppLocalizations.of(context);
    final cell = _d.cell(c, s);
    final name = [?c?.name, if (s.isNotEmpty) s].join(' · ');
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.trackStock)
            if (cell.id == null)
              TextField(
                key: Key('versionStock-$name'),
                controller: cell.opening,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(isDense: true, hintText: '0'),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  cell.stock.format(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cell.stock.isPositive ? null : scheme.error,
                  ),
                ),
              ),
          InkWell(
            key: Key('versionPrice-$name'),
            onTap: () => _price(l10n.versionPriceFor(name), [cell]),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                (cell.price ?? widget.itemPrice)?.format() ?? '₹ —',
                style: TextStyle(
                  fontSize: 11,
                  color: cell.price == null ? scheme.outline : scheme.primary,
                  fontWeight: cell.price == null ? null : FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
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

/// Asks for a version price; pops the typed text ('' = the item's price).
/// Owns its text box, so it isn't thrown away while the dialog closes.
class _PriceDialog extends StatefulWidget {
  const _PriceDialog({required this.title, required this.initial});

  final String title;
  final String initial;

  @override
  State<_PriceDialog> createState() => _PriceDialogState();
}

class _PriceDialogState extends State<_PriceDialog> {
  late final _ctrl = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        key: const Key('versionPriceField'),
        controller: _ctrl,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
        decoration: InputDecoration(
          prefixText: '₹ ',
          helperText: l10n.versionPriceHelp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('versionPriceSave'),
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
