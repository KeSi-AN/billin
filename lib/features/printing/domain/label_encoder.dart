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
      LabelLanguage.caysn => _caysn(labels, setup),
    };

/// Caysn label printers (Posiflow PSF-20 and others), spoken to exactly as
/// the Shreyans app's Caysn library does it: print speed and darkness, then
/// for each label a page the size of the label holding one picture, printed
/// as many times as asked. In page mode the printer finds the start of the
/// label itself (pulling the paper back from the tear-off position first), so
/// a label never runs on to the next one.
Uint8List _caysn(List<LabelImage> labels, LabelSetup s) {
  List<int> u16(int v) => [v & 0xFF, (v >> 8) & 0xFF];
  final out = BytesBuilder(copy: false)
    // Print speed 100 mm/s (4 inches/s): 1F 28 73 02 00 nL nH.
    ..add([0x1F, 0x28, 0x73, 0x02, 0x00, ...u16(100)])
    // Darkness 6: 12 23 n.
    ..add([0x12, 0x23, 6]);
  for (final l in labels) {
    final img = l.image;
    var left = l.copies;
    while (left > 0) {
      final n = left > 255 ? 255 : left;
      left -= n;
      out
        // Page begin at 0,0, label-sized, not rotated: 1A 5B 01 x y w h r.
        ..add([
          0x1A, 0x5B, 0x01, ...u16(0), ...u16(0), //
          ...u16(s.widthDots), ...u16(s.heightDots), 0,
        ])
        // Picture at 0,0: 1A 21 01 x y widthDots height style, then rows of
        // 1-bit dots (1 = black, leftmost dot in the top bit).
        ..add([
          0x1A, 0x21, 0x01, ...u16(0), ...u16(0), //
          ...u16(img.widthBytes * 8), ...u16(img.height), ...u16(0),
        ])
        ..add(img.bits)
        // Print the page n times: 1A 4F 01 n.
        ..add([0x1A, 0x4F, 0x01, n]);
    }
  }
  return out.toBytes();
}

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
