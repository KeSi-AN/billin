import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterDevice {
  const PrinterDevice({
    required this.name,
    required this.address,
    this.looksLikePrinter = false,
  });

  final String name;
  final String address;
  final bool looksLikePrinter;
}

enum BluetoothState { on, off, unsupported }

/// The Bluetooth link to a printer. An interface so the printer service can
/// be tested without hardware.
abstract interface class PrinterTransport {
  /// Asks for "Nearby devices" (Android 12+). `true` if allowed.
  Future<bool> ensurePermission();

  Future<BluetoothState> state();

  /// Devices already paired in Android's Bluetooth settings.
  Future<List<PrinterDevice>> bondedDevices();

  Future<void> connect(String address);

  Future<void> write(Uint8List bytes);

  Future<void> disconnect();

  Future<void> openBluetoothSettings();
}

/// Talks to `BluetoothPrinterChannel.kt` (classic Bluetooth SPP).
class MethodChannelPrinterTransport implements PrinterTransport {
  static const _channel = MethodChannel('shop_app/bt_printer');

  @override
  Future<bool> ensurePermission() async {
    final status = await Permission.bluetoothConnect.request();
    return status.isGranted || status.isLimited;
  }

  @override
  Future<BluetoothState> state() async =>
      switch (await _channel.invokeMethod<String>('state')) {
        'on' => BluetoothState.on,
        'off' => BluetoothState.off,
        _ => BluetoothState.unsupported,
      };

  @override
  Future<List<PrinterDevice>> bondedDevices() async {
    final raw =
        await _channel.invokeListMethod<Map<Object?, Object?>>(
          'bondedDevices',
        ) ??
        const [];
    final devices =
        [
            for (final d in raw)
              PrinterDevice(
                name: d['name']! as String,
                address: d['address']! as String,
                looksLikePrinter: d['looksLikePrinter'] == true,
              ),
          ]
          // Likely printers first, then by name.
          ..sort((a, b) {
            if (a.looksLikePrinter != b.looksLikePrinter) {
              return a.looksLikePrinter ? -1 : 1;
            }
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
    return devices;
  }

  @override
  Future<void> connect(String address) =>
      _channel.invokeMethod<void>('connect', {'address': address});

  @override
  Future<void> write(Uint8List bytes) =>
      _channel.invokeMethod<void>('write', {'bytes': bytes});

  @override
  Future<void> disconnect() => _channel.invokeMethod<void>('disconnect');

  @override
  Future<void> openBluetoothSettings() =>
      _channel.invokeMethod<void>('openSettings');
}
