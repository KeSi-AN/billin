import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/items/domain/item.dart';

import 'helpers/fakes.dart';

Future<TestHarness> harnessWithItems() async {
  final h = TestHarness(shop: testShop);
  await h.items.save(
    const Item(
      name: 'Parle-G 100g',
      salePrice: Money.rupees(10),
      barcode: '8901719110054',
      taxRate: TaxRate(500),
    ),
  );
  await h.items.save(
    const Item(name: 'Rice (loose)', salePrice: Money.rupees(60), unit: 'kg'),
  );
  return h;
}

/// Scrolls the item form until the widget with [key] is built, then
/// centres it and lets the scroll settle so taps land on it.
Future<void> scrollTo(WidgetTester tester, Key key, {bool down = true}) async {
  // Close the keyboard first: a focused field scrolls itself back into view.
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.byKey(key),
    down ? 300 : -300,
    // The page's list, not a text field's own internal scroller.
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

/// What a Bluetooth scanner does: type the code, press Enter.
Future<void> scan(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const Key('billingSearchField')), code);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('full sale: scan, search, quick item, checkout, print, share', (
    tester,
  ) async {
    final h = await harnessWithItems();
    await h.pump(tester);

    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    expect(find.text('Scan a barcode or search to add items'), findsOneWidget);

    // Scanning the same barcode twice → one line, quantity 2.
    await scan(tester, '8901719110054');
    await scan(tester, '8901719110054');
    expect(find.text('Parle-G 100g'), findsOneWidget);
    expect(find.text('2 pcs × ₹10.00'), findsOneWidget);

    // Unknown barcode offers to create the item.
    await scan(tester, '000111');
    expect(find.text('No item with barcode 000111'), findsOneWidget);
    expect(find.text('Create item'), findsOneWidget);

    // Search by name and pick the suggestion.
    await tester.enterText(find.byKey(const Key('billingSearchField')), 'rice');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rice (loose)'));
    await tester.pumpAndSettle();

    // Quick (unsaved) item.
    await tester.tap(find.byKey(const Key('quickItemButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('quickPriceField')), '25');
    await tester.tap(find.byKey(const Key('quickAddButton')));
    await tester.pumpAndSettle();

    // 2 × 10 + 60 + 25 = 105
    expect(find.text('Checkout · ₹105.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('billDiscountField')), '5');
    await tester.tap(find.text('UPI'));
    await tester.pumpAndSettle();
    expect(find.text('Save bill · ₹100.00'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();

    // Saved bill screen.
    expect(find.text('Bill saved'), findsOneWidget);
    expect(find.text('INV/26-27/0001'), findsOneWidget);
    final bill = h.bills.all.single;
    expect(bill.grandTotal, const Money.rupees(100));
    expect(bill.paymentMode, PaymentMode.upi);
    expect(bill.lines.map((l) => l.name), [
      'Parle-G 100g',
      'Rice (loose)',
      'Item',
    ]);

    await tester.tap(find.byKey(const Key('printBillButton')));
    await tester.tap(find.byKey(const Key('shareBillButton')));
    await tester.pumpAndSettle();
    expect(h.actions.printed.single.id, bill.id);
    expect(h.actions.shared.single.id, bill.id);

    // "New bill" starts an empty bill.
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    expect(find.text('Scan a barcode or search to add items'), findsOneWidget);
  });

  testWidgets('stepper changes quantity and removes at zero', (tester) async {
    final h = await harnessWithItems();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();

    await scan(tester, '8901719110054');
    await tester.tap(find.byKey(const Key('qtyPlus')));
    await tester.pumpAndSettle();
    expect(find.text('Checkout · ₹20.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('qtyMinus')));
    await tester.tap(find.byKey(const Key('qtyMinus')));
    await tester.pumpAndSettle();
    expect(find.text('Scan a barcode or search to add items'), findsOneWidget);
  });

  testWidgets('credit sale: needs a customer, can add one, pays part now', (
    tester,
  ) async {
    final h = await harnessWithItems();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, '8901719110054'); // ₹10
    await tester.tap(find.byKey(const Key('qtyPlus')));
    await tester.pumpAndSettle(); // ₹20

    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Credit'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    expect(find.text('Choose a customer for a credit sale'), findsOneWidget);
    expect(h.bills.all, isEmpty);

    // Add a new customer from the picker, straight from checkout.
    await tester.ensureVisible(find.byKey(const Key('pickCustomerTile')));
    await tester.tap(find.byKey(const Key('pickCustomerTile')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('customerPickerSearch')),
      'Ravi',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pickerNewCustomer')));
    await tester.pumpAndSettle();
    expect(find.text('New customer'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('customerPhoneField')),
      '9876543210',
    );
    await tester.tap(find.byKey(const Key('saveCustomerButton')));
    await tester.pumpAndSettle();
    expect(find.text('Ravi'), findsOneWidget); // chosen in checkout

    await tester.enterText(find.byKey(const Key('paidNowField')), '5');
    await tester.pumpAndSettle();
    expect(find.text('₹15.00 will be added to dues'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();

    final bill = h.bills.all.single;
    expect(bill.customerName, 'Ravi');
    expect(bill.due, const Money.rupees(15));
    expect(h.parties.all.single.balance, const Money.rupees(15));
    expect(find.text('Due'), findsOneWidget); // bill page shows the split
  });

  testWidgets('sales list totals the day and drops cancelled bills', (
    tester,
  ) async {
    final h = await harnessWithItems();
    h.bills.clock = DateTime.now;
    for (final price in [100, 250]) {
      await h.bills.create(
        BillDraft(
          lines: [DraftLine(name: 'x', unitPrice: Money.rupees(price))],
        ),
      );
    }
    await h.pump(tester);
    expect(
      tester.widget<Text>(find.byKey(const Key('todayTotal'))).data,
      '₹350.00',
    ); // Home "Today"

    await tester.tap(find.byKey(const Key('salesTile')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('salesTotal'))).data,
      '₹350.00',
    );

    // Open the ₹100 bill and cancel it.
    await tester.tap(find.text('INV/26-27/0001'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel bill').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cancel bill'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cancelled'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('salesTotal'))).data,
      '₹250.00',
    );
  });

  testWidgets('add an item, then a duplicate barcode is refused', (
    tester,
  ) async {
    final h = await harnessWithItems();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('itemsTile')));
    await tester.pumpAndSettle();
    expect(find.text('Parle-G 100g'), findsOneWidget);

    await tester.tap(find.byKey(const Key('addItemButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('itemNameField')), 'Maggi');
    await tester.enterText(find.byKey(const Key('itemPriceField')), '14');
    await tester.enterText(
      find.byKey(const Key('itemBarcodeField')),
      '8901719110054',
    );
    await scrollTo(tester, const Key('saveItemButton'));
    await tester.tap(find.byKey(const Key('saveItemButton')));
    await tester.pumpAndSettle();
    // The form scrolls back up to the barcode field showing the error.
    expect(find.text('Barcode already used by "Parle-G 100g"'), findsOneWidget);

    await scrollTo(tester, const Key('itemBarcodeField'), down: false);
    await tester.enterText(
      find.byKey(const Key('itemBarcodeField')),
      '8901058000290',
    );
    await scrollTo(tester, const Key('saveItemButton'));
    await tester.tap(find.byKey(const Key('saveItemButton')));
    await tester.pumpAndSettle();
    expect(find.text('Maggi'), findsOneWidget);
    expect(h.items.all.map((i) => i.name), contains('Maggi'));
  });
}
