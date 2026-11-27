import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/domain/item.dart';

import 'helpers/fakes.dart';
import 'inventory_flow_test.dart' show scrollForm;

/// A sized kurti (M: 3 left, L: sold out, XL dearer, with its own code)
/// and a free-size saree.
Future<(TestHarness, Item)> harness() async {
  final h = TestHarness(shop: testShop);
  final kurti = await h.items.save(
    const Item(
      name: 'Kurti set',
      salePrice: Money.rupees(1835),
      barcode: 'K100',
      trackStock: true,
    ),
  );
  final sizes = await h.items.saveSizes(kurti.id!, const [
    ItemSize(size: 'M', barcode: 'K100M'),
    ItemSize(size: 'L', barcode: 'K100L'),
    ItemSize(size: 'XL', price: Money.rupees(1935), barcode: 'K100XL'),
  ]);
  h.items.setSizeStock(kurti.id!, sizes.first.id!, const Quantity.whole(3));
  await h.items.save(
    const Item(name: 'Saree', salePrice: Money.rupees(565), barcode: 'A029'),
  );
  return (h, kurti);
}

Future<void> scan(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const Key('billingSearchField')), code);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('billing a sized item asks the size; a size code adds it', (
    tester,
  ) async {
    final (h, _) = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();

    // The item's own code: which size? (with what's left)
    await scan(tester, 'K100');
    expect(find.text('Kurti set: which size?'), findsOneWidget);
    expect(find.text('3 left'), findsOneWidget);
    expect(find.text('Sold out'), findsNWidgets(2));
    expect(find.text('₹1,935.00'), findsOneWidget); // XL's own price
    await tester.tap(find.byKey(const Key('pickSize-M')));
    await tester.pumpAndSettle();
    expect(find.text('Kurti set (M)'), findsOneWidget);

    // A size's own code goes straight in, at that size's price.
    await scan(tester, 'K100XL');
    expect(find.text('Kurti set: which size?'), findsNothing);
    expect(find.text('Kurti set (XL)'), findsOneWidget);

    // Free size works as before.
    await scan(tester, 'A029');
    expect(find.text('Saree'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    final bill = h.bills.all.single;
    expect(
      [for (final l in bill.lines) l.name],
      ['Kurti set (M)', 'Kurti set (XL)', 'Saree'],
    );
    expect(bill.grandTotal, const Money.rupees(1835 + 1935 + 565));
  });

  testWidgets('labels: a sized item gets one row (and label) per size', (
    tester,
  ) async {
    final (h, kurti) = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('itemsTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('labelsButton')));
    await tester.pumpAndSettle();

    expect(find.text('M, L, XL'), findsOneWidget);
    await tester.tap(find.byKey(Key('labelPlus-${kurti.id}-M')));
    await tester.tap(find.byKey(Key('labelPlus-${kurti.id}-M')));
    await tester.tap(find.byKey(Key('labelPlus-${kurti.id}-XL')));
    await tester.pumpAndSettle();
    expect(find.text('Print 3 labels'), findsOneWidget);
  });

  testWidgets(
    'a new product: pick colours and sizes, stock and price per version',
    (tester) async {
      tester.view
        ..physicalSize = const Size(1080, 2400)
        ..devicePixelRatio = 2.75;
      addTearDown(tester.view.reset);
      final h = TestHarness(shop: testShop);
      await h.pump(tester);
      await tester.tap(find.byKey(const Key('itemsTile')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('addItemButton')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('itemNameField')),
        'Floral short kurti',
      );
      await tester.enterText(find.byKey(const Key('itemPriceField')), '899');
      await scrollForm(tester, const Key('trackStockSwitch'));
      await tester.tap(find.byKey(const Key('trackStockSwitch')));
      await tester.pumpAndSettle();

      // Colours and a size set make the grid.
      await scrollForm(tester, const Key('colour-Pink'));
      await tester.tap(find.byKey(const Key('colour-Pink')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('colour-Navy')));
      await tester.pumpAndSettle();
      await scrollForm(tester, const Key('sizePreset-S – XXL'));
      await tester.tap(find.byKey(const Key('sizePreset-S – XXL')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('openingStockField')), findsNothing);

      await scrollForm(tester, const Key('versionStock-Pink · M'));
      await tester.enterText(
        find.byKey(const Key('versionStock-Pink · M')),
        '2',
      );
      await tester.enterText(
        find.byKey(const Key('versionStock-Navy · L')),
        '3',
      );

      // XXL costs more, in every colour: set once on its heading.
      await scrollForm(tester, const Key('sizeHeading-XXL'));
      await tester.tap(find.byKey(const Key('sizeHeading-XXL')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('versionPriceField')), '999');
      await tester.tap(find.byKey(const Key('versionPriceSave')));
      await tester.pumpAndSettle();

      await scrollForm(tester, const Key('itemPatternField'));
      await tester.enterText(
        find.byKey(const Key('itemPatternField')),
        'Floral block print',
      );
      await scrollForm(tester, const Key('saveItemButton'));
      await tester.tap(find.byKey(const Key('saveItemButton')));
      await tester.pumpAndSettle();

      final kurti = h.items.all.single;
      // The item's total is its versions' stock.
      expect((await h.items.byId(kurti.id!))!.stock, const Quantity.whole(5));
      expect(kurti.pattern, 'Floral block print');
      expect([for (final c in kurti.colours) c.name], ['Pink', 'Navy']);
      final versions = await h.items.sizesOf(kurti.id!);
      expect(versions, hasLength(10));
      expect(versions.first.label, 'Pink · S');
      ItemSize v(String label) => versions.firstWhere((x) => x.label == label);
      expect(v('Pink · M').stock, const Quantity.whole(2));
      expect(v('Navy · L').stock, const Quantity.whole(3));
      expect(v('Pink · XXL').price, const Money.rupees(999));
      expect(v('Navy · XXL').price, const Money.rupees(999));
      expect(v('Navy · M').price, isNull); // the product's price
      expect(versions.every((x) => x.barcode != null), isTrue);
      expect(v('Pink · S').colourHex, isNotNull);
    },
  );

  testWidgets('billing a colour + size product: colour first, then size', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    final kurti = await h.items.save(
      const Item(
        name: 'Floral kurti',
        salePrice: Money.rupees(899),
        barcode: 'F1',
        trackStock: true,
      ),
    );
    final versions = await h.items.saveSizes(kurti.id!, const [
      ItemSize(colour: 'Pink', colourHex: '#e91e63', size: 'M'),
      ItemSize(colour: 'Pink', colourHex: '#e91e63', size: 'L'),
      ItemSize(colour: 'Navy', colourHex: '#1a237e', size: 'M'),
    ]);
    h.items.setSizeStock(kurti.id!, versions[1].id!, const Quantity.whole(2));
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();

    await scan(tester, 'F1');
    expect(find.text('Pink · 2'), findsOneWidget); // what's left per colour
    expect(find.text('Navy · 0'), findsOneWidget);
    expect(find.text('Pick the colour.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pickColour-Pink')));
    await tester.pumpAndSettle();
    expect(find.text('2 left'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pickSize-Pink · L')));
    await tester.pumpAndSettle();
    expect(find.text('Floral kurti (Pink · L)'), findsOneWidget);
  });
}
