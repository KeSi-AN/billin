import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/domain/ean.dart';
import 'package:shop_app/features/printing/domain/label_formatter.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Pick items and copies, then print barcode labels on the receipt printer.
class LabelsPage extends StatefulWidget {
  const LabelsPage({super.key});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  final _copies = <int, int>{};
  final _items = <int, Item>{};
  String _query = '';
  bool _showPrice = true;
  bool _showShop = true;
  bool _printing = false;

  int get _total => _copies.values.fold(0, (a, b) => a + b);

  /// Changes copies by [delta], reading the current count at tap time so
  /// quick repeated taps all count.
  void _change(Item item, int delta) => setState(() {
    _items[item.id!] = item;
    final copies = (_copies[item.id] ?? 0) + delta;
    if (copies <= 0) {
      _copies.remove(item.id);
    } else {
      _copies[item.id!] = copies;
    }
  });

  Future<void> _createBarcode(Item item) async {
    final l10n = AppLocalizations.of(context);
    final code = Ean.inStore(item.id!);
    final saved = await context.read<ItemRepository>().save(
      item.copyWith(barcode: code),
    );
    if (!mounted) return;
    setState(() => _items[saved.id!] = saved);
    showSnack(context, l10n.labelsBarcodeCreated(code, item.name));
  }

  Future<void> _print() async {
    final l10n = AppLocalizations.of(context);
    final router = GoRouter.of(context);
    setState(() => _printing = true);
    final settings = await context.read<SettingsRepository>().load();
    if (!mounted) return;
    final shop = await context.read<ShopProfileRepository>().load();
    if (!mounted) return;
    final requests = [
      for (final e in _copies.entries) (item: _items[e.key]!, copies: e.value),
    ];
    final bytes = LabelFormatter(width: settings.paperWidth.charsPerLine).bytes(
      requests,
      LabelOptions(
        showPrice: _showPrice,
        shopName: _showShop ? shop?.name : null,
      ),
    );
    try {
      await context.read<PrinterService>().printBytes(bytes);
      if (mounted) showSnack(context, l10n.printed);
    } on PrintException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              persist: false,
              content: Text(
                e.error == PrintError.notConfigured
                    ? l10n.printErrNotConfigured
                    : l10n.printErrFailed,
              ),
              action: SnackBarAction(
                label: l10n.setUpPrinter,
                onPressed: () => router.push(AppRoutes.printerSettings),
              ),
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.labelsTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.itemsSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  dense: true,
                  title: Text(l10n.labelsShowPrice),
                  value: _showPrice,
                  onChanged: (v) => setState(() => _showPrice = v ?? true),
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  dense: true,
                  title: Text(l10n.labelsShowShop),
                  value: _showShop,
                  onChanged: (v) => setState(() => _showShop = v ?? true),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Item>>(
              key: ValueKey(_query),
              stream: context.read<ItemRepository>().watchAll(
                filter: ItemFilter(query: _query),
              ),
              builder: (context, snapshot) {
                final items = snapshot.data;
                if (items == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = _items[items[i].id] ?? items[i];
                    final copies = _copies[item.id] ?? 0;
                    return ListTile(
                      title: Text(item.name),
                      subtitle: item.barcode == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () => _createBarcode(item),
                                icon: const Icon(Icons.add, size: 18),
                                label: Text(l10n.labelsCreateBarcode),
                              ),
                            )
                          : Text(item.barcode!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: copies == 0
                                ? null
                                : () => _change(item, -1),
                          ),
                          SizedBox(
                            width: 28,
                            child: Text('$copies', textAlign: TextAlign.center),
                          ),
                          IconButton(
                            key: Key('labelPlus-${item.id}'),
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _change(item, 1),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // In the bottom bar slot, so snackbars appear above it, not over it.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            key: const Key('printLabelsButton'),
            onPressed: _total == 0 || _printing ? null : _print,
            icon: const Icon(Icons.print_outlined),
            label: Text(_printing ? l10n.printing : l10n.labelsPrint(_total)),
          ),
        ),
      ),
    );
  }
}
