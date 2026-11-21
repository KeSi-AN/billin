import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/app/flavor.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/cloud/domain/cloud.dart';

import 'helpers/fakes.dart';

class FakeCloud implements CloudService {
  final _users = StreamController<CloudUser?>.broadcast();
  CloudUser? user;
  CloudLink? linked;
  final shops = <CloudShop>[];
  var _nextSeries = 'A';

  @override
  bool get available => true;

  @override
  CloudUser? get currentUser => user;

  @override
  Stream<CloudUser?> watchUser() async* {
    yield user;
    yield* _users.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    user = const CloudUser(id: 'u1', email: 'owner@example.com', name: 'Owner');
    _users.add(user);
  }

  @override
  Future<void> signOut() async {
    user = null;
    linked = null;
    _users.add(null);
  }

  @override
  Future<List<CloudShop>> myShops() async => [...shops];

  @override
  Future<CloudShop> createShop(String name) async {
    final s = CloudShop(id: 's${shops.length + 1}', name: name, role: 'owner');
    shops.add(s);
    return s;
  }

  @override
  Future<CloudLink> linkPhone(CloudShop shop) async {
    linked = CloudLink(
      shopId: shop.id,
      shopName: shop.name,
      deviceId: 'd1',
      series: _nextSeries,
    );
    _nextSeries = 'B';
    return linked!;
  }

  @override
  Future<CloudLink?> link() async => linked;
}

Future<void> openAccount(WidgetTester tester, FakeCloud cloud) async {
  final h = TestHarness(shop: testShop);
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  final s = h.services;
  await tester.pumpWidget(
    ShopApp(
      flavor: Flavor.prod,
      services: AppServices(
        shopProfiles: s.shopProfiles,
        items: s.items,
        bills: s.bills,
        settings: s.settings,
        billActions: s.billActions,
        printer: s.printer,
        inventory: s.inventory,
        stockAlerts: s.stockAlerts,
        parties: s.parties,
        customerActions: s.customerActions,
        contactPicker: s.contactPicker,
        purchases: s.purchases,
        returns: s.returns,
        expenses: s.expenses,
        backup: s.backup,
        cloud: cloud,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('settingsButton')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('accountTile')));
  await tester.pumpAndSettle();
}

void main() {
  test('a phone series goes after the prefix', () {
    final fy = FinancialYear.of(DateTime(2026, 11, 22));
    expect(
      InvoiceNumber.format(prefix: 'INV', year: fy, sequence: 7, series: 'A'),
      'INV-A/26-27/0007',
    );
    expect(
      InvoiceNumber.format(prefix: '', year: fy, sequence: 7, series: 'B'),
      'B/26-27/0007',
    );
    expect(
      InvoiceNumber.format(prefix: 'INV', year: fy, sequence: 7),
      'INV/26-27/0007',
    );
  });

  test('bills on a linked phone carry its letter', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    String? series;
    final bills = DriftBillRepository(
      db,
      clock: () => DateTime(2026, 11, 22, 10),
      series: () async => series,
    );
    const draft = BillDraft(
      lines: [DraftLine(name: 'kurti set', unitPrice: Money.rupees(1555))],
    );
    expect((await bills.create(draft)).invoiceNo, 'INV/26-27/0001');
    series = 'B';
    expect((await bills.create(draft)).invoiceNo, 'INV-B/26-27/0002');
  });

  testWidgets('sign in, put the shop in the cloud, sign out', (tester) async {
    final cloud = FakeCloud();
    await openAccount(tester, cloud);
    expect(find.byKey(const Key('googleSignInButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('googleSignInButton')));
    await tester.pumpAndSettle();
    expect(find.text('Owner'), findsOneWidget);
    expect(find.text('Put this shop in the cloud'), findsOneWidget);

    await tester.tap(find.byKey(const Key('createCloudShopButton')));
    await tester.pumpAndSettle();
    expect(cloud.shops.single.name, testShop.name);
    expect(find.byKey(const Key('linkedShop')), findsOneWidget);
    expect(
      find.text("This phone's bills are numbered INV-A/…"),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('signOutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out').last);
    await tester.pumpAndSettle();
    expect(cloud.linked, isNull);
    expect(find.byKey(const Key('googleSignInButton')), findsOneWidget);
  });

  testWidgets('a second phone joins an existing shop', (tester) async {
    final cloud = FakeCloud()
      ..user = const CloudUser(id: 'u1', email: 'owner@example.com')
      ..shops.add(
        const CloudShop(id: 's1', name: 'Sadiya Fashion', role: 'owner'),
      );
    await openAccount(tester, cloud);
    expect(find.text('Sadiya Fashion'), findsWidgets);
    await tester.tap(find.text('Use on this phone'));
    await tester.pumpAndSettle();
    expect(cloud.linked!.shopId, 's1');
    expect(find.byKey(const Key('linkedShop')), findsOneWidget);
  });
}
