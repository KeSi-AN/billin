import 'package:flutter/services.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

enum PrintError {
  notConfigured,
  permissionDenied,
  bluetoothOff,
  unsupported,
  failed,
}

class PrintException implements Exception {
  const PrintException(this.error, [this.detail]);

  final PrintError error;
  final String? detail;

  @override
  String toString() =>
      'PrintException($error${detail == null ? '' : ': $detail'})';
}

/// Sends bytes to the saved printer. Keeps the connection open between
/// prints, and reconnects once if the printer dropped (it was switched off,
/// went out of range, or slept).
class PrinterService {
  PrinterService(this._transport, this._settings);

  final PrinterTransport _transport;
  final SettingsRepository _settings;

  PrinterTransport get transport => _transport;

  Future<void> printBytes(Uint8List bytes, {String? address}) async {
    final target = address ?? (await _settings.load()).printerAddress;
    if (target == null) throw const PrintException(PrintError.notConfigured);
    if (!await _transport.ensurePermission()) {
      throw const PrintException(PrintError.permissionDenied);
    }
    switch (await _transport.state()) {
      case BluetoothState.off:
        throw const PrintException(PrintError.bluetoothOff);
      case BluetoothState.unsupported:
        throw const PrintException(PrintError.unsupported);
      case BluetoothState.on:
        break;
    }
    try {
      await _transport.connect(target);
      await _transport.write(bytes);
    } on PlatformException {
      // Stale connection: drop it and try once more.
      try {
        await _transport.disconnect();
        await _transport.connect(target);
        await _transport.write(bytes);
      } on PlatformException catch (e) {
        throw PrintException(PrintError.failed, e.message);
      }
    }
  }
}
