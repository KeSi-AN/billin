import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Pick a paired Bluetooth printer, set paper width, test print.
class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

enum _Access { checking, denied, bluetoothOff, unsupported, ready }

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  late final AppLifecycleListener _lifecycle;
  _Access _access = _Access.checking;
  List<PrinterDevice> _devices = const [];
  AppSettingsData? _settings;
  bool _testing = false;

  PrinterService get _printer => context.read<PrinterService>();
  SettingsRepository get _repo => context.read<SettingsRepository>();

  @override
  void initState() {
    super.initState();
    // Coming back from Android's Bluetooth settings: refresh the list.
    _lifecycle = AppLifecycleListener(onResume: _refresh);
    unawaited(_refresh());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final transport = _printer.transport;
    final settings = await _repo.load();
    var access = _Access.ready;
    var devices = const <PrinterDevice>[];
    if (!await transport.ensurePermission()) {
      access = _Access.denied;
    } else {
      switch (await transport.state()) {
        case BluetoothState.off:
          access = _Access.bluetoothOff;
        case BluetoothState.unsupported:
          access = _Access.unsupported;
        case BluetoothState.on:
          devices = await transport.bondedDevices();
      }
    }
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _access = access;
      _devices = devices;
    });
  }

  Future<void> _update(AppSettingsData next) async {
    setState(() => _settings = next);
    await _repo.save(next);
  }

  Future<void> _testPrint() async {
    final s = _settings!;
    final l10n = AppLocalizations.of(context);
    setState(() => _testing = true);
    try {
      await _printer.printBytes(
        ReceiptFormatter(width: s.paperWidth.charsPerLine)
            .testPage(s.printerName ?? ''),
      );
      if (mounted) showSnack(context, l10n.printed);
    } on PrintException catch (e) {
      if (mounted) {
        showSnack(
          context,
          e.error == PrintError.bluetoothOff
              ? l10n.printErrBluetoothOff
              : l10n.printErrFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final settings = _settings;

    Widget message(String body, {String? action, VoidCallback? onAction}) =>
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(body, textAlign: TextAlign.center),
              if (action != null) ...[
                const SizedBox(height: 16),
                FilledButton(onPressed: onAction, child: Text(action)),
              ],
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.printerSettingsTitle)),
      body: settings == null || _access == _Access.checking
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(l10n.printerPaperWidth, style: text.titleSmall),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SegmentedButton<PaperWidth>(
                    segments: const [
                      ButtonSegment(
                        value: PaperWidth.mm58,
                        label: Text('58 mm'),
                      ),
                      ButtonSegment(
                        value: PaperWidth.mm80,
                        label: Text('80 mm'),
                      ),
                    ],
                    selected: {settings.paperWidth},
                    onSelectionChanged: (s) =>
                        _update(settings.copyWith(paperWidth: s.first)),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(l10n.printerPaired, style: text.titleSmall),
                ),
                switch (_access) {
                  _Access.denied => message(
                    l10n.printErrPermission,
                    action: l10n.printerAllowAccess,
                    onAction: _refresh,
                  ),
                  _Access.bluetoothOff => message(
                    l10n.printErrBluetoothOff,
                    action: l10n.printerTurnOnBluetooth,
                    onAction: _printer.transport.openBluetoothSettings,
                  ),
                  _Access.unsupported => message(l10n.printErrUnsupported),
                  _ when _devices.isEmpty => message(l10n.printerNoneFound),
                  _ => RadioGroup<String>(
                    groupValue: settings.printerAddress,
                    onChanged: (address) {
                      final d = _devices.firstWhere(
                        (d) => d.address == address,
                      );
                      unawaited(
                        _update(
                          settings.copyWith(
                            printerAddress: d.address,
                            printerName: d.name,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        for (final d in _devices)
                          RadioListTile<String>(
                            value: d.address,
                            title: Text(d.name),
                            subtitle: Text(
                              d.looksLikePrinter
                                  ? '${d.address} · ${l10n.printerLikely}'
                                  : d.address,
                            ),
                          ),
                      ],
                    ),
                  ),
                },
                if (_access == _Access.ready || _access == _Access.bluetoothOff)
                  ListTile(
                    leading: const Icon(Icons.bluetooth_searching),
                    title: Text(l10n.printerPairNew),
                    onTap: _printer.transport.openBluetoothSettings,
                  ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton.icon(
                    key: const Key('testPrintButton'),
                    onPressed: settings.printerAddress == null || _testing
                        ? null
                        : _testPrint,
                    icon: const Icon(Icons.print_outlined),
                    label: Text(
                      _testing ? l10n.printing : l10n.printerTestPrint,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
