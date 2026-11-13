import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/backup/domain/backup.dart';
import 'package:shop_app/features/backup/presentation/backup_page.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/domain/business_reports.dart';
import 'package:shop_app/features/reports/presentation/report_page.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

import 'helpers/fakes.dart';

/// Today: cash ₹100 (10 Parle-G), UPI ₹60 (1 kg rice), and ₹120 of rice on
/// credit to Ravi with ₹20 paid at the counter.
Future<TestHarness> todaysTrade() async {
  final h = TestHarness(shop: testShop);
  h.bills.clock = DateTime.now;
  h.parties.clock = DateTime.now;
  final parle = await h.items.save(
    const Item(
      name: 'Parle-G',
      salePrice: Money.rupees(10),
      taxRate: TaxRate(500),
    ),
  );
  final rice = await h.items.save(
    const Item(name: 'Rice', salePrice: Money.rupees(60), unit: 'kg'),
  );
  final ravi = await h.parties.save(const Party(name: 'Ravi'));
  DraftLine line(Item i, int qty) => DraftLine(
    itemId: i.id,
    name: i.name,
    unit: i.unit,
    unitPrice: i.salePrice,
    taxRate: i.taxRate,
    quantity: Quantity.whole(qty),
  );
  await h.bills.create(BillDraft(lines: [line(parle, 10)]));
  await h.bills.create(
    BillDraft(lines: [line(rice, 1)], paymentMode: PaymentMode.upi),
  );
  await h.bills.create(
    BillDraft(
      lines: [line(rice, 2)],
      paymentMode: PaymentMode.credit,
      partyId: ravi.id,
      customerName: 'Ravi',
      paidNow: const Money.rupees(20),
    ),
  );
  return h;
}

String textOf(WidgetTester tester, Key key) =>
    tester.widget<Text>(find.byKey(key)).data!;

