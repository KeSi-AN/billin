import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/inventory/presentation/category_picker.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Item list with search, stock filters, category and sort.
class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  ItemFilter _filter = const ItemFilter();

  Future<void> _pickCategory() async {
    final l10n = AppLocalizations.of(context);
    final picked = await showCategoryPicker(
      context,
      selected: _filter.categoryId,
      noneLabel: l10n.categoryAll,
    );
    if (picked != null) {
      setState(() => _filter = _filter.copyWith(categoryId: () => picked.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = context.read<ItemRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itemsTitle),
        actions: [
          IconButton(
            key: const Key('labelsButton'),
            tooltip: l10n.labelsTitle,
            icon: const Icon(Icons.qr_code_2),
            onPressed: () => context.push(AppRoutes.labels),
          ),
          IconButton(
            key: const Key('importExportButton'),
            tooltip: l10n.importExportTitle,
            icon: const Icon(Icons.import_export),
            onPressed: () => context.push(AppRoutes.importExport),
          ),
          PopupMenuButton<ItemSort>(
            tooltip: l10n.sortBy,
            icon: const Icon(Icons.sort),
            initialValue: _filter.sort,
            onSelected: (s) =>
                setState(() => _filter = _filter.copyWith(sort: s)),
            itemBuilder: (context) => [
              PopupMenuItem(value: ItemSort.name, child: Text(l10n.sortName)),
              PopupMenuItem(
                value: ItemSort.stockLowFirst,
                child: Text(l10n.sortStock),
              ),
              PopupMenuItem(
                value: ItemSort.priceHighFirst,
                child: Text(l10n.sortPrice),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addItemButton'),
        onPressed: () => context.push(AppRoutes.newItem),
        icon: const Icon(Icons.add),
        label: Text(l10n.itemAdd),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              key: const Key('itemSearchField'),
              decoration: InputDecoration(
                hintText: l10n.itemsSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) =>
                  setState(() => _filter = _filter.copyWith(query: v)),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final (filter, label) in [
                  (StockFilter.all, l10n.filterAll),
                  (StockFilter.low, l10n.filterLow),
                  (StockFilter.out, l10n.filterOut),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _filter.stock == filter,
                      onSelected: (_) => setState(
                        () => _filter = _filter.copyWith(stock: filter),
                      ),
                    ),
                  ),
                StreamBuilder<List<Category>>(
                  stream: context.read<InventoryRepository>().watchCategories(),
                  builder: (context, snapshot) => InputChip(
                    avatar: const Icon(Icons.folder_outlined, size: 18),
                    label: Text(
                      categoryLabel(
                            snapshot.data ?? const [],
                            _filter.categoryId,
                          ) ??
                          l10n.categoryAll,
                    ),
                    selected: _filter.categoryId != null,
                    onPressed: _pickCategory,
                    onDeleted: _filter.categoryId == null
                        ? null
                        : () => setState(
                            () => _filter = _filter.copyWith(
                              categoryId: () => null,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Item>>(
              key: ValueKey(_filter),
              stream: repo.watchAll(filter: _filter),
              builder: (context, snapshot) {
                final items = snapshot.data;
                if (items == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        _filter == const ItemFilter()
                            ? l10n.itemsEmpty
                            : l10n.itemsNoMatch(_filter.query),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => ItemTile(
                    item: items[i],
                    showStock: true,
                    onTap: () => context.push(AppRoutes.editItem(items[i].id!)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.item,
    this.onTap,
    this.trailing,
    this.showStock = false,
    super.key,
  });

  final Item item;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showStock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final details = [
      if (item.barcode != null) item.barcode!,
      if (!item.taxRate.isZero) 'GST ${item.taxRate.label}',
    ].join(' · ');
    final image = item.imagePath == null ? null : File(item.imagePath!);
    Widget? stock;
    if (showStock && item.trackStock) {
      final color = item.isOutOfStock
          ? scheme.error
          : (item.isLowStock ? scheme.tertiary : scheme.onSurfaceVariant);
      stock = Text(
        item.isOutOfStock
            ? l10n.stockOut
            : (item.isLowStock
                  ? l10n.stockLowTag(item.stock.format(), item.unit)
                  : l10n.stockLabel(item.stock.format(), item.unit)),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
      );
    }
    return ListTile(
      onTap: onTap,
      leading: image != null && image.existsSync()
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            )
          : null,
      title: Text(item.name),
      subtitle: details.isEmpty && stock == null
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [if (details.isNotEmpty) Text(details), ?stock],
            ),
      trailing:
          trailing ??
          Text(
            '${item.salePrice.format()}/${item.unit}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
    );
  }
}
