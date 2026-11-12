import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/domain/item.dart';

import 'helpers/fakes.dart';

Future<void> scan(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const Key('billingSearchField')), code);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> scrollForm(WidgetTester tester, Key key) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.byKey(key),
    300,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('itemForm')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
}

/// An item with stock tracking, saved and stocked like the app would.
Future<Item> stocked(
  TestHarness h, {
  required int stock,
  int? lowStock,
  String? altUnit,
  int? altFactor,
}) async {
  final item = await h.items.save(
    Item(
      name: 'Maggi',
      barcode: '8901058000290',
      salePrice: const Money.rupees(14),
      trackStock: true,
      lowStock: lowStock == null ? null : Quantity.whole(lowStock),
      altUnit: altUnit,
      altUnitFactor: altFactor == null ? null : Quantity.whole(altFactor),
      altUnitPrice: altFactor == null ? null : const Money.rupees(150),
    ),
  );
  await h.inventory.addStock(item.id!, Quantity.whole(stock), opening: true);
  return (await h.items.byId(item.id!))!;
}

void main() {
  testWidgets('new item with stock tracking records opening stock', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('itemsTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addItemButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('itemNameField')), 'Atta 5kg');
    await tester.enterText(find.byKey(const Key('itemPriceField')), '240');
    await scrollForm(tester, const Key('trackStockSwitch'));
    await tester.tap(find.byKey(const Key('trackStockSwitch')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('openingStockField')), '12');
    await tester.enterText(find.byKey(const Key('lowStockField')), '3');
    await scrollForm(tester, const Key('saveItemButton'));
    await tester.tap(find.byKey(const Key('saveItemButton')));
    await tester.pumpAndSettle();

    final atta = h.items.all.single;
    expect(atta.trackStock, isTrue);
    expect(atta.stock, const Quantity.whole(12));
    expect(atta.lowStock, const Quantity.whole(3));
    expect(h.inventory.movements.single.type, MovementType.opening);
    expect(find.text('Stock: 12 pcs'), findsOneWidget); // in the list
  });

  testWidgets('billing warns when the bill needs more than is in stock', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await stocked(h, stock: 2);
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();

    await scan(tester, '8901058000290');
    await scan(tester, '8901058000290');
    expect(find.byKey(const Key('shortageWarning')), findsNothing);
    await scan(tester, '8901058000290');
    expect(find.text('Only 2 pcs in stock'), findsOneWidget);
  });

  testWidgets('a sale that crosses the low-stock level raises an alert', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await stocked(h, stock: 6, lowStock: 5);
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();

    await scan(tester, '8901058000290');
    await scan(tester, '8901058000290');
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();

    expect(h.alerts.alerted.single.single.name, 'Maggi');
    expect(h.alerts.alerted.single.single.stock, const Quantity.whole(4));
    expect(h.items.all.single.stock, const Quantity.whole(4));

    // A second sale below the level doesn't alert again.
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, '8901058000290');
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    expect(h.alerts.alerted, hasLength(1));
  });

  testWidgets('a line can switch to the second unit (box of 12)', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await stocked(h, stock: 100, altUnit: 'box', altFactor: 12);
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, '8901058000290');

    await tester.tap(find.text('Maggi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('box (12 pcs)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('lineApplyButton')));
    await tester.pumpAndSettle();
    expect(find.text('1 box × ₹150.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    expect(
      h.bills.all.single.lines.single.unitFactor,
      const Quantity.whole(12),
    );
    expect(h.items.all.single.stock, const Quantity.whole(88));
  });

  testWidgets('stock page: adjust to a counted figure', (tester) async {
    final h = TestHarness(shop: testShop);
    final maggi = await stocked(h, stock: 10, lowStock: 3);
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('itemsTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maggi'));
    await tester.pumpAndSettle();
    await scrollForm(tester, const Key('manageStockTile'));
    await tester.tap(find.byKey(const Key('manageStockTile')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('currentStock'))).data,
      '10 pcs',
    );

    await tester.tap(find.byKey(const Key('adjustStockButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('stockQtyField')), '7');
    await tester.tap(find.byKey(const Key('saveStockButton')));
    await tester.pumpAndSettle();

    expect((await h.items.byId(maggi.id!))!.stock, const Quantity.whole(7));
    expect(find.text('Adjusted'), findsOneWidget);
    expect(find.text('-3 pcs'), findsOneWidget);
  });

  testWidgets('Home stock tile counts low-stock items', (tester) async {
    final h = TestHarness(shop: testShop);
    await stocked(h, stock: 2, lowStock: 5);
    await h.pump(tester);
    expect(find.text('1 needs attention'), findsOneWidget);
    await tester.tap(find.byKey(const Key('stockTile')));
    await tester.pumpAndSettle();
    expect(find.text('Maggi'), findsOneWidget);
  });
}
