import 'dart:convert';
import 'dart:typed_data';

import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/printing/domain/label_setup.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';

/// One drawn label and how many to print.
typedef LabelImage = ({MonoImage image, int copies});

/// Printer bytes for labels already drawn as pictures (one per label, the
/// size of the label), in the label printer's language.
Uint8List encodeLabels(List<LabelImage> labels, LabelSetup setup) =>
    switch (setup.language) {
      LabelLanguage.tspl => _tspl(labels, setup),
      LabelLanguage.escPos => _escPos(labels),
    };

/// One label's worth of check: a text line, a small black bar sent as a
/// picture, then "feed to the next label". Cheap to get wrong: if the printer
/// can't do pictures, it prints a few odd characters on one label, not a
/// stream of garbage across the roll.
Uint8List labelCheckBytes(LabelSetup setup) {
  if (setup.language == LabelLanguage.tspl) {
    final out = BytesBuilder(copy: false);
    void cmd(String c) => out.add(ascii.encode('$c\r\n'));
    cmd('SIZE ${_mm(setup.widthMm)} mm,${_mm(setup.heightMm)} mm');
    cmd('GAP ${_mm(setup.gapMm)} mm,0 mm');
    cmd('CLS');
    cmd('TEXT 10,10,"2",0,1,1,"TSPL OK"');
    cmd('BAR 10,60,200,24');
    cmd('PRINT 1,1');
    return out.toBytes();
  }
  // Shift right by the left margin: padding inside the picture, and the
  // printer's own left margin (GS L) for the text lines.
  final pad = (setup.leftMm * LabelSetup.dotsPerMm / 8).round();
  final dots = pad * 8;
  final widthBytes = pad + 24; // bar 192 dots wide
  const height = 24;
  final bar = Uint8List(widthBytes * height);
  for (var y = 0; y < height; y++) {
    bar.fillRange(y * widthBytes + pad, (y + 1) * widthBytes, 0xFF);
  }
  return (EscPosBuilder()
        ..init()
        ..rawBytes([0x1D, 0x4C, dots & 0xFF, dots >> 8])
        ..line('ESC/POS check')
        ..rawBytes([0x1D, 0x4C, 0, 0])
        ..raster(bar, widthBytes: widthBytes, height: height)
        ..rawBytes([0x1D, 0x4C, dots & 0xFF, dots >> 8])
        ..line('Picture above = OK')
        ..rawBytes([0x1D, 0x4C, 0, 0, 0x1D, 0x0C]))
      .build();
}

String _mm(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

Uint8List _tspl(List<LabelImage> labels, LabelSetup s) {
  final out = BytesBuilder(copy: false);
  void cmd(String c) => out.add(ascii.encode('$c\r\n'));
  cmd('SIZE ${_mm(s.widthMm)} mm,${_mm(s.heightMm)} mm');
  cmd('GAP ${_mm(s.gapMm)} mm,0 mm');
  cmd('DIRECTION 1,0');
  cmd('REFERENCE 0,0');
  cmd('SET TEAR ON');
  for (final l in labels) {
    if (l.copies <= 0) continue;
    final img = l.image;
    cmd('CLS');
    // In TSPL bitmaps a 0 bit prints black, so invert ours (1 = black).
    out
      ..add(ascii.encode('BITMAP 0,0,${img.widthBytes},${img.height},0,'))
      ..add(Uint8List.fromList([for (final b in img.bits) ~b & 0xFF]))
      ..add(ascii.encode('\r\n'));
    cmd('PRINT 1,${l.copies}');
  }
  return out.toBytes();
}

Uint8List _escPos(List<LabelImage> labels) {
  final b = EscPosBuilder().init();
  for (final l in labels) {
    for (var i = 0; i < l.copies; i++) {
      b
        ..raster(
          l.image.bits,
          widthBytes: l.image.widthBytes,
          height: l.image.height,
        )
        // GS FF: feed to the start of the next label (label/gap mode).
        ..rawBytes([0x1D, 0x0C]);
    }
  }
  return b.build();
}
