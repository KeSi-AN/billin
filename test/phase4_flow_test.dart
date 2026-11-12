import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/presentation/reports_page.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

import 'helpers/fakes.dart';

final supplierGstin = '27ABCDE1234F1Z${Gstin.checkCharacter('27ABCDE1234F1Z')}';

/// A harness whose records are dated now, so month screens show them.
Future<TestHarness> harness() async {
  final h = TestHarness(shop: testShop);
  h.bills.clock = DateTime.now;
  h.purchases.clock = DateTime.now;
  await h.items.save(
    const Item(
      name: 'Parle-G 100g',
      salePrice: Money.rupees(10),
      taxRate: TaxRate(500),
      hsn: '1905',
    ),
  );
  return h;
}

String textOf(WidgetTester tester, Key key) =>
    tester.widget<Text>(find.byKey(key)).data!;

void main() {
  testWidgets('purchase on credit: stock goes up, supplier is owed', (
    tester,
  ) async {
    final h = await harness();
    final supplier = await h.parties.save(
      Party(
        name: 'Gupta Distributors',
        type: PartyType.supplier,
        gstin: supplierGstin,
      ),
    );
    await h.pump(tester);

    await tester.tap(find.byKey(const Key('purchasesTile')));
    await tester.pumpAndSettle();
    expect(find.text('No purchases this month'), findsOneWidget);
    await tester.tap(find.byKey(const Key('addPurchaseButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pickSupplierTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gupta Distributors'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('supplierInvoiceField')),
      'GD-881',
    );

    await tester.tap(find.byKey(const Key('purchaseAddItemButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parle-G 100g'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('purchaseQtyField')), '24');
    await tester.enterText(find.byKey(const Key('purchaseCostField')), '8');
    await tester.tap(find.byKey(const Key('purchaseLineDoneButton')));
    await tester.pumpAndSettle();

    // 24 × ₹8 = ₹192 + 5% GST.
    expect(find.text('₹201.60'), findsWidgets);
    await tester.ensureVisible(find.text('Credit'));
    await tester.tap(find.text('Credit'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('savePurchaseButton')));
    await tester.tap(find.byKey(const Key('savePurchaseButton')));
    await tester.pumpAndSettle();

    final p = h.purchases.all.single;
    expect(p.supplierInvoiceNo, 'GD-881');
    expect(p.taxable, const Money.rupees(192));
    expect(p.tax, const Money.paise(960));
    expect(p.due, const Money.paise(20160));
    expect(h.items.all.single.stock, const Quantity.whole(24));
    expect((await h.parties.byId(supplier.id!))!.balance, p.due);

    // Back on the list.
    expect(textOf(tester, const Key('purchasesTotal')), '₹201.60');
    expect(find.text('Gupta Distributors'), findsOneWidget);

    // Cancel it from the detail page: stock and dues reverse.
    await tester.tap(find.text('Gupta Distributors'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel purchase').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel purchase').last); // confirm
    await tester.pumpAndSettle();
    expect(h.purchases.all.single.isCancelled, isTrue);
    expect(h.items.all.single.stock, Quantity.zero);
    expect((await h.parties.byId(supplier.id!))!.balance, Money.zero);
  });

  testWidgets('suppliers are listed apart from customers', (tester) async {
    final h = await harness();
    await h.parties.save(
      const Party(name: 'Gupta Distributors', type: PartyType.supplier),
      openingDue: const Money.rupees(500),
    );
    await h.parties.save(const Party(name: 'Ravi'));
    await h.pump(tester);
    expect(find.text('You owe ₹500.00'), findsOneWidget); // Home tile

    await tester.tap(find.byKey(const Key('customersTile')));
    await tester.pumpAndSettle();
    expect(find.text('Ravi'), findsOneWidget);
    expect(find.text('Gupta Distributors'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('purchasesTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('suppliersButton')));
    await tester.pumpAndSettle();
    expect(find.text('Gupta Distributors'), findsOneWidget);
    expect(find.text('Ravi'), findsNothing);
  });

  testWidgets('credit purchase without a supplier asks for one', (
    tester,
  ) async {
    final h = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('purchasesTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addPurchaseButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('purchaseAddItemButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parle-G 100g'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('purchaseQtyField')), '2');
    await tester.enterText(find.byKey(const Key('purchaseCostField')), '8');
    await tester.tap(find.byKey(const Key('purchaseLineDoneButton')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Credit'));
    await tester.tap(find.text('Credit'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('savePurchaseButton')));
    await tester.tap(find.byKey(const Key('savePurchaseButton')));
    await tester.pumpAndSettle();

    expect(h.purchases.all, isEmpty);
    await tester.ensureVisible(find.byKey(const Key('pickSupplierTile')));
    expect(find.text('Choose a supplier to buy on credit'), findsOneWidget);
  });

  testWidgets('add an expense, then remove it', (tester) async {
    final h = await harness();
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('expensesTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addExpenseButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Electricity'));
    await tester.enterText(
      find.byKey(const Key('expenseAmountField')),
      '1,250',
    );
    await tester.tap(find.byKey(const Key('saveExpenseButton')));
    await tester.pumpAndSettle();

    final e = h.expenses.all.single;
    expect(e.category, 'Electricity');
    expect(e.amount, const Money.rupees(1250));
    expect(textOf(tester, const Key('expensesTotal')), '₹1,250.00');

    await tester.longPress(find.text('Electricity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(h.expenses.all, isEmpty);
    expect(textOf(tester, const Key('expensesTotal')), '₹0.00');
  });

  testWidgets('return part of a bill: credit note on the bill', (tester) async {
    final h = await harness();
    final item = h.items.all.single;
    final bill = await h.bills.create(
      BillDraft(
        lines: [
          DraftLine(
            itemId: item.id,
            name: item.name,
            unitPrice: item.salePrice,
            quantity: const Quantity.whole(10),
            taxRate: item.taxRate,
          ),
        ],
      ),
    );
    await h.pump(tester);
    await tester.tap(find.byKey(const Key('salesTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(bill.invoiceNo));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('billMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Return items'));
    await tester.pumpAndSettle();
    expect(find.text('10 pcs can be returned'), findsOneWidget);

    // More than was sold is refused before saving.
    await tester.enterText(find.byKey(const Key('returnQty0')), '11');
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('saveReturnButton')))
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byKey(const Key('returnQty0')), '3');
    await tester.pump();
    expect(find.text('Issue credit note · ₹30.00'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveReturnButton')));
    await tester.pumpAndSettle();

    final note = h.returns.notes.single;
    expect(note.billId, bill.id);
    expect(note.total, const Money.rupees(30));
    expect(note.refundMode, PaymentMode.cash);
    expect(find.text('Credit note ${note.noteNo} issued'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(Key('creditNote${note.id}')),
      200,
    );
    expect(find.text('${note.noteNo} · ₹30.00'), findsOneWidget);
  });

  testWidgets('reports: month summary, GST payable, export for the CA', (
    tester,
  ) async {
    final h = await harness();
    final item = h.items.all.single;
    final supplier = await h.parties.save(
      Party(name: 'Gupta', type: PartyType.supplier, gstin: supplierGstin),
    );
    // Sale ₹100 (5% inclusive: ₹4.76 GST).
    await h.bills.create(
      BillDraft(
        lines: [
          DraftLine(
            itemId: item.id,
            name: item.name,
            hsn: item.hsn,
            unitPrice: item.salePrice,
            quantity: const Quantity.whole(10),
            taxRate: item.taxRate,
          ),
        ],
      ),
    );
    // Bought ₹40 + 5% (₹2.00 input credit) from a registered supplier.
    await h.purchases.create(
      PurchaseDraft(
        partyId: supplier.id,
        lines: [
          PurchaseDraftLine(
            itemId: item.id,
            name: item.name,
            quantity: const Quantity.whole(5),
            unitCost: const Money.rupees(8),
            taxRate: item.taxRate,
          ),
        ],
      ),
    );
    await h.expenses.add(
      Expense(
        spentAt: DateTime.now(),
        category: 'Tea & snacks',
        amount: const Money.rupees(20),
      ),
    );

    final shared = <(String, String)>[];
    final tmp = await tester.runAsync(
      () => Directory.systemTemp.createTemp('reports_test'),
    );
    addTearDown(() => tmp!.deleteSync(recursive: true));

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
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReportsPage(
            tempDir: () async => tmp!,
            shareFile: (path, text) async => shared.add((path, text)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(textOf(tester, const Key('reportSales')), '₹100.00');
    // ₹4.76 output − ₹2.00 input.
    expect(textOf(tester, const Key('reportGstPayable')), '₹2.76');
    expect(find.text('GST payable'), findsOneWidget);
    // Profit: item has no cost price, so the gross profit is partial.
    expect(find.text('Gross profit (items with cost)'), findsOneWidget);

    // Real file IO: let it run outside the fake clock, pumping in between.
    await tester.scrollUntilVisible(
      find.byKey(const Key('exportGstButton')),
      200,
    );
    await tester.tap(find.byKey(const Key('exportGstButton')));
    for (var i = 0; i < 100 && shared.isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(shared, hasLength(1));
    expect(shared.single.$1, endsWith('.xlsx'));
    expect(File(shared.single.$1).lengthSync(), greaterThan(1000));
    expect(shared.single.$2, contains('Sharma Kirana'));
  });
}
