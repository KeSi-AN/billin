import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/presentation/items_page.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Search (or scan into the search box) and pick one item.
Future<Item?> showItemPicker(BuildContext context) =>
    showModalBottomSheet<Item>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => RepositoryProvider.value(
        value: context.read<ItemRepository>(),
        child: const _ItemPicker(),
      ),
    );

class _ItemPicker extends StatefulWidget {
  const _ItemPicker();

  @override
  State<_ItemPicker> createState() => _ItemPickerState();
}

class _ItemPickerState extends State<_ItemPicker> {
  String _query = '';

  Future<void> _submit(String code) async {
    final item = await context.read<ItemRepository>().byBarcode(code);
    if (item != null && mounted) Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                key: const Key('itemPickerSearch'),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.purchaseItemPickerHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
                onSubmitted: _submit,
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Item>>(
                key: ValueKey(_query),
                stream: context.read<ItemRepository>().watchAll(
                  filter: ItemFilter(query: _query),
                ),
                builder: (context, snapshot) => ListView(
                  children: [
                    for (final item in snapshot.data ?? const <Item>[])
                      ItemTile(
                        item: item,
                        showStock: true,
                        onTap: () => Navigator.pop(context, item),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
