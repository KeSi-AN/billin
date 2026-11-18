import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Whether a hardware keyboard (a Bluetooth barcode scanner counts) is
/// hiding the on-screen keyboard.
abstract interface class KeyboardStatus {
  /// `true` when typing is blocked: a hardware keyboard is connected and
  /// "Use on-screen keyboard" is off (or can't be read).
  Future<bool> softKeyboardBlocked();

  Future<void> openSettings();
}

class ChannelKeyboardStatus implements KeyboardStatus {
  static const _channel = MethodChannel('shop_app/keyboard');

  @override
  Future<bool> softKeyboardBlocked() async {
    try {
      final s = await _channel.invokeMapMethod<String, Object?>('state');
      if (s == null || s['hardKeyboard'] != true) return false;
      return s['showIme'] != true;
    } on Object {
      return false; // No channel (tests, other platforms): don't nag.
    }
  }

  @override
  Future<void> openSettings() async {
    try {
      await _channel.invokeMethod<void>('openSettings');
    } on Object {
      // Nothing to open.
    }
  }
}

/// A note shown where the shopkeeper needs to type, when the barcode
/// scanner is hiding the on-screen keyboard. Rechecks on app resume (after
/// they change the setting).
class KeyboardHint extends StatefulWidget {
  const KeyboardHint({this.status, super.key});

  /// Defaults to the Android channel.
  final KeyboardStatus? status;

  @override
  State<KeyboardHint> createState() => _KeyboardHintState();
}

class _KeyboardHintState extends State<KeyboardHint>
    with WidgetsBindingObserver {
  late final KeyboardStatus _status = widget.status ?? ChannelKeyboardStatus();
  bool _blocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_check());
  }

  Future<void> _check() async {
    final blocked = await _status.softKeyboardBlocked();
    if (mounted && blocked != _blocked) setState(() => _blocked = blocked);
  }

  @override
  Widget build(BuildContext context) {
    if (!_blocked) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: const Key('keyboardHint'),
      color: scheme.tertiaryContainer,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.keyboard_hide, color: scheme.onTertiaryContainer),
        title: Text(
          l10n.keyboardHint,
          style: TextStyle(color: scheme.onTertiaryContainer),
        ),
        trailing: TextButton(
          onPressed: _status.openSettings,
          child: Text(l10n.keyboardHintFix),
        ),
      ),
    );
  }
}
