import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

import 'helpers/fakes.dart';

void main() {
  testWidgets('first launch: setup is required, then lands on Home', (
    tester,
  ) async {
    final h = TestHarness();
    final repo = h.shopProfiles;
    await h.pump(tester);

    expect(find.text('Set up your shop'), findsOneWidget);

    // Saving empty shows field errors and does not save.
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    expect(find.text('Enter your shop name'), findsOneWidget);
    expect(find.text('Select your state'), findsOneWidget);
    expect(repo.current, isNull);

    // A valid GSTIN fills in the state automatically.
    final gstin = '29ABCDE1234F1Z${Gstin.checkCharacter('29ABCDE1234F1Z')}';
    await tester.enterText(find.byKey(const Key('nameField')), 'Sharma Kirana');
    await tester.enterText(find.byKey(const Key('gstinField')), gstin);
    await tester.pumpAndSettle();
    expect(find.text('Karnataka'), findsOneWidget);
    expect(find.text('State set from GSTIN'), findsOneWidget);

    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(repo.current?.name, 'Sharma Kirana');
    expect(repo.current?.stateCode, '29');
    // Router moved to Home on its own.
    expect(find.text('Sharma Kirana'), findsWidgets);
    expect(find.text('GSTIN: $gstin'), findsOneWidget);
  });

  testWidgets('rejects a bad phone and a mistyped GSTIN', (tester) async {
    final h = TestHarness();
    final repo = h.shopProfiles;
    await h.pump(tester);

    await tester.enterText(find.byKey(const Key('nameField')), 'A');
    await tester.enterText(find.byKey(const Key('phoneField')), '12345');
    await tester.enterText(
      find.byKey(const Key('gstinField')),
      '29ABCDE1234F1Z0',
    );
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
    expect(
      find.text("This GSTIN isn't valid. Check for typos."),
      findsOneWidget,
    );
    expect(repo.current, isNull);
  });

  testWidgets('existing shop opens Home and can be edited', (tester) async {
    final h = TestHarness(
      shop: const ShopProfile(name: 'Old Name', stateCode: '27', city: 'Pune'),
    );
    final repo = h.shopProfiles;
    await h.pump(tester);

    expect(find.text('Not GST registered'), findsOneWidget);
    await tester.tap(find.byKey(const Key('editShopButton')));
    await tester.pumpAndSettle();
    expect(find.text('Shop profile'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('nameField')), 'New Name');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(repo.current?.name, 'New Name');
    expect(repo.current?.city, 'Pune');
    // Back on Home, showing the new name.
    expect(find.byKey(const Key('editShopButton')), findsOneWidget);
    expect(find.text('New Name'), findsWidgets);
  });
}