void main() {
  backupTests();

  testWidgets('Home: today by payment mode, and top items', (tester) async {
    final h = await todaysTrade();
    await h.pump(tester);

    expect(textOf(tester, const Key('todayTotal')), '₹280.00');
    // Paid at the counter on the credit bill counts as cash.
    expect(find.text('Cash ₹120.00'), findsOneWidget);
    expect(find.text('UPI ₹60.00'), findsOneWidget);
    expect(find.text('Credit ₹100.00'), findsOneWidget);
    expect(find.textContaining('Card'), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('topItemsCard')),
      300,
      scrollable: find.byType(Scrollable).first, // the page, not the grid
    );
    final card = find.byKey(const Key('topItemsCard'));
    expect(
      find.descendant(of: card, matching: find.text('Rice')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('₹180.00')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('10 pcs')),
      findsOneWidget,
    );

    // Tapping it opens the item-wise report.
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('Item-wise sales'), findsWidgets);
  });

  testWidgets('Reports hub → sales report, with a period filter', (
    tester,
  ) async {
    final h = await todaysTrade();
    await h.pump(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('reportsTile')),
      300,
      scrollable: find.byType(Scrollable).first, // the page, not the grid
    );
    await tester.tap(find.byKey(const Key('reportsTile')));
    await tester.pumpAndSettle();
    expect(find.text('GST returns'), findsOneWidget);
    expect(find.text('Day book'), findsOneWidget);

    await tester.tap(find.byKey(const Key('report_sales')));
    await tester.pumpAndSettle();
    expect(textOf(tester, const Key('summary_Bills')), '3');
    expect(textOf(tester, const Key('summary_Net sales')), '₹280.00');

    await tester.tap(find.byKey(const Key('period_yesterday')));
    await tester.pumpAndSettle();
    expect(textOf(tester, const Key('summary_Bills')), '0');
    expect(find.text('Nothing in this period'), findsWidgets);
  });

  testWidgets('day book report exports to Excel and PDF', (tester) async {
    final h = await todaysTrade();
    final shared = <(String, String)>[];
    final tmp = await tester.runAsync(
      () => Directory.systemTemp.createTemp('report_test'),
    );
    addTearDown(() => tmp!.deleteSync(recursive: true));
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ShopProfileRepository>.value(
            value: h.shopProfiles,
          ),
          RepositoryProvider<BillRepository>.value(value: h.bills),
          RepositoryProvider<ReturnsRepository>.value(value: h.returns),
          RepositoryProvider<PurchaseRepository>.value(value: h.purchases),
          RepositoryProvider<ExpenseRepository>.value(value: h.expenses),
          RepositoryProvider<ItemRepository>.value(value: h.items),
          RepositoryProvider<PartyRepository>.value(value: h.parties),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReportPage(
            kind: ReportKind.dayBook,
            tempDir: () async => tmp!,
            loadFonts: () async => const InvoiceFonts(),
            shareFile: (path, text) async => shared.add((path, text)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Cash 100 + UPI 60 + 20 paid on the credit bill (FakeBills doesn't
    // post that as a ledger receipt, so only the bills count here).
    expect(textOf(tester, const Key('summary_Money in')), '₹160.00');

    Future<void> export(Key key) async {
      final before = shared.length;
      await tester.tap(find.byKey(key));
      for (var i = 0; i < 200 && shared.length == before; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }

    await export(const Key('exportExcelButton'));
    await export(const Key('exportPdfButton'));
    expect(shared.map((s) => s.$1.split('.').last), ['xlsx', 'pdf']);
    for (final (path, text) in shared) {
      expect(File(path).lengthSync(), greaterThan(500));
      expect(text, startsWith('Day book · '));
      expect(text, endsWith('Sharma Kirana'));
    }
  });
}

Future<void> pumpBackupPage(
  WidgetTester tester,
  TestHarness h, {
  required Future<Uint8List?> Function() pick,
  required List<String> shared,
}) async {
  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BackupService>.value(value: h.backup),
        RepositoryProvider<BillRepository>.value(value: h.bills),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BackupPage(
          pickFile: pick,
          shareFile: (path, text) async => shared.add(path),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void backupTests() {
  testWidgets('backup now shares the file and updates "last backup"', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop)..backup.last = null;
    final shared = <String>[];
    await pumpBackupPage(tester, h, pick: () async => null, shared: shared);
    expect(find.text('No backup yet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('backupNowButton')));
    await tester.pumpAndSettle();
    expect(shared, ['ShopBackup_1.zip']);
    expect(find.text('Backup ready'), findsOneWidget);
    expect(find.textContaining('Last backup: '), findsOneWidget);
  });

  testWidgets('restore asks first, then replaces the data', (tester) async {
    final h = TestHarness(shop: testShop);
    h.backup.info = BackupInfo(
      createdAt: DateTime(2026, 11, 1, 20),
      schemaVersion: 5,
      shopName: 'Sharma Kirana',
      bills: 412,
      items: 230,
    );
    final file = Uint8List.fromList([1, 2, 3]);
    await pumpBackupPage(tester, h, pick: () async => file, shared: []);

    await tester.tap(find.byKey(const Key('restoreButton')));
    await tester.pumpAndSettle();
    expect(find.text('Replace all data on this phone?'), findsOneWidget);
    expect(find.textContaining('412 bills, 230 items'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(h.backup.restored, isEmpty);

    await tester.tap(find.byKey(const Key('restoreButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();
    expect(h.backup.restored.single, file);
  });

  testWidgets('a file that is not a backup is refused', (tester) async {
    final h = TestHarness(shop: testShop);
    await pumpBackupPage(
      tester,
      h,
      pick: () async => Uint8List.fromList([9]),
      shared: [],
    );
    await tester.tap(find.byKey(const Key('restoreButton')));
    await tester.pumpAndSettle();
    expect(find.text("That file isn't a backup from this app"), findsOneWidget);
    expect(h.backup.restored, isEmpty);
  });

  testWidgets('Home nags once there are bills and no backup', (tester) async {
    final h = await todaysTrade();
    h.backup.last = null;
    await h.pump(tester);
    expect(find.byKey(const Key('backupReminder')), findsOneWidget);
    await tester.tap(find.byKey(const Key('backupReminder')));
    await tester.pumpAndSettle();
    expect(find.text('Backup & restore'), findsOneWidget);

    // A fresh backup makes the reminder go away on the way back.
    h.backup.last = DateTime.now();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('backupReminder')), findsNothing);
  });
}
