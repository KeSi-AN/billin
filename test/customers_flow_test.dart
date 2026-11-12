import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/customers/domain/party.dart';

import 'helpers/fakes.dart';

void main() {
  testWidgets('add a customer from contacts with an opening due', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    h.contacts.next = (name: 'Ravi Kumar', phone: '+91 98765-43210');
    await h.pump(tester);
    expect(find.text('No dues'), findsOneWidget); // Home tile

    await tester.tap(find.byKey(const Key('customersTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addCustomerButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pickContactButton')));
    await tester.pumpAndSettle();
    expect(find.text('Ravi Kumar'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('openingDueField')), '250');
    await tester.ensureVisible(find.byKey(const Key('saveCustomerButton')));
    await tester.tap(find.byKey(const Key('saveCustomerButton')));
    await tester.pumpAndSettle();

    final ravi = h.parties.all.single;
    expect(ravi.phone, '9876543210');
    expect(ravi.balance, const Money.rupees(250));
    expect(find.text('Due ₹250.00'), findsOneWidget); // in the list
    expect(
      tester.widget<Text>(find.byKey(const Key('totalDue'))).data,
      '₹250.00',
    );
  });

  testWidgets('customer page: receive part payment, remind, statement', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    final ravi = await h.parties.save(
      const Party(name: 'Ravi', phone: '9876543210'),
      openingDue: const Money.rupees(300),
    );
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('customersTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ravi'));
    await tester.pumpAndSettle();
    expect(find.text('Opening due'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remindButton')));
    await tester.tap(find.byKey(const Key('statementButton')));
    await tester.pumpAndSettle();
    expect(h.customerActions.reminded.single.id, ravi.id);
    expect(h.customerActions.statements.single.id, ravi.id);

    await tester.tap(find.byKey(const Key('receivePaymentButton')));
    await tester.pumpAndSettle();
    // Prefilled with the full due; change to a part payment by UPI.
    expect(find.text('300'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('paymentAmountField')), '120');
    await tester.tap(find.text('UPI'));
    await tester.tap(find.byKey(const Key('savePaymentButton')));
    await tester.pumpAndSettle();

    expect((await h.parties.byId(ravi.id!))!.balance, const Money.rupees(180));
    expect(h.parties.entries.first.paymentMode, PaymentMode.upi);
    expect(
      tester
          .widget<Text>(
            find.descendant(
              of: find.byKey(const Key('customerBalance')),
              matching: find.byType(Text),
            ),
          )
          .data,
      'Due ₹180.00',
    );
    expect(find.text('Payment received'), findsOneWidget);
  });

  testWidgets('remind is off without a phone', (tester) async {
    final h = TestHarness(shop: testShop);
    await h.parties.save(
      const Party(name: 'No phone'),
      openingDue: const Money.rupees(5),
    );
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('customersTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No phone'));
    await tester.pumpAndSettle();
    final remind = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Remind'),
        matching: find.byWidgetPredicate((w) => w is OutlinedButton),
      ),
    );
    expect(remind.onPressed, isNull);
  });

  testWidgets('"With dues" filter and Home due total', (tester) async {
    final h = TestHarness(shop: testShop);
    await h.parties.save(
      const Party(name: 'Asha'),
      openingDue: const Money.rupees(40),
    );
    await h.parties.save(const Party(name: 'Bina'));
    await h.pump(tester);
    expect(find.text('₹40.00 due'), findsOneWidget);
    await tester.tap(find.byKey(const Key('customersTile')));
    await tester.pumpAndSettle();
    expect(find.text('Bina'), findsOneWidget);
    await tester.tap(find.byKey(const Key('withDuesChip')));
    await tester.pumpAndSettle();
    expect(find.text('Bina'), findsNothing);
    expect(find.text('Asha'), findsOneWidget);
  });
}
