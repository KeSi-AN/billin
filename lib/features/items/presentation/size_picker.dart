import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// "Which one?" for an item with versions. With colours: the colours first
/// (each with what's left), then that colour's sizes. Sizes only: the
/// sizes straight away. Shows stock (and a version's own price) on each
/// button. Returns the version, or `null` if closed.
Future<ItemSize?> showSizePicker(
  BuildContext context,
  Item item,
  List<ItemSize> sizes, {
  bool showStock = true,
}) => showModalBottomSheet<ItemSize>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) =>
      _VersionPicker(item: item, versions: sizes, showStock: showStock),
);

class _VersionPicker extends StatefulWidget {
  const _VersionPicker({
    required this.item,
    required this.versions,
    required this.showStock,
  });

  final Item item;
  final List<ItemSize> versions;
  final bool showStock;

  @override
  State<_VersionPicker> createState() => _VersionPickerState();
}

class _VersionPickerState extends State<_VersionPicker> {
  /// The colours in the order the versions are listed.
  late final List<String> _colours = [
    for (final v in widget.versions)
      if (v.colour != null) v.colour!,
  ].fold<List<String>>([], (list, c) => list.contains(c) ? list : [...list, c]);

  late String? _colour = _colours.length == 1 ? _colours.single : null;

  Quantity _stockOf(String colour) => widget.versions
      .where((v) => v.colour == colour)
      .fold(Quantity.zero, (t, v) => t + v.stock);

  Color? _swatch(String colour) {
    final hex = widget.versions.firstWhere((v) => v.colour == colour).colourHex;
    return hex == null
        ? null
        : Color(int.parse('ff${hex.substring(1)}', radix: 16));
  }

  Widget _stockText(AppLocalizations l10n, Quantity stock) => Text(
    stock.isPositive ? l10n.sizeInStock(stock.format()) : l10n.sizeSoldOut,
    style: TextStyle(
      fontSize: 12,
      color: stock.isPositive ? null : Theme.of(context).colorScheme.error,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
    final stock = widget.showStock && item.trackStock;
    final hasColours = _colours.isNotEmpty;
    // Sizes to show: all (no colours), or the chosen colour's.
    final sizes = hasColours
        ? [
            for (final v in widget.versions)
              if (v.colour == _colour) v,
          ]
        : widget.versions;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sizePickerTitle(item.name),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (hasColours) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in _colours)
                    ChoiceChip(
                      key: Key('pickColour-$c'),
                      avatar: CircleAvatar(
                        backgroundColor: _swatch(c) ?? Colors.grey,
                        radius: 9,
                      ),
                      label: Text(stock ? '$c · ${_stockOf(c).format()}' : c),
                      selected: _colour == c,
                      onSelected: (_) {
                        // A colour without sizes is the version itself.
                        final only = widget.versions.where(
                          (v) => v.colour == c,
                        );
                        if (only.length == 1 && only.single.size.isEmpty) {
                          Navigator.pop(context, only.single);
                          return;
                        }
                        setState(() => _colour = c);
                      },
                    ),
                ],
              ),
            ],
            if (!hasColours || _colour != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in sizes)
                    OutlinedButton(
                      key: Key('pickSize-${s.label}'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(88, 64),
                      ),
                      onPressed: () => Navigator.pop(context, s),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s.size.isEmpty ? (s.colour ?? '') : s.size,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (stock) _stockText(l10n, s.stock),
                          if (s.price != null && s.price != item.salePrice)
                            Text(
                              s.price!.format(),
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(l10n.pickColourFirst),
            ],
          ],
        ),
      ),
    );
  }
}
