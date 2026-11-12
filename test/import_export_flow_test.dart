import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/import_export_page.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

import 'helpers/fakes.dart';

Future<void> pumpPage(
  WidgetTester tester,
  TestHarness h, {
  required Uint8List? file,
  List<(String, String)>? shared,
}) async {
  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ItemRepository>.value(value: h.items),
        RepositoryProvider<InventoryRepository>.value(value: h.inventory),
        RepositoryProvider<ShopProfileRepository>.value(value: h.shopProfiles),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ImportExportPage(
          pickFile: () async => file,
          shareFile: (path, text) async => shared?.add((path, text)),
          tempDir: () => Directory.systemTemp.createTemp('export_test'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('import: preview with problems, then import the good rows', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await h.items.save(
      const Item(name: 'Tea', barcode: '111', salePrice: Money.rupees(5)),
    );
    final csv = utf8.encode(
      'Item name,Barcode,Selling price,GST %,Opening stock,Colour\n'
      'Tea (updated),111,6,5,,red\n'
      'Coffee,,120,18,20,\n'
      ',,10,,,\n'
      'Sugar,,ten,,,\n',
    );
    await pumpPage(tester, h, file: Uint8List.fromList(csv));

    await tester.tap(find.byKey(const Key('importTile')));
    await tester.pumpAndSettle();
    expect(find.text('1 new · 1 updated · 2 with problems'), findsOneWidget);
    expect(find.text('Ignored columns: Colour'), findsOneWidget);
    expect(find.text('Row 4'), findsOneWidget);
    expect(find.text('Item name is missing'), findsOneWidget);
    expect(find.text('Row 5'), findsOneWidget);

    await tester.tap(find.byKey(const Key('importGoButton')));
    await tester.pumpAndSettle();
    expect(find.text('Done: 1 added, 1 updated'), findsOneWidget);
    final byName = {for (final i in h.items.all) i.name: i};
    expect(byName.keys, containsAll(['Tea (updated)', 'Coffee']));
    expect(byName['Coffee']!.stock, const Quantity.whole(20));
  });

  testWidgets('import: a file that is not a sheet shows an error', (
    tester,
  ) async {
    final h = TestHarness(shop: testShop);
    await pumpPage(
      tester,
      h,
      file: Uint8List.fromList(utf8.encode('just some text\n')),
    );
    await tester.tap(find.byKey(const Key('importTile')));
    await tester.pumpAndSettle();
    expect(find.textContaining("Couldn't read this file"), findsOneWidget);
    expect(find.byKey(const Key('importTile')), findsOneWidget);
  });

  testWidgets('export shares an .xlsx with every item', (tester) async {
    final h = TestHarness(shop: testShop);
    await h.items.save(const Item(name: 'Tea', salePrice: Money.rupees(5)));
    final shared = <(String, String)>[];
    await pumpPage(tester, h, file: null, shared: shared);

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('exportTile')));
      // File writing is real I/O: let it finish outside the fake clock.
      for (var i = 0; i < 50 && shared.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    expect(shared, hasLength(1));
    expect(shared.single.$1, endsWith('.xlsx'));
    expect(shared.single.$2, 'Items from Sharma Kirana');
    final rows = readSpreadsheet(File(shared.single.$1).readAsBytesSync());
    expect(rows.first.first, 'Item name');
    expect(rows[1].first, 'Tea');
  });
}
