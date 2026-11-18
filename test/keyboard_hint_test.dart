import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/keyboard/keyboard_hint.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

class FakeKeyboard implements KeyboardStatus {
  FakeKeyboard({required this.blocked});

  bool blocked;
  int opened = 0;

  @override
  Future<bool> softKeyboardBlocked() async => blocked;

  @override
  Future<void> openSettings() async => opened++;
}

Future<void> pumpHint(WidgetTester tester, KeyboardStatus status) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: KeyboardHint(status: status)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a fix when the scanner hides the keyboard', (
    tester,
  ) async {
    final status = FakeKeyboard(blocked: true);
    await pumpHint(tester, status);
    expect(find.byKey(const Key('keyboardHint')), findsOneWidget);
    await tester.tap(find.text('Turn on'));
    expect(status.opened, 1);

    // Back from settings with it turned on: the hint goes away.
    status.blocked = false;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('keyboardHint')), findsNothing);
  });

  testWidgets('says nothing when typing works', (tester) async {
    await pumpHint(tester, FakeKeyboard(blocked: false));
    expect(find.byKey(const Key('keyboardHint')), findsNothing);
  });
}
