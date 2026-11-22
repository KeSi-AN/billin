import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/purchases/data/drift_purchase_repository.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/purchases/presentation/photo_purchase_page.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

import '../../helpers/fakes.dart';

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  group('repository', () {
    late AppDatabase db;
    late DriftPurchaseRepository purchases;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      purchases = DriftPurchaseRepository(db);
    });
    tearDown(() => db.close());

    test('a photo, date and supplier are a purchase on their own', () async {
      final p = await purchases.create(
        PurchaseDraft.photo(
          photoPath: '/data/purchases/Purchase_2026-11-20_Ravi Textiles.jpg',
          purchasedAt: DateTime(2026, 11, 20, 12),
          supplierName: ' Ravi Textiles ',
          amount: const Money.rupees(12500),
        ),
      );
      expect(p.lines, isEmpty);
      expect(p.supplierName, 'Ravi Textiles');
      expect(p.photoPath, endsWith('Ravi Textiles.jpg'));
      expect(p.purchasedAt, DateTime(2026, 11, 20, 12));
      expect(p.total, const Money.rupees(12500));
      // GST on a photo isn't known, so none is claimed.
      expect(p.tax, Money.zero);
      expect(p.due, Money.zero);
      final listed = await purchases
          .watchBetween(DateTime(2026, 11), DateTime(2026, 12))
          .first;
      expect(listed.single.photoPath, p.photoPath);
    });

    test('no amount is fine; no photo and no lines is not', () async {
      final p = await purchases.create(
        PurchaseDraft.photo(
          photoPath: '/x.jpg',
          purchasedAt: DateTime(2026, 11, 20),
          supplierName: 'Gupta',
        ),
      );
      expect(p.total, Money.zero);
      expect(
        () => purchases.create(const PurchaseDraft(lines: [])),
        throwsArgumentError,
      );
    });
  });

  testWidgets('photo purchase screen: photo, supplier, date → saved', (
    tester,
  ) async {
    // A phone-sized screen (1080 x 2400 at 2.75 dots per point).
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final dir = Directory.systemTemp.createTempSync('photo_purchase');
    addTearDown(() {
      try {
        dir.deleteSync(recursive: true);
      } on FileSystemException {
        // Windows may still hold the shown image; temp gets cleaned.
      }
    });
    final picked = File('${dir.path}/IMG_1234.jpg')
      ..writeAsBytesSync(img.encodeJpg(img.Image(width: 40, height: 60)));
    final published = <String>[];
    final items = FakeItems();
    final parties = FakeParties();
    final purchases = FakePurchases(items: items, parties: parties);
    await parties.save(
      const Party(name: 'Ravi Textiles', type: PartyType.supplier),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.push('/photo'),
              child: const Text('open'),
            ),
          ),
        ),
        GoRoute(
          path: '/photo',
          builder: (context, state) => PhotoPurchasePage(
            pickPhoto: (_) async => picked.path,
            publish: (path, name) async => published.add(name),
            store: (source, name) async => '/app/purchases/$name',
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<PartyRepository>.value(value: parties),
          RepositoryProvider<PurchaseRepository>.value(value: purchases),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Saving without a photo asks for one.
    await tester.tap(find.byKey(const Key('photoPurchaseSave')));
    await tester.pump();
    expect(
      find.text('Take or pick the photo of the bill first.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('photoPurchasePhoto')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('photoPurchaseSupplier')),
      'ravi textiles',
    );
    await tester.enterText(
      find.byKey(const Key('photoPurchaseAmount')),
      '8,450',
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('photoPurchaseSave')));
    await tester.pumpAndSettle();

    final saved = purchases.all.single;
    // The known supplier is linked, with its saved spelling.
    expect(saved.supplierName, 'Ravi Textiles');
    expect(saved.partyId, isNotNull);
    expect(saved.total, const Money.rupees(8450));
    final today = DateTime.now();
    final day =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    expect(saved.photoPath, '/app/purchases/Purchase_${day}_Ravi Textiles.jpg');
    expect(published, ['Purchase_${day}_Ravi Textiles.jpg']);
    expect(find.text('open'), findsOneWidget); // back where it came from
  });
}
