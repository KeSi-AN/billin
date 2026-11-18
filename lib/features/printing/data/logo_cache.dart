import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// The shop logo converted for the printer, kept until the logo, paper or
/// size changes (converting takes a moment; bills print often).
class LogoCache {
  String? _key;
  MonoImage? _image;

  Future<MonoImage?> logoFor(ShopProfile shop, AppSettingsData settings) async {
    final t = settings.receiptTemplate;
    final path = shop.logoPath;
    if (!t.showLogo || path == null) return null;
    final file = File(path);
    if (!file.existsSync()) return null;
    final key =
        '$path|${file.lastModifiedSync().millisecondsSinceEpoch}|'
        '${settings.paperWidth.name}|${t.logoWidthPercent}';
    if (key == _key) return _image;
    final bytes = await file.readAsBytes();
    final dots = paperDots(settings.paperWidth);
    final percent = t.logoWidthPercent;
    // Off the UI thread: big photos take a while to dither.
    final image = await compute(
      (b) => MonoImage.fromEncoded(b, paperDots: dots, percent: percent),
      bytes,
    );
    _key = key;
    _image = image;
    return image;
  }
}
