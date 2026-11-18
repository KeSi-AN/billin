import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/label_renderer.dart';
import 'package:shop_app/features/printing/domain/label_encoder.dart';
import 'package:shop_app/features/printing/domain/label_setup.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';

MonoImage solid(int widthBytes, int height, int byte) => MonoImage(
  widthBytes: widthBytes,
  height: height,
  bits: Uint8List(widthBytes * height)..fillRange(0, widthBytes * height, byte),
);

int indexOf(Uint8List bytes, List<int> pattern, [int from = 0]) {
  for (var i = from; i + pattern.length <= bytes.length; i++) {
    var ok = true;
    for (var j = 0; j < pattern.length; j++) {
      if (bytes[i + j] != pattern[j]) {
        ok = false;
        break;
      }
    }
    if (ok) return i;
  }
  return -1;
}

void main() {
  group('TSPL', () {
    const setup = LabelSetup(
      language: LabelLanguage.tspl,
      widthMm: 50,
      heightMm: 25,
      gapMm: 2,
    );

    test('sets size and gap, sends each picture inverted, prints copies', () {
      final bytes = encodeLabels([
        (image: solid(2, 3, 0xFF), copies: 3),
        (image: solid(2, 3, 0x0F), copies: 0), // skipped
      ], setup);
      final text = latin1.decode(bytes);
      expect(text, startsWith('SIZE 50 mm,25 mm\r\nGAP 2 mm,0 mm\r\n'));
      expect('CLS'.allMatches(text), hasLength(1));
      final header = indexOf(bytes, ascii.encode('BITMAP 0,0,2,3,0,'));
      expect(header, greaterThan(0));
      final data = bytes.sublist(header + 'BITMAP 0,0,2,3,0,'.length).take(6);
      expect(data, everyElement(0x00)); // black prints as 0 in TSPL
      expect(text, endsWith('PRINT 1,3\r\n'));
    });

    test('fractional sizes keep one decimal', () {
      final text = latin1.decode(
        encodeLabels(
          const [],
          const LabelSetup(
            language: LabelLanguage.tspl,
            widthMm: 29.5,
            gapMm: 1.5,
          ),
        ),
      );
      expect(text, startsWith('SIZE 29.5 mm,25 mm\r\nGAP 1.5 mm,0 mm'));
    });
  });

  test('ESC/POS: raster per copy, then feed to the next label', () {
    final bytes = encodeLabels([
      (image: solid(2, 3, 0xFF), copies: 2),
    ], const LabelSetup());
    expect(bytes.take(2), [0x1B, 0x40]);
    final first = indexOf(bytes, [0x1D, 0x76, 0x30, 0x00, 2, 0, 3, 0]);
    final second = indexOf(bytes, [
      0x1D,
      0x76,
      0x30,
      0x00,
      2,
      0,
      3,
      0,
    ], first + 1);
    expect(first, greaterThan(0));
    expect(second, greaterThan(first));
    expect(bytes.skip(bytes.length - 2), [0x1D, 0x0C]);
  });

  test('label setup survives JSON; nonsense falls back to defaults', () {
    const s = LabelSetup(
      address: 'C8:47:44:11:2A:BF',
      name: 'PSF-20',
      language: LabelLanguage.tspl,
      widthMm: 40,
      heightMm: 30,
      gapMm: 3,
      showMrp: false,
    );
    expect(LabelSetup.fromJson(s.toJson()), s);
    expect(LabelSetup.fromJson('nope'), const LabelSetup());
    expect(s.widthDots, 320);
    expect(s.heightDots, 240);
  });

  testWidgets('a label is drawn at 8 dots per mm with name, price, bars', (
    tester,
  ) async {
    const setup = LabelSetup(widthMm: 50, heightMm: 25);
    final image = (await tester.runAsync(
      () => const LabelRenderer().render(
        const Item(
          name: 'kurti set',
          salePrice: Money.rupees(1835),
          barcode: 'DN84375',
        ),
        setup,
        shopName: 'Sadiya Fashion',
      ),
    ))!;
    expect(image.width, 400);
    expect(image.height, 200);
    int blackIn(int y0, int y1) {
      var n = 0;
      for (var y = y0; y < y1; y++) {
        for (var x = 0; x < image.width; x++) {
          if (image.isBlack(x, y)) n++;
        }
      }
      return n;
    }

    expect(blackIn(0, 100), greaterThan(200)); // text at the top
    // Bars: a row through them has many black/white changes.
    final row = (200 * 0.72).round();
    var changes = 0;
    for (var x = 1; x < image.width; x++) {
      if (image.isBlack(x, row) != image.isBlack(x - 1, row)) changes++;
    }
    expect(changes, greaterThan(30));
  });

  test('quick check fits one label and ends with feed-to-next', () {
    final bytes = labelCheckBytes(const LabelSetup());
    expect(bytes.length, lessThan(700));
    expect(bytes.take(2), [0x1B, 0x40]);
    expect(bytes.skip(bytes.length - 2), [0x1D, 0x0C]);
  });
}
