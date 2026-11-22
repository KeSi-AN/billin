import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/printing/domain/label_setup.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

import '../../helpers/fakes.dart';

Uint8List png(int w, int h, void Function(img.Image) draw) {
  final i = img.Image(width: w, height: h)..clear(img.ColorRgb8(255, 255, 255));
  draw(i);
  return img.encodePng(i);
}

void main() {
  test('a picture made for the label prints dot for dot', () {
    final bytes = png(384, 224, (i) {
      i
        ..setPixelRgb(0, 0, 0, 0, 0)
        ..setPixelRgb(383, 223, 0, 0, 0)
        ..setPixelRgb(150, 100, 0, 0, 0);
    });
    final m = MonoImage.labelFromEncoded(
      bytes,
      widthDots: 384,
      heightDots: 224,
    )!;
    expect((m.width, m.height), (384, 224));
    final black = [
      for (var y = 0; y < 224; y++)
        for (var x = 0; x < 384; x++)
          if (m.isBlack(x, y)) (x, y),
    ];
    expect(black, [(0, 0), (150, 100), (383, 223)]);
  });

  test('1-bit pictures (as Shreyans exports) keep white as white', () {
    final i = img.Image(
      width: 384,
      height: 224,
      format: img.Format.uint1,
      numChannels: 1,
    );
    for (final p in i) {
      p.r = 1; // white
    }
    i.getPixel(10, 20).r = 0; // one black dot
    expect(i.getPixel(0, 0).r, 1);
    final m = MonoImage.labelFromEncoded(
      img.encodePng(i),
      widthDots: 384,
      heightDots: 224,
    )!;
    var black = 0;
    for (final b in m.bits) {
      for (var v = b; v != 0; v &= v - 1) {
        black++;
      }
    }
    expect(black, 1);
    expect(m.isBlack(10, 20), isTrue);
  });

  test('any other picture is fitted inside the border and centred', () {
    final bytes = png(100, 50, (i) => i.clear(img.ColorRgb8(0, 0, 0)));
    final m = MonoImage.labelFromEncoded(
      bytes,
      widthDots: 384,
      heightDots: 224,
    )!;
    // Fits 360 wide (384 - 2 x 12) -> 180 tall, centred.
    expect(m.isBlack(192, 112), isTrue);
    expect(m.isBlack(11, 112), isFalse);
    expect(m.isBlack(12, 112), isTrue);
    expect(m.isBlack(371, 112), isTrue);
    expect(m.isBlack(372, 112), isFalse);
    expect(m.isBlack(192, 21), isFalse);
    expect(m.isBlack(192, 22), isTrue);
    expect(
      MonoImage.labelFromEncoded(
        Uint8List.fromList([1, 2, 3]),
        widthDots: 384,
        heightDots: 224,
      ),
      isNull,
    );
  });

  test('the logo picture is remembered and can be cleared', () {
    const s = LabelSetup(logoPath: '/x/logo.png');
    expect(LabelSetup.fromJson(s.toJson()).logoPath, '/x/logo.png');
    expect(s.copyWith(note: 'n').logoPath, '/x/logo.png');
    expect(s.copyWith(clearLogo: true).logoPath, isNull);
  });

  testWidgets('labels page prints logo labels on the label printer', (
    tester,
  ) async {
    final dir = Directory.systemTemp.createTempSync('logo');
    addTearDown(() {
      try {
        dir.deleteSync(recursive: true);
      } on FileSystemException {
        // Windows: the thumbnail may still hold the file; temp gets cleaned.
      }
    });
    final logo = File('${dir.path}/logo.png')
      ..writeAsBytesSync(png(60, 30, (i) => i.clear(img.ColorRgb8(0, 0, 0))));
    final h = TestHarness(
      shop: testShop,
      settings: AppSettingsData(
        printerAddress: 'AA:BB',
        labelSetup: LabelSetup(
          address: 'C8:47',
          widthMm: 48,
          heightMm: 28,
          logoPath: logo.path,
        ),
      ),
    );
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('itemsTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('labelsButton')));
    await tester.pumpAndSettle();

    expect(find.text('Logo labels'), findsOneWidget);
    expect(
      find.text('Your own picture, for the front of price tags'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('logoLabelsPlus')));
    await tester.tap(find.byKey(const Key('logoLabelsPlus')));
    await tester.pump();
    expect(find.text('Print 2'), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('logoLabelsPrint')));
      for (var i = 0; i < 50 && h.transport.written.length < 2; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    });
    await tester.pumpAndSettle();

    // Posiflow: set-up, then both labels (picture + next label each).
    expect(h.transport.written, hasLength(2));
    final labels = h.transport.written[1];
    expect(labels.length, 2 * (8 + 48 * 224 + 2));
    expect(labels.sublist(0, 8), [0x1D, 0x76, 0x30, 0, 48, 0, 224, 0]);
    expect(find.text('Printed'), findsOneWidget);
  });
}
