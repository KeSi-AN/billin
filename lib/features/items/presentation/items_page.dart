import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Item list with search. Tap to edit, + to add.
class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = context.read<ItemRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addItemButton'),
        onPressed: () => context.push(AppRoutes.newItem),
        icon: const Icon(Icons.add),
        label: Text(l10n.itemAdd),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              key: const Key('itemSearchField'),
              decoration: InputDecoration(
                hintText: l10n.itemsSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Item>>(
              // Keyed by query so a new stream starts when it changes.
              key: ValueKey(_query),
              stream: repo.watchAll(query: _query),
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
                        _query.isEmpty
                            ? l10n.itemsEmpty
                            : l10n.itemsNoMatch(_query),
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
  const ItemTile({required this.item, this.onTap, this.trailing, super.key});

  final Item item;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (item.barcode != null) item.barcode!,
      if (!item.taxRate.isZero) 'GST ${item.taxRate.label}',
    ].join(' · ');
    return ListTile(
      onTap: onTap,
      title: Text(item.name),
      subtitle: details.isEmpty ? null : Text(details),
      trailing:
          trailing ??
          Text(
            '${item.salePrice.format()}/${item.unit}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
    );
  }
}
