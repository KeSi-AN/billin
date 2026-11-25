import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/percent.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/items/domain/item.dart';

import 'helpers/fakes.dart';

Future<TestHarness> harness() async {
  final h = TestHarness(shop: testShop);
  await h.items.save(
    const Item(
      name: 'kurti set',
      salePrice: Money.rupees(1555),
      barcode: 'DN84375',
    ),
  );
  await h.items.save(
    const Item(name: 'SAREE', salePrice: Money.rupees(775), barcode: 'A029'),
  );
  return h;
}

Future<void> scan(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const Key('billingSearchField')), code);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

void main() {
  group('percentages', () {
    test('parse and format', () {
      expect(parsePercentBp('10'), 1000);
      expect(parsePercentBp('12.5'), 1250);
      expect(parsePercentBp('0.75'), 75);
      expect(parsePercentBp('100'), 10000);
      expect(parsePercentBp('101'), isNull);
      expect(parsePercentBp('abc'), isNull);
      expect(formatPercentBp(1250), '12.5%');
      expect(formatPercentBp(1000), '10%');
      expect(percentInput(75), '0.75');
    });

    test('a line % discount follows quantity changes', () {
      const line = DraftLine(
        name: 'kurti set',
        unitPrice: Money.rupees(1555),
        discountBp: 1000,
      );
      final one = BillCalculator.calculate([line.input]);
      expect(one.lines.single.discount, const Money.paise(15550));
      final two = BillCalculator.calculate([
        line.copyWith(quantity: const Quantity.whole(2)).input,
      ]);
      expect(two.lines.single.discount, const Money.rupees(311));
      // A % discount on a GST-inclusive line still splits correctly.
      final gst = BillCalculator.calculate([
        const DraftLine(
          name: 'x',
          unitPrice: Money.rupees(105),
          taxRate: TaxRate(500),
          discountBp: 2000,
        ).input,
      ]);
      expect(gst.grandTotal, const Money.rupees(84));
    });

    test('switching a line between ₹ and % replaces the discount', () {
      const line = DraftLine(
        name: 'x',
        unitPrice: Money.rupees(100),
        discount: Money.rupees(5),
      );
      final pct = line.copyWith(discountBp: 1000);
      expect((pct.discount, pct.discountBp), (Money.zero, 1000));
      final back = pct.copyWith(discount: const Money.rupees(7));
      expect((back.discount, back.discountBp), (const Money.rupees(7), null));
      expect(back.copyWith(quantity: Quantity.one).discount, back.discount);
    });
  });

  testWidgets('item % discount, bill % discount, walk-in WhatsApp bill', (
    tester,
  ) async {
    final h = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, 'DN84375');
    await scan(tester, 'A029');

    // 10% off the kurti set.
    await tester.tap(find.text('kurti set'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('lineDiscountField')),
        matching: find.text('%'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('lineDiscountField')), '10');
    await tester.tap(find.byKey(const Key('lineApplyButton')));
    await tester.pumpAndSettle();
    expect(find.text('−10% off'), findsOneWidget);

    // Raising the quantity keeps it at 10%: 2 × 1555 − 311 + 775 = 3574.
    await tester.tap(find.byKey(const Key('qtyPlus')).first);
    await tester.pumpAndSettle();
    expect(find.text('Checkout · ₹3,574.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('billDiscountField')),
        matching: find.text('%'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('billDiscountField')), '5');
    await tester.pumpAndSettle();
    // 5% of 3574 = 178.70; round-off brings the total to a whole rupee.
    expect(find.text('= ₹178.70 off'), findsOneWidget);

    // A new customer: the name in the one box, then the mobile.
    await tester.ensureVisible(find.byKey(const Key('customerSearchField')));
    await tester.enterText(
      find.byKey(const Key('customerSearchField')),
      'Asha',
    );
    await tester.pumpAndSettle();
    expect(find.text('New customer: saved with this bill.'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('newCustomerOtherField')),
      '98765 43210',
    );
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();

    final bill = h.bills.all.single;
    expect(bill.billDiscount, const Money.paise(17870));
    expect(bill.lines.first.discount, const Money.rupees(311));
    expect(bill.customerName, 'Asha');
    expect(bill.customerPhone, '9876543210');
    // Saved as a customer, so next time typing either finds her.
    final asha = (await h.parties.watchAll().first).single;
    expect((asha.name, asha.phone), ('Asha', '9876543210'));
    expect(bill.partyId, asha.id);
    // Right after saving: one tap sends it on WhatsApp.
    expect(find.text('Send bill to Asha on WhatsApp'), findsOneWidget);

    await tester.tap(find.byKey(const Key('whatsappBillButton')));
    await tester.pumpAndSettle();
    expect(h.actions.whatsapped.single.id, bill.id);
  });

  testWidgets('a wrong walk-in mobile is caught before saving', (tester) async {
    final h = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, 'A029');
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('customerSearchField')));
    await tester.enterText(
      find.byKey(const Key('customerSearchField')),
      'Asha',
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('newCustomerOtherField')),
      '12345',
    );
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    expect(h.bills.all, isEmpty);
    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
  });

  testWidgets('typing part of a number finds the customer to pick', (
    tester,
  ) async {
    final h = await harness();
    final ravi = await h.parties.save(
      const Party(name: 'Ravi Kumar', phone: '9123456780'),
    );
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, 'A029');
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('customerSearchField')));
    await tester.enterText(
      find.byKey(const Key('customerSearchField')),
      '45678',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('customerMatch-${ravi.id}')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chosenCustomerTile')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    final bill = h.bills.all.single;
    expect(bill.partyId, ravi.id);
    expect(bill.customerPhone, '9123456780');
    expect(await h.parties.watchAll().first, hasLength(1));
  });

  testWidgets('just a number makes a new customer named by it', (tester) async {
    final h = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('newBillButton')));
    await tester.pumpAndSettle();
    await scan(tester, 'A029');
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('customerSearchField')));
    await tester.enterText(
      find.byKey(const Key('customerSearchField')),
      '98858 19674',
    );
    await tester.pumpAndSettle();
    // A number was typed, so the second box asks for the name.
    expect(find.text('Name (optional)'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('saveBillButton')));
    await tester.tap(find.byKey(const Key('saveBillButton')));
    await tester.pumpAndSettle();
    final bill = h.bills.all.single;
    expect(bill.customerPhone, '9885819674');
    final party = (await h.parties.watchAll().first).single;
    expect(party.phone, '9885819674');
  });
}
