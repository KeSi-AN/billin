import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// `Food › Snacks`, `Food`, or null.
String? categoryLabel(List<Category> all, int? id) {
  if (id == null) return null;
  final c = all.where((c) => c.id == id).firstOrNull;
  if (c == null) return null;
  final parent = all.where((p) => p.id == c.parentId).firstOrNull;
  return parent == null ? c.name : '${parent.name} › ${c.name}';
}

/// Pick (or create) a category. Returns `(id: null)` for "No category" and
/// `null` if dismissed.
Future<({int? id})?> showCategoryPicker(
  BuildContext context, {
  int? selected,
  bool allowNone = true,
  String? noneLabel,
}) => showModalBottomSheet<({int? id})>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (_) => RepositoryProvider.value(
    value: context.read<InventoryRepository>(),
    child: _CategorySheet(
      selected: selected,
      allowNone: allowNone,
      noneLabel: noneLabel,
    ),
  ),
);

class _CategorySheet extends StatelessWidget {
  const _CategorySheet({
    required this.selected,
    required this.allowNone,
    this.noneLabel,
  });

  final int? selected;
  final bool allowNone;
  final String? noneLabel;

  Future<void> _create(BuildContext context, {Category? parent}) async {
    final l10n = AppLocalizations.of(context);
    final inventory = context.read<InventoryRepository>();
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          parent == null ? l10n.categoryNew : l10n.subcategoryNew(parent.name),
        ),
        content: TextField(
          key: const Key('categoryNameField'),
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.categoryName),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(64, 40)),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty) return;
    final created = await inventory.addCategory(name, parentId: parent?.id);
    if (context.mounted) Navigator.pop(context, (id: created.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<Category>>(
      stream: context.read<InventoryRepository>().watchCategories(),
      builder: (context, snapshot) {
        final all = snapshot.data ?? const [];
        final tops = all.where((c) => !c.isSubcategory);
        Widget tile(Category c, {bool indent = false}) => ListTile(
          contentPadding: EdgeInsets.only(left: indent ? 48 : 16, right: 8),
          title: Text(c.name),
          selected: c.id == selected,
          trailing: indent
              ? null
              : IconButton(
                  tooltip: l10n.subcategoryNew(c.name),
                  icon: const Icon(Icons.subdirectory_arrow_right),
                  onPressed: () => _create(context, parent: c),
                ),
          onTap: () => Navigator.pop(context, (id: c.id)),
        );
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l10n.categoryPick,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (allowNone)
              ListTile(
                title: Text(noneLabel ?? l10n.categoryNone),
                selected: selected == null,
                onTap: () => Navigator.pop(context, (id: null)),
              ),
            for (final top in tops) ...[
              tile(top),
              for (final sub in all.where((c) => c.parentId == top.id))
                tile(sub, indent: true),
            ],
            ListTile(
              key: const Key('newCategoryTile'),
              leading: const Icon(Icons.add),
              title: Text(l10n.categoryNew),
              onTap: () => _create(context),
            ),
          ],
        );
      },
    );
  }
}
