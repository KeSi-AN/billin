import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/domain/ean.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/printing/domain/label_formatter.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

import '../../helpers/fakes.dart';

bool containsSequence(List<int> haystack, List<int> needle) {
  for (var i = 0; i + needle.length <= haystack.length; i++) {
    var ok = true;
    for (var j = 0; j < needle.length && ok; j++) {
      ok = haystack[i + j] == needle[j];
    }
    if (ok) return true;
  }
  return false;
}

void main() {
  group('Ean', () {
    test('validates known EAN-13 and EAN-8 numbers', () {
      expect(Ean.isValid('4006381333931'), isTrue);
      expect(Ean.isValid('96385074'), isTrue);
      expect(Ean.isValid('4006381333932'), isFalse);
      expect(Ean.isValid('400638133393'), isFalse);
      expect(Ean.isValid('ABC'), isFalse);
    });

    test('in-store barcodes start with 2 and are valid', () {
      final code = Ean.inStore(42);
      expect(code, startsWith('2'));
      expect(code.length, 13);
      expect(Ean.isValid(code), isTrue);
      expect(Ean.inStore(43), isNot(code));
    });
  });

  group('barcode command', () {
    test('EAN-13 sends 12 digits (printer adds the check digit)', () {
      final bytes = (EscPosBuilder()..barcode('4006381333931')).build();
      expect(
        containsSequence(bytes, [
          0x1D,
          0x6B,
          67,
          12,
          ...'400638133393'.codeUnits,
        ]),
        isTrue,
      );
    });

    test('anything else uses Code 128 set B', () {
      final bytes = (EscPosBuilder()..barcode('SKU-7')).build();
      expect(
        containsSequence(bytes, [
          0x1D,
          0x6B,
          73,
          7,
          0x7B,
          0x42,
          ...'SKU-7'.codeUnits,
        ]),
        isTrue,
      );
    });
  });

  group('LabelFormatter', () {
    const item = Item(
      name: 'Haldiram Aloo Bhujia Spicy Namkeen 400g Family Pack',
      salePrice: Money.rupees(95),
      mrp: Money.rupees(110),
      barcode: '4006381333931',
    );

    test('lines fit the paper; MRP shown when higher than price', () {
      final lines = const LabelFormatter(width: 32).textLines(
        item,
        const LabelOptions(
          shopName: 'Sharma Kirana Store and General Merchants',
        ),
      );
      expect(lines.every((l) => l.length <= 32), isTrue, reason: '$lines');
      expect(lines.first, 'Sharma Kirana Store and General ');
      expect(lines.last, 'MRP Rs.110.00  Now Rs.95.00');
      expect(lines.length, 4); // shop, 2 name lines, price
    });

    test('prints each copy with its barcode', () {
      final bytes = const LabelFormatter(
        width: 32,
      ).bytes([(item: item, copies: 3)], const LabelOptions(showPrice: false));
      var count = 0;
      for (var i = 0; i + 2 < bytes.length; i++) {
        if (bytes[i] == 0x1D && bytes[i + 1] == 0x6B && bytes[i + 2] == 67) {
          count++;
        }
      }
      expect(count, 3);
    });
  });

  testWidgets('labels page: create a barcode, choose copies, print', (
    tester,
  ) async {
    final h = TestHarness(
      shop: testShop,
      settings: const AppSettingsData(printerAddress: 'AA:BB'),
    );
    final loose = await h.items.save(
      const Item(name: 'Rice (loose)', salePrice: Money.rupees(60)),
    );
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('itemsTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('labelsButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create barcode'));
    await tester.pumpAndSettle();
    expect((await h.items.byId(loose.id!))!.barcode, Ean.inStore(loose.id!));

    await tester.tap(find.byKey(Key('labelPlus-${loose.id}')));
    await tester.tap(find.byKey(Key('labelPlus-${loose.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Print 2 labels'), findsOneWidget);
    await tester.tap(find.byKey(const Key('printLabelsButton')));
    await tester.pumpAndSettle();

    expect(h.transport.written, hasLength(1));
    expect(find.text('Printed'), findsOneWidget);
  });
}
