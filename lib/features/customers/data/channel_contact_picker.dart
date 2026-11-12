import 'package:flutter/services.dart';
import 'package:shop_app/features/customers/domain/contact_picker.dart';

/// Talks to `ContactPickerChannel.kt`, which opens Android's contact picker.
class ChannelContactPicker implements ContactPicker {
  static const _channel = MethodChannel('shop_app/contacts');

  @override
  Future<PickedContact?> pick() async {
    try {
      final result = await _channel.invokeMapMethod<String, String>('pick');
      if (result == null) return null;
      return (name: result['name'] ?? '', phone: result['phone'] ?? '');
    } on PlatformException {
      return null;
    }
  }
}
