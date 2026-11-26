import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/cloud/domain/cloud.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/label_renderer.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/domain/ean.dart';
import 'package:shop_app/features/printing/domain/label_encoder.dart';
import 'package:shop_app/features/printing/domain/label_formatter.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/printing/presentation/print_error_text.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// The logo label picture, made off the UI thread (top-level: only the
/// argument crosses to the background isolate).
MonoImage? _logoLabel(({Uint8List bytes, int width, int height}) a) =>
    MonoImage.labelFromEncoded(
      a.bytes,
      widthDots: a.width,
      heightDots: a.height,
    );

/// Pick items and copies, then print barcode labels on the receipt printer.
class LabelsPage extends StatefulWidget {
  const LabelsPage({super.key});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  /// Labels wanted, by `i<itemId>` (free size) or `s<sizeId>` (one size),
  /// and what goes on each label (a size's label shows the size in the
  /// name, with the size's barcode and price).
  final _copies = <String, int>{};
  final _labelItems = <String, Item>{};

  /// Sizes per item, loaded as rows appear.
  final _sizes = <int, Future<List<ItemSize>>>{};
  final _items = <int, Item>{};
  String _query = '';
  bool _showPrice = true;
  bool _showShop = true;
  bool _printing = false;

  /// Logo labels (price-tag fronts): how many, and the picture used.
  int _logoCopies = 0;
  String? _ownLogo;
  String? _shopLogo;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLogo());
  }

  Future<void> _loadLogo() async {
    final settings = await context.read<SettingsRepository>().load();
    if (!mounted) return;
    final shop = await context.read<ShopProfileRepository>().load();
    if (!mounted) return;
    setState(() {
      _ownLogo = settings.labelSetup.logoPath;
      _shopLogo = shop?.logoPath;
    });
  }

  Future<void> _saveOwnLogo(String? path) async {
    final repo = context.read<SettingsRepository>();
    final settings = await repo.load();
    final setup = path == null
        ? settings.labelSetup.copyWith(clearLogo: true)
        : settings.labelSetup.copyWith(logoPath: path);
    await repo.save(settings.copyWith(labelSetup: setup));
    if (mounted) setState(() => _ownLogo = path);
  }

  Future<void> _changeLogo() async {
    final shops = context.read<ShopProfileRepository>();
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty) return;
    final stored = await shops.importLogo(files.single.xFile.path);
    await _saveOwnLogo(stored);
  }

  Future<void> _printLogo() async {
    final l10n = AppLocalizations.of(context);
    final router = GoRouter.of(context);
    final printer = context.read<PrinterService>();
    final setup = (await context.read<SettingsRepository>().load()).labelSetup;
    if (!mounted) return;
    if (setup.address == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            persist: false,
            content: Text(l10n.logoLabelsNeedPrinter),
            action: SnackBarAction(
              label: l10n.setUpPrinter,
              onPressed: () => router.push(AppRoutes.labelPrinter),
            ),
          ),
        );
      return;
    }
    final path = _ownLogo ?? _shopLogo;
    if (path == null || !File(path).existsSync()) {
      showSnack(context, l10n.logoLabelsNoPicture);
      return;
    }
    setState(() => _printing = true);
    try {
      final bytes = await File(path).readAsBytes();
      final image = await compute(_logoLabel, (
        bytes: bytes,
        width: setup.widthDots,
        height: setup.heightDots,
      ));
      if (!mounted) return;
      if (image == null) {
        showSnack(context, l10n.logoLabelsNotImage);
        return;
      }
      await printer.printParts(
        encodeLabelJob([(image: image, copies: _logoCopies)], setup),
        address: setup.address,
      );
      if (mounted) showSnack(context, l10n.printed);
    } on PrintException catch (e) {
      if (mounted) showSnack(context, printErrorText(l10n, e));
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  Widget _logoCard(AppLocalizations l10n) {
    final picture = _ownLogo ?? _shopLogo;
    return Card(
      key: const Key('logoLabelsCard'),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (picture != null && File(picture).existsSync())
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Image.file(
                      File(picture),
                      width: 56,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.logoLabels,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        _ownLogo != null
                            ? l10n.logoLabelsOwnPicture
                            : l10n.logoLabelsShopLogo,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                TextButton(
                  key: const Key('logoLabelsChange'),
                  style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: _changeLogo,
                  child: Text(l10n.logoLabelsChange),
                ),
                if (_ownLogo != null)
                  TextButton(
                    style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                    onPressed: () => _saveOwnLogo(null),
                    child: Text(l10n.logoLabelsUseShopLogo),
                  ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _logoCopies == 0
                      ? null
                      : () => setState(() => _logoCopies--),
                ),
                SizedBox(
                  width: 28,
                  child: Text('$_logoCopies', textAlign: TextAlign.center),
                ),
                IconButton(
                  key: const Key('logoLabelsPlus'),
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _logoCopies++),
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  key: const Key('logoLabelsPrint'),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: _logoCopies == 0 || _printing ? null : _printLogo,
                  icon: const Icon(Icons.print_outlined),
                  label: Text(l10n.logoLabelsPrint(_logoCopies)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int get _total => _copies.values.fold(0, (a, b) => a + b);

  /// Changes copies by [delta], reading the current count at tap time so
  /// quick repeated taps all count.
  void _change(String key, Item label, int delta) => setState(() {
    _labelItems[key] = label;
    final copies = (_copies[key] ?? 0) + delta;
    if (copies <= 0) {
      _copies.remove(key);
    } else {
      _copies[key] = copies;
    }
  });

  /// The label for one size: the size in the name, its barcode and price.
  static Item _sizeLabel(Item item, ItemSize s) => item.copyWith(
    name: '${item.name} (${s.size})',
    barcode: s.barcode,
    salePrice: s.priceOf(item),
  );

  Widget _counter(String key, Item label, {required Key plusKey}) {
    final copies = _copies[key] ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: copies == 0 ? null : () => _change(key, label, -1),
        ),
        SizedBox(
          width: 28,
          child: Text('$copies', textAlign: TextAlign.center),
        ),
        IconButton(
          key: plusKey,
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _change(key, label, 1),
        ),
      ],
    );
  }

  Future<void> _createBarcode(Item item) async {
    final l10n = AppLocalizations.of(context);
    final items = context.read<ItemRepository>();
    final series = (await context.read<CloudService>().link())?.series;
    if (!mounted) return;
    final code = Ean.inStore(item.id!, series: series);
    final saved = await items.save(item.copyWith(barcode: code));
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
      for (final e in _copies.entries)
        (item: _labelItems[e.key]!, copies: e.value),
    ];
    final setup = settings.labelSetup.copyWith(
      showPrice: _showPrice,
      showShop: _showShop,
    );
    final List<Uint8List> parts;
    final String? address;
    if (setup.address != null) {
      // A label printer: each label drawn as a picture of the label size.
      const renderer = LabelRenderer();
      parts = encodeLabelJob([
        for (final r in requests)
          (
            image: await renderer.render(r.item, setup, shopName: shop?.name),
            copies: r.copies,
          ),
      ], setup);
      address = setup.address;
    } else {
      // No label printer: text labels on the bill printer, as before.
      parts = [
        LabelFormatter(width: settings.paperWidth.charsPerLine).bytes(
          requests,
          LabelOptions(
            showPrice: _showPrice,
            shopName: _showShop ? shop?.name : null,
          ),
        ),
      ];
      address = null;
    }
    if (!mounted) return;
    try {
      await context.read<PrinterService>().printParts(parts, address: address);
      if (mounted) showSnack(context, l10n.printed);
    } on PrintException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              persist: false,
              content: Text(printErrorText(l10n, e)),
              action: SnackBarAction(
                label: l10n.setUpPrinter,
                onPressed: () => router.push(AppRoutes.labelPrinter),
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
      appBar: AppBar(
        title: Text(l10n.labelsTitle),
        actions: [
          IconButton(
            key: const Key('labelPrinterButton'),
            tooltip: l10n.lpTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.labelPrinter),
          ),
        ],
      ),
      body: Column(
        children: [
          _logoCard(l10n),
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
                    return FutureBuilder<List<ItemSize>>(
                      future: _sizes[item.id!] ??= context
                          .read<ItemRepository>()
                          .sizesOf(item.id!),
                      builder: (context, snap) {
                        final sizes = snap.data ?? const <ItemSize>[];
                        if (sizes.isEmpty) {
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
                            trailing: _counter(
                              'i${item.id}',
                              item,
                              plusKey: Key('labelPlus-${item.id}'),
                            ),
                          );
                        }
                        // One label per size, with the size's barcode.
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                [for (final s in sizes) s.size].join(' · '),
                              ),
                            ),
                            for (final s in sizes)
                              ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 32,
                                  right: 16,
                                ),
                                title: Text('${l10n.sizeField} ${s.size}'),
                                subtitle: Text(s.barcode ?? ''),
                                trailing: _counter(
                                  's${s.id}',
                                  _sizeLabel(item, s),
                                  plusKey: Key(
                                    'labelPlus-${item.id}-${s.size}',
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
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
          // Stay above the keyboard while searching.
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
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
