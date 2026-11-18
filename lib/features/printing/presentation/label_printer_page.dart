import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/label_renderer.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
import 'package:shop_app/features/printing/domain/label_encoder.dart';
import 'package:shop_app/features/printing/domain/label_setup.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/printing/presentation/print_error_text.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// The item used for the preview and the test label.
const sampleLabelItem = Item(
  name: 'kurti set',
  salePrice: Money.rupees(1835),
  mrp: Money.rupees(1999),
  barcode: 'DN84375',
);

/// Choose the label printer, its language and the label size; preview and
/// print a test label. Changes save as you go.
class LabelPrinterPage extends StatefulWidget {
  const LabelPrinterPage({super.key});

  @override
  State<LabelPrinterPage> createState() => _LabelPrinterPageState();
}

class _LabelPrinterPageState extends State<LabelPrinterPage> {
  late final SettingsRepository _repo = context.read<SettingsRepository>();
  AppSettingsData? _settings;
  List<PrinterDevice> _devices = const [];
  String? _shopName;
  Future<MonoImage>? _preview;
  bool _printing = false;
  final _width = TextEditingController();
  final _height = TextEditingController();
  final _gap = TextEditingController();
  final _left = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final transport = context.read<PrinterService>().transport;
    final shops = context.read<ShopProfileRepository>();
    final s = await _repo.load();
    final shop = await shops.load();
    var devices = const <PrinterDevice>[];
    if (await transport.ensurePermission() &&
        await transport.state() == BluetoothState.on) {
      devices = await transport.bondedDevices();
    }
    if (!mounted) return;
    final l = s.labelSetup;
    _width.text = _num(l.widthMm);
    _height.text = _num(l.heightMm);
    _gap.text = _num(l.gapMm);
    _left.text = _num(l.leftMm);
    setState(() {
      _settings = s;
      _devices = devices;
      _shopName = shop?.name;
      _preview = _render(l);
    });
  }

  @override
  void dispose() {
    _width.dispose();
    _height.dispose();
    _gap.dispose();
    _left.dispose();
    super.dispose();
  }

  static String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  LabelSetup get _setup => _settings!.labelSetup;

  Future<MonoImage> _render(LabelSetup l) =>
      const LabelRenderer().render(sampleLabelItem, l, shopName: _shopName);

  void _set(LabelSetup l) {
    final next = _settings!.copyWith(labelSetup: l);
    setState(() {
      _settings = next;
      _preview = _render(l);
    });
    unawaited(_repo.save(next));
  }

  void _size() {
    double? v(TextEditingController c) =>
        double.tryParse(c.text.trim().replaceAll(',', '.'));
    final w = v(_width);
    final h = v(_height);
    final g = v(_gap);
    final left = v(_left);
    if (w == null || h == null || g == null || left == null) return;
    if (w < 15 || w > 110 || h < 10 || h > 150 || g < 0 || g > 10) return;
    if (left < 0 || left > 10) return;
    _set(_setup.copyWith(widthMm: w, heightMm: h, gapMm: g, leftMm: left));
  }

  Future<void> _check() async {
    final l10n = AppLocalizations.of(context);
    final printer = context.read<PrinterService>();
    setState(() => _printing = true);
    try {
      await printer.printBytes(
        labelCheckBytes(_setup),
        address: _setup.address,
      );
      if (mounted) showSnack(context, l10n.lpCheckSent);
    } on PrintException catch (e) {
      if (mounted) showSnack(context, printErrorText(l10n, e));
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  Future<void> _test() async {
    final l10n = AppLocalizations.of(context);
    final printer = context.read<PrinterService>();
    setState(() => _printing = true);
    try {
      final image = await _render(_setup);
      final bytes = encodeLabels([(image: image, copies: 1)], _setup);
      await printer.printBytes(bytes, address: _setup.address);
      if (mounted) showSnack(context, l10n.printed);
    } on PrintException catch (e) {
      if (mounted) showSnack(context, printErrorText(l10n, e));
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final s = _settings;
    if (s == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.lpTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final l = _setup;
    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(title, style: text.titleSmall),
    );
    Widget mm(String key, TextEditingController c, String label) => Expanded(
      child: TextField(
        key: Key(key),
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
        decoration: InputDecoration(labelText: label, suffixText: 'mm'),
        onChanged: (_) => _size(),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.lpTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('lpCheckButton'),
                  onPressed: _printing || l.address == null ? null : _check,
                  child: Text(l10n.lpCheck),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  key: const Key('lpTestButton'),
                  onPressed: _printing || l.address == null ? null : _test,
                  icon: const Icon(Icons.print_outlined),
                  label: Text(_printing ? l10n.printing : l10n.lpTest),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: FutureBuilder<MonoImage>(
                future: _preview,
                builder: (context, snap) {
                  final img = snap.data;
                  final width = MediaQuery.sizeOf(context).width * 0.75;
                  if (img == null) {
                    return SizedBox(height: width * l.heightMm / l.widthMm);
                  }
                  return Container(
                    key: const Key('labelPreview'),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: width,
                    height: width * img.height / img.width,
                    child: CustomPaint(painter: MonoImagePainter(img)),
                  );
                },
              ),
            ),
          ),
          section(l10n.lpPrinter),
          RadioGroup<String?>(
            groupValue: l.address,
            onChanged: (address) {
              final d = _devices.where((d) => d.address == address).firstOrNull;
              _set(
                LabelSetup(
                  address: d?.address,
                  name: d?.name,
                  language: l.language,
                  widthMm: l.widthMm,
                  heightMm: l.heightMm,
                  gapMm: l.gapMm,
                  leftMm: l.leftMm,
                  showShop: l.showShop,
                  showPrice: l.showPrice,
                  showMrp: l.showMrp,
                ),
              );
            },
            child: Column(
              children: [
                RadioListTile<String?>(
                  value: null,
                  title: Text(l10n.lpUseBillPrinter),
                  subtitle: Text(l10n.lpUseBillPrinterHelp),
                ),
                for (final d in _devices)
                  RadioListTile<String?>(
                    key: Key('lp_${d.address}'),
                    value: d.address,
                    title: Text(d.name),
                    subtitle: Text(d.address),
                  ),
              ],
            ),
          ),
          section(l10n.lpLanguage),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(l10n.lpLanguageHelp, style: text.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<LabelLanguage>(
              key: const Key('lpLanguage'),
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: LabelLanguage.escPos,
                  label: Text('ESC/POS'),
                ),
                ButtonSegment(value: LabelLanguage.tspl, label: Text('TSPL')),
              ],
              selected: {l.language},
              onSelectionChanged: (v) => _set(l.copyWith(language: v.first)),
            ),
          ),
          section(l10n.lpSize),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                mm('lpWidth', _width, l10n.lpWidth),
                const SizedBox(width: 12),
                mm('lpHeight', _height, l10n.lpHeight),
                const SizedBox(width: 12),
                mm('lpGap', _gap, l10n.lpGap),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                mm('lpLeft', _left, l10n.lpLeft),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(l10n.lpLeftHelp, style: text.bodySmall),
                ),
              ],
            ),
          ),
          section(l10n.lpContent),
          SwitchListTile(
            title: Text(l10n.labelsShowShop),
            value: l.showShop,
            onChanged: (v) => _set(l.copyWith(showShop: v)),
          ),
          SwitchListTile(
            title: Text(l10n.labelsShowPrice),
            value: l.showPrice,
            onChanged: (v) => _set(l.copyWith(showPrice: v)),
          ),
          SwitchListTile(
            title: Text(l10n.lpShowMrp),
            value: l.showMrp,
            onChanged: (v) => _set(l.copyWith(showMrp: v)),
          ),
        ],
      ),
    );
  }
}

/// Paints a [MonoImage] dot for dot.
class MonoImagePainter extends CustomPainter {
  MonoImagePainter(this.image);

  final MonoImage image;

  @override
  void paint(Canvas canvas, Size size) {
    final dot = size.width / image.width;
    final paint = Paint()..color = Colors.black;
    for (var y = 0; y < image.height; y++) {
      var run = -1;
      for (var x = 0; x <= image.width; x++) {
        final black = x < image.width && image.isBlack(x, y);
        if (black && run < 0) run = x;
        if (!black && run >= 0) {
          canvas.drawRect(
            Rect.fromLTWH(run * dot, y * dot, (x - run) * dot, dot + 0.3),
            paint,
          );
          run = -1;
        }
      }
    }
  }

  @override
  bool shouldRepaint(MonoImagePainter old) => old.image != image;
}
