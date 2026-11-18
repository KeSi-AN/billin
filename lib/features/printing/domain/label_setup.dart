import 'dart:convert';

import 'package:meta/meta.dart';

/// How the label printer is spoken to.
enum LabelLanguage {
  /// TSPL (TSC and most Chinese label printers): label size and gap are
  /// set, then one picture per label.
  tspl,

  /// ESC/POS picture followed by "feed to the next label" (GS FF), for
  /// receipt-style printers that also take labels.
  escPos,
}

/// The label printer and the labels in it. Stored as JSON in settings.
@immutable
class LabelSetup {
  const LabelSetup({
    this.address,
    this.name,
    this.language = LabelLanguage.tspl,
    this.widthMm = 50,
    this.heightMm = 25,
    this.gapMm = 2,
    this.showShop = true,
    this.showPrice = true,
    this.showMrp = true,
  });

  factory LabelSetup.fromJson(String? json) {
    if (json == null || json.isEmpty) return const LabelSetup();
    try {
      final m = jsonDecode(json) as Map<String, Object?>;
      const d = LabelSetup();
      double n(String k, double fallback) =>
          (m[k] as num?)?.toDouble() ?? fallback;
      bool b(String k, bool fallback) =>
          m[k] is bool ? m[k]! as bool : fallback;
      return LabelSetup(
        address: m['address'] as String?,
        name: m['name'] as String?,
        language: LabelLanguage.values.asNameMap()[m['language']] ?? d.language,
        widthMm: n('widthMm', d.widthMm).clamp(15, 110),
        heightMm: n('heightMm', d.heightMm).clamp(10, 150),
        gapMm: n('gapMm', d.gapMm).clamp(0, 10),
        showShop: b('showShop', d.showShop),
        showPrice: b('showPrice', d.showPrice),
        showMrp: b('showMrp', d.showMrp),
      );
    } on Object {
      return const LabelSetup();
    }
  }

  /// Bluetooth address of the label printer (`null`: use the bill printer).
  final String? address;
  final String? name;
  final LabelLanguage language;
  final double widthMm;
  final double heightMm;

  /// Space between labels on the roll.
  final double gapMm;
  final bool showShop;
  final bool showPrice;

  /// "MRP" crossed against the price when the MRP is higher.
  final bool showMrp;

  /// Print head resolution: 203 dpi = 8 dots per mm.
  static const dotsPerMm = 8;

  int get widthDots => (widthMm * dotsPerMm).round() ~/ 8 * 8;
  int get heightDots => (heightMm * dotsPerMm).round();

  String toJson() => jsonEncode({
    'address': address,
    'name': name,
    'language': language.name,
    'widthMm': widthMm,
    'heightMm': heightMm,
    'gapMm': gapMm,
    'showShop': showShop,
    'showPrice': showPrice,
    'showMrp': showMrp,
  });

  LabelSetup copyWith({
    String? address,
    String? name,
    LabelLanguage? language,
    double? widthMm,
    double? heightMm,
    double? gapMm,
    bool? showShop,
    bool? showPrice,
    bool? showMrp,
  }) => LabelSetup(
    address: address ?? this.address,
    name: name ?? this.name,
    language: language ?? this.language,
    widthMm: widthMm ?? this.widthMm,
    heightMm: heightMm ?? this.heightMm,
    gapMm: gapMm ?? this.gapMm,
    showShop: showShop ?? this.showShop,
    showPrice: showPrice ?? this.showPrice,
    showMrp: showMrp ?? this.showMrp,
  );

  @override
  bool operator ==(Object other) =>
      other is LabelSetup && other.toJson() == toJson();

  @override
  int get hashCode => toJson().hashCode;
}
