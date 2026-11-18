import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/printing/domain/receipt_template.dart';

import 'helpers/fakes.dart';

void main() {
  testWidgets('edit the bill template: changes save and show in preview', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('billTemplateTile')));
    await tester.pumpAndSettle();
    expect(find.text('27AAPFU0939F1ZV'), findsOneWidget); // GSTIN shown

    await tester.tap(find.byKey(const Key('tpl_phone')));
    await tester.pump(const Duration(milliseconds: 500)); // autosave
    expect((await h.settings.load()).receiptTemplate.showPhone, isFalse);

    await tester.scrollUntilVisible(
      find.byKey(const Key('tpl_qrMode')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('All bills'));
    await tester.pump(const Duration(milliseconds: 500));
    expect((await h.settings.load()).receiptTemplate.qrMode, QrMode.always);
    await tester.enterText(find.byKey(const Key('tpl_upiId')), 'sharma@okaxis');
    await tester.scrollUntilVisible(
      find.byKey(const Key('tpl_footer')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byKey(const Key('tpl_footer')), 'Shukriya!');
    await tester.pump(const Duration(milliseconds: 500));
    final s = await h.settings.load();
    expect(s.upiId, 'sharma@okaxis');
    expect(s.receiptTemplate.footer, 'Shukriya!');

    await tester.tap(find.byKey(const Key('tplPreviewButton')));
    await tester.pumpAndSettle();
    final preview = find.byKey(const Key('receiptPreview'));
    expect(preview, findsOneWidget);
    expect(
      find.descendant(of: preview, matching: find.text('Shukriya!')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: preview, matching: find.text('9876543210')),
      findsNothing,
    );
  });
}
