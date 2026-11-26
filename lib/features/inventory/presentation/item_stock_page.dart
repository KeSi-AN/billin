import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/inventory/presentation/stock_sheets.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/presentation/size_picker.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// One item's stock: current level, batches, and every change.
class ItemStockPage extends StatelessWidget {
  const ItemStockPage({required this.itemId, super.key});

  final int itemId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventory = context.read<InventoryRepository>();
    // Re-read the item whenever its history changes (stock is cached there).
    return StreamBuilder<List<StockMovement>>(
      stream: inventory.watchMovements(itemId),
      builder: (context, history) => FutureBuilder<Item?>(
        key: ValueKey(history.data?.length),
        future: context.read<ItemRepository>().byId(itemId),
        builder: (context, snapshot) {
          final item = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(item == null ? '' : l10n.itemStockTitle(item.name)),
            ),
            body: item == null
                ? const Center(child: CircularProgressIndicator())
                : _Body(item: item, history: history.data ?? const []),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.item, required this.history});

  final Item item;
  final List<StockMovement> history;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final stockColor = item.isOutOfStock
        ? scheme.error
        : (item.isLowStock ? scheme.tertiary : null);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.sectionStock, style: text.labelLarge),
                Text(
                  '${item.stock.format()} ${item.unit}',
                  key: const Key('currentStock'),
                  style: text.headlineMedium?.copyWith(color: stockColor),
                ),
                if (item.lowStock != null)
                  Text(l10n.stockLowLevel(item.lowStock!.format())),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        key: const Key('addStockButton'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                        onPressed: () async {
                          final (sized, size) = await _whichSize(context, item);
                          if (sized && size == null) return;
                          if (!context.mounted) return;
                          if (await showAddStockSheet(
                                context,
                                item,
                                size: size,
                              ) &&
                              context.mounted) {
                            stockSaved(context);
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: Text(l10n.stockAdd),
                      ),
                    ),
                    if (!item.tracksBatches) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('adjustStockButton'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                          onPressed: () async {
                            final (sized, size) = await _whichSize(
                              context,
                              item,
                            );
                            if (sized && size == null) return;
                            if (!context.mounted) return;
                            if (await showAdjustStockSheet(
                                  context,
                                  item,
                                  size: size,
                                ) &&
                                context.mounted) {
                              stockSaved(context);
                            }
                          },
                          icon: const Icon(Icons.tune),
                          label: Text(l10n.stockAdjust),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<List<ItemSize>>(
          stream: context.read<ItemRepository>().watchSizes(item.id!),
          builder: (context, snapshot) {
            final sizes = snapshot.data ?? const <ItemSize>[];
            if (sizes.isEmpty) return const SizedBox.shrink();
            return Column(
              key: const Key('sizeStockList'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(l10n.sizesTitle, style: text.titleMedium),
                for (final s in sizes)
                  ListTile(
                    key: Key('sizeStock-${s.size}'),
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.size),
                    subtitle: s.barcode == null ? null : Text(s.barcode!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${s.stock.format()} ${item.unit}',
                          style: text.titleMedium?.copyWith(
                            color: s.stock.isPositive ? null : scheme.error,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.stockAdd,
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () async {
                            if (await showAddStockSheet(
                                  context,
                                  item,
                                  size: s,
                                ) &&
                                context.mounted) {
                              stockSaved(context);
                            }
                          },
                        ),
                        IconButton(
                          tooltip: l10n.stockAdjust,
                          icon: const Icon(Icons.tune),
                          onPressed: () async {
                            if (await showAdjustStockSheet(
                                  context,
                                  item,
                                  size: s,
                                ) &&
                                context.mounted) {
                              stockSaved(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        if (item.tracksBatches) ...[
          const SizedBox(height: 16),
          Text(l10n.stockBatches, style: text.titleMedium),
          StreamBuilder<List<StockBatch>>(
            stream: context.read<InventoryRepository>().watchBatches(item.id!),
            builder: (context, snapshot) {
              final now = DateTime.now();
              return Column(
                children: [
                  for (final b in snapshot.data ?? const <StockBatch>[])
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(b.batchNo),
                      subtitle: Text(
                        b.expiry == null
                            ? l10n.noExpiry
                            : (b.isExpiredOn(now)
                                  ? l10n.expiredOn(formatDate(b.expiry!))
                                  : l10n.expiresOn(formatDate(b.expiry!))),
                        style: b.isExpiredOn(now)
                            ? TextStyle(color: scheme.error)
                            : null,
                      ),
                      trailing: Text('${b.quantity.format()} ${item.unit}'),
                      onTap: () async {
                        if (await showAdjustStockSheet(
                              context,
                              item,
                              batch: b,
                            ) &&
                            context.mounted) {
                          stockSaved(context);
                        }
                      },
                    ),
                ],
              );
            },
          ),
        ],
        const SizedBox(height: 16),
        Text(l10n.stockHistory, style: text.titleMedium),
        if (history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text(l10n.stockNoHistory)),
          ),
        for (final m in history) _MovementTile(movement: m, unit: item.unit),
      ],
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement, required this.unit});

  final StockMovement movement;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final m = movement;
    final invoice = m.invoiceNo ?? '';
    final title = switch (m.type) {
      MovementType.opening => l10n.movementOpening,
      MovementType.stockIn => l10n.movementStockIn,
      MovementType.sale => l10n.movementSale(invoice),
      MovementType.cancel => l10n.movementCancel(invoice),
      MovementType.adjust => l10n.movementAdjust,
      MovementType.purchase => l10n.movementPurchase,
      MovementType.salesReturn => l10n.movementReturn(invoice),
    };
    final sub = [
      DateFormat('d MMM, h:mm a', appLocale).format(m.at),
      if (m.batchNo != null) m.batchNo!,
      if (m.note != null) m.note!,
      l10n.balanceAfter(m.balanceAfter.format()),
    ].join(' · ');
    final positive = m.quantity.isPositive;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(sub),
      trailing: Text(
        '${positive ? '+' : ''}${m.quantity.format()} $unit',
        style: TextStyle(
          color: positive ? scheme.primary : scheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// For a sized item, which size: `(true, size)`, or `(true, null)` when
/// the picker was closed. `(false, null)` for a free-size item.
Future<(bool, ItemSize?)> _whichSize(BuildContext context, Item item) async {
  final sizes = await context.read<ItemRepository>().sizesOf(item.id!);
  if (sizes.isEmpty || !context.mounted) return (false, null);
  return (true, await showSizePicker(context, item, sizes));
}
