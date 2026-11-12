import 'dart:typed_data';

import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';

/// One item and how many labels to print for it.
typedef LabelRequest = ({Item item, int copies});

class LabelOptions {
  const LabelOptions({this.showPrice = true, this.shopName});

  final bool showPrice;

  /// Printed small at the top when set.
  final String? shopName;
}

/// Shelf / product labels on thermal paper: name, price and a scannable
/// barcode, one after another with a gap between them.
class LabelFormatter {
  const LabelFormatter({required this.width});

  /// Characters per line (32 on 58mm, 48 on 80mm).
  final int width;

  /// The text lines of one label (the barcode itself is not text).
  List<String> textLines(Item item, LabelOptions options) {
    final lines = <String>[];
    final shop = options.shopName;
    if (shop != null && shop.isNotEmpty) lines.add(_fit(shop, width));
    lines.addAll(_wrap(item.name, width).take(2));
    if (options.showPrice) lines.add(_priceLine(item));
    return lines;
  }

  String _priceLine(Item item) {
    final price = 'Rs.${item.salePrice.format(withSymbol: false)}';
    final mrp = item.mrp;
    if (mrp != null && mrp > item.salePrice) {
      return 'MRP Rs.${mrp.format(withSymbol: false)}  Now $price';
    }
    return price;
  }

  Uint8List bytes(List<LabelRequest> requests, LabelOptions options) {
    final b = EscPosBuilder().init();
    for (final r in requests) {
      for (var i = 0; i < r.copies; i++) {
        final item = r.item;
        b.align(PrintAlign.center);
        final shop = options.shopName;
        if (shop != null && shop.isNotEmpty) b.line(_fit(shop, width));
        b.bold();
        _wrap(item.name, width).take(2).forEach(b.line);
        b.bold(on: false);
        if (options.showPrice) {
          b
            ..bold()
            ..line(_priceLine(item))
            ..bold(on: false);
        }
        if (item.barcode != null) {
          b.barcode(item.barcode!, height: width >= 48 ? 90 : 70);
        }
        b
          ..align(PrintAlign.left)
          ..feed(2);
      }
    }
    return b.feed(2).cut().build();
  }

  static String _fit(String s, int width) {
    final a = EscPosBuilder.toAscii(s);
    return a.length <= width ? a : a.substring(0, width);
  }

  static List<String> _wrap(String text, int width) {
    final words = EscPosBuilder.toAscii(text).split(' ');
    final lines = <String>[];
    var current = '';
    for (final w in words) {
      final word = w.length > width ? w.substring(0, width) : w;
      if (current.isEmpty) {
        current = word;
      } else if (current.length + 1 + word.length <= width) {
        current = '$current $word';
      } else {
        lines.add(current);
        current = word;
      }
    }
    if (current.isNotEmpty) lines.add(current);
    return lines;
  }
}
