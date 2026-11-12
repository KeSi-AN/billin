import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/inventory/data/drift_inventory_repository.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/item_import.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';

import '../../helpers/fakes.dart';

void main() {
  group('CSV', () {
    test('quotes, doubled quotes, commas and line breaks inside fields', () {
      final rows = readCsv(
        'Item name,Price\r\n"Biscuit, cream",10\r\n"He said ""hi""",5\n"Two\nlines",1\n',
      );
      expect(rows, [
        ['Item name', 'Price'],
        ['Biscuit, cream', '10'],
        ['He said "hi"', '5'],
        ['Two\nlines', '1'],
      ]);
    });

    test('semicolon CSV (Excel in some locales) and the UTF-8 BOM', () {
      final rows = readCsv('﻿Item name;Selling price\nचाय;12,5\n');
      expect(rows, [
        ['Item name', 'Selling price'],
        ['चाय', '12,5'],
      ]);
    });

    test('blank lines are skipped; write → read round-trips', () {
      final rows = [
        ['a', 'b,c', 'd"e'],
        ['₹ 10', '', 'x'],
      ];
      expect(readCsv(writeCsv(rows)), rows);
      expect(readCsv('a,b\n\n,\nc,d\n'), [
        ['a', 'b'],
        ['c', 'd'],
      ]);
    });
  });

  group('XLSX', () {
    test('write → read round-trips text, numbers and special characters', () {
      final rows = [
        ['Item name', 'Selling price', 'Note'],
        ['Tom & Jerry <toy>', '240', 'quote " here'],
        ['चाय पत्ती', '12.5', ''],
        ['Big barcode', '8901719110054', ''],
      ];
      final bytes = writeXlsx(rows, numericColumns: {1});
      expect(String.fromCharCodes(bytes.take(2)), 'PK');
      final back = readSpreadsheet(bytes);
      expect(back[0], rows[0]);
      expect(back[1], rows[1]);
      expect(back[2], ['चाय पत्ती', '12.5']); // trailing blank trimmed
      expect(back[3][1], '8901719110054');
    });

    test('rejects a broken file with a clear message', () {
      final notZip = Uint8List.fromList([0x50, 0x4B, 1, 2, 3]);
      expect(
        () => readSpreadsheet(notZip),
        throwsA(isA<SpreadsheetException>()),
      );
    });

    test('CSV bytes are detected without relying on the extension', () {
      final bytes = Uint8List.fromList(
        utf8.encode('Item name,Price\nTea,10\n'),
      );
      expect(readSpreadsheet(bytes).last, ['Tea', '10']);
    });
  });

  group('ItemImporter (fakes)', () {
    late FakeItems items;
    late FakeInventory inventory;
    late ItemImporter importer;

    setUp(() {
      items = FakeItems();
      inventory = FakeInventory(items);
      importer = ItemImporter(items: items, inventory: inventory);
    });

    test('needs a header row with name and price', () {
      expect(
        () => importer.plan([
          ['Tea', '10'],
        ]),
        throwsA(isA<SpreadsheetException>()),
      );
    });

    test(
      'accepts header aliases in any order and reports unknown ones',
      () async {
        final plan = await importer.plan([
          ['RATE', 'Product', 'Colour', 'Tax %', 'UOM'],
          ['10', 'Tea', 'red', '5%', 'pkt'],
        ]);
        final row = plan.rows.single;
        expect(row.isValid, isTrue);
        expect(row.item!.name, 'Tea');
        expect(row.item!.taxRate, const TaxRate(500));
        expect(row.item!.unit, 'pack');
        expect(plan.unknownHeaders, ['Colour']);
      },
    );

    test('validates each row and keeps going', () async {
      final plan = await importer.plan([
        [
          'Item name',
          'Barcode',
          'Selling price',
          'MRP',
          'GST %',
          'Unit',
          'Opening stock',
        ],
        ['', '', '10', '', '', '', ''], // no name
        ['A', '', 'ten', '', '', '', ''], // bad price
        ['B', '', '10', '8', '', '', ''], // MRP < price
        ['C', '', '10', '', '7', '', ''], // bad GST
        ['D', '111', '10', '', '', '', ''],
        ['E', '111', '10', '', '', '', ''], // repeated barcode
        ['F', '', '10', '', '', 'crate', ''], // bad unit
        ['G', '', '10', '', '0.18', '', 'lots'], // bad stock; GST 0.18 ok
        ['H', '', '10', '', '18', '', '5'], // fine
      ]);
      expect(plan.rows.map((r) => r.isValid), [
        false,
        false,
        false,
        false,
        true,
        false,
        false,
        false,
        true,
      ]);
      expect(plan.rows[5].errors.single, contains('also on row 6'));
      expect(plan.invalid.first.rowNumber, 2);
      expect(plan.creates, 2);
    });

    test('updates by barcode, then by name; creates the rest', () async {
      await items.save(
        const Item(
          name: 'Old name',
          barcode: '890',
          salePrice: Money.rupees(9),
        ),
      );
      await items.save(const Item(name: 'Tea', salePrice: Money.rupees(5)));
      final plan = await importer.plan([
        ['Item name', 'Barcode', 'Selling price', 'Opening stock'],
        ['New name', '890', '10', '50'],
        ['TEA', '', '6', ''],
        ['Coffee', '', '120', '20'],
      ]);
      expect(plan.updates, 2);
      expect(plan.creates, 1);
      final result = await importer.apply(plan);
      expect((result.created, result.updated, result.failed), (1, 2, 0));

      final all = {for (final i in items.all) i.name: i};
      expect(all.keys, containsAll(['New name', 'TEA', 'Coffee']));
      expect(all['New name']!.salePrice, const Money.rupees(10));
      // Stock is only set for new items.
      expect(all['New name']!.stock, Quantity.zero);
      expect(all['Coffee']!.stock, const Quantity.whole(20));
      expect(all['Coffee']!.trackStock, isTrue);
    });

    test('creates categories and subcategories once', () async {
      final plan = await importer.plan([
        ['Item name', 'Selling price', 'Category', 'Subcategory'],
        ['A', '1', 'Food', 'Snacks'],
        ['B', '1', 'food', 'snacks'],
        ['C', '1', 'Food', ''],
      ]);
      await importer.apply(plan);
      expect(inventory.categories.map((c) => c.name), ['Food', 'Snacks']);
      final ids = items.all.map((i) => i.categoryId).toList();
      expect(ids[0], ids[1]);
      expect(ids[2], inventory.categories.first.id);
    });

    test('export → import changes nothing (round trip)', () async {
      final first = await importer.plan(itemTemplate());
      await importer.apply(first);
      final exported = await exportItems(items, inventory);
      final again = await importer.plan(readSpreadsheet(writeXlsx(exported)));
      expect(again.invalid, isEmpty);
      expect(again.creates, 0);
      expect(again.updates, 2);
      List<(String, Money, TaxRate, Quantity, int?)> snapshot() =>
          (items.all.toList()..sort((a, b) => a.name.compareTo(b.name)))
              .map(
                (i) => (i.name, i.salePrice, i.taxRate, i.stock, i.categoryId),
              )
              .toList();
      final before = snapshot();
      await importer.apply(again);
      expect(snapshot(), before);
    });
  });

  test('imports 600 items into the real database quickly', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final items = DriftItemRepository(db);
    final inventory = DriftInventoryRepository(db);
    final importer = ItemImporter(items: items, inventory: inventory);

    final sheet = <List<String>>[
      [
        'Item name',
        'Barcode',
        'Selling price',
        'GST %',
        'Category',
        'Opening stock',
      ],
      for (var i = 0; i < 600; i++)
        [
          'Item $i',
          '8900000${i.toString().padLeft(6, '0')}',
          '${10 + i % 90}',
          const ['5', '18'][i % 2],
          'Cat ${i % 7}',
          '${i % 40}',
        ],
    ];
    final watch = Stopwatch()..start();
    final plan = await importer.plan(readSpreadsheet(writeXlsx(sheet)));
    final result = await importer.apply(plan);
    watch.stop();

    expect(result.created, 600);
    expect((await items.watchAll().first).length, 600);
    expect((await inventory.watchCategories().first).length, 7);
    final sample = await items.byBarcode('8900000000039');
    expect(sample?.stock, const Quantity.whole(39));
    // Generous bound; on a laptop this takes well under a second.
    expect(watch.elapsed.inSeconds, lessThan(20), reason: '${watch.elapsed}');
  });
}
