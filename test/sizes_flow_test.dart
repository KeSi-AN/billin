import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/items/domain/item.dart';

import 'helpers/fakes.dart';

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

    expect(find.text('M · L · XL'), findsOneWidget);
    await tester.tap(find.byKey(Key('labelPlus-${kurti.id}-M')));
    await tester.tap(find.byKey(Key('labelPlus-${kurti.id}-M')));
    await tester.tap(find.byKey(Key('labelPlus-${kurti.id}-XL')));
    await tester.pumpAndSettle();
    expect(find.text('Print 3 labels'), findsOneWidget);
  });
}
