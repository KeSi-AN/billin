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
      LabelLanguage.posiflow => Uint8List.fromList([
        ...posiflowJobStart,
        ..._posiflowLabels(labels),
      ]),
    };

/// What the Shreyans app sends a Posiflow PSF-20 (SRS20) before a print job,
/// read from a Bluetooth capture of one of its labels: paper type 2 (labels
/// with gaps), then its paper spec (1B 29, 200 dots, 50.0 x 25.0 mm, 1E).
/// The printer finds the label edges itself.
const posiflowJobStart = [
  0x1C, 0x25, 0x02, //
  0x1B, 0x29, 0xC8, 0x00, 0xF4, 0x01, 0xFA, 0x00, 0x1E,
];

/// Posiflow PSF-20 / SRS20, byte for byte as the Shreyans app prints: per
/// label a plain ESC/POS picture (GS v 0) then "go to the next label"
/// (1B 69). No reset (ESC @) and no GS FF.
Uint8List _posiflowLabels(List<LabelImage> labels) {
  final out = BytesBuilder(copy: false);
  for (final l in labels) {
    final img = l.image;
    for (var i = 0; i < l.copies; i++) {
      out
        ..add([
          0x1D, 0x76, 0x30, 0x00, //
          img.widthBytes & 0xFF, img.widthBytes >> 8,
          img.height & 0xFF, img.height >> 8,
        ])
        ..add(img.bits)
        ..add([0x1B, 0x69]);
    }
  }
  return out.toBytes();
}

/// The labels as separate writes, with a pause between them where the
/// printer needs one (Shreyans waits after the job start before the
/// pictures). Every other language is a single write.
List<Uint8List> encodeLabelJob(List<LabelImage> labels, LabelSetup setup) =>
    switch (setup.language) {
      LabelLanguage.posiflow => [
        Uint8List.fromList(posiflowJobStart),
        _posiflowLabels(labels),
      ],
      _ => [encodeLabels(labels, setup)],
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
