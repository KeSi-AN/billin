import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// "Which size?" for a sized item: one button per size with what's in
/// stock (and its price when it differs). Returns the size, or `null` if
/// closed.
Future<ItemSize?> showSizePicker(
  BuildContext context,
  Item item,
  List<ItemSize> sizes, {
  bool showStock = true,
}) => showModalBottomSheet<ItemSize>(
  context: context,
  showDragHandle: true,
  builder: (context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
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
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in sizes)
                  OutlinedButton(
                    key: Key('pickSize-${s.size}'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(88, 64),
                    ),
                    onPressed: () => Navigator.pop(context, s),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.size,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (showStock && item.trackStock)
                          Text(
                            s.stock.isPositive
                                ? l10n.sizeInStock(s.stock.format())
                                : l10n.sizeSoldOut,
                            style: TextStyle(
                              fontSize: 12,
                              color: s.stock.isPositive ? null : scheme.error,
                            ),
                          ),
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
          ],
        ),
      ),
    );
  },
);
