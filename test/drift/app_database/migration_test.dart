// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('v7 -> v8 keeps bills and lines, reads series, queues everything', () async {
    final schema = await verifier.schemaAt(7);
    final raw = schema.rawDatabase;
    raw.execute(
      "INSERT INTO items (id, name, unit, sale_price_paise, tax_rate_bp, "
      "price_includes_tax, is_active, created_at, updated_at, track_stock, "
      "stock_milli, tracks_batches) VALUES (1, 'Saree', 'pcs', 50000, 500, 1, 1, 0, 0, 1, 3000, 0)",
    );
    for (final (id, no, seq) in [
      (1, 'INV/26-27/0001', 1),
      (2, 'INV-A/26-27/0002', 2),
    ]) {
      raw.execute(
        "INSERT INTO bills (id, invoice_no, fy_start, sequence, billed_at, "
        "items_total_paise, bill_discount_paise, taxable_paise, tax_paise, "
        "round_off_paise, grand_total_paise, payment_mode, status, due_paise, inter_state) "
        "VALUES ($id, '$no', 2026, $seq, 0, 50000, 0, 47619, 2381, 0, 50000, 'cash', 'final', 0, 0)",
      );
      raw.execute(
        "INSERT INTO bill_lines (bill_id, position, item_id, name, unit, "
        "quantity_milli, unit_price_paise, tax_rate_bp, price_includes_tax, "
        "discount_paise, bill_discount_share_paise, taxable_paise, tax_paise, total_paise, "
        "unit_factor_milli, returned_milli) VALUES ($id, 0, 1, 'Saree', 'pcs', 1000, 50000, "
        "500, 1, 0, 0, 47619, 2381, 50000, 1000, 0)",
      );
    }
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 8);

    final bills = await db
        .customSelect('SELECT id, series, uid FROM bills ORDER BY id')
        .get();
    expect([for (final b in bills) b.read<String>('series')], ['', 'A']);
    expect(
      bills.every((b) => (b.readNullable<String>('uid') ?? '').length == 32),
      isTrue,
    );
    final lines = await db
        .customSelect('SELECT bill_id, uid FROM bill_lines')
        .get();
    expect(
      lines,
      hasLength(2),
      reason: 'rebuilding bills must not drop its lines',
    );
    expect(lines.every((l) => l.readNullable<String>('uid') != null), isTrue);
    final item = await db
        .customSelect('SELECT stock_milli, uid FROM items')
        .getSingle();
    expect(item.read<int>('stock_milli'), 3000);
    final queued = await db
        .customSelect('SELECT tbl, COUNT(*) AS n FROM sync_outbox GROUP BY tbl')
        .get();
    expect(
      {for (final q in queued) q.read<String>('tbl'): q.read<int>('n')},
      {'items': 1, 'bills': 2, 'bill_lines': 2},
    );

    // New rows get a uid and are queued; a stock-only change is not.
    await db.customStatement('DELETE FROM sync_outbox');
    await db.customStatement(
      "UPDATE items SET stock_milli = 2000 WHERE id = 1",
    );
    expect(await db.customSelect('SELECT * FROM sync_outbox').get(), isEmpty);
    await db.customStatement(
      "UPDATE items SET sale_price_paise = 60000 WHERE id = 1",
    );
    expect(
      await db.customSelect('SELECT * FROM sync_outbox').get(),
      hasLength(1),
    );
    await db.close();
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldShopProfilesData = <v1.ShopProfilesData>[];
    final expectedNewShopProfilesData = <v2.ShopProfilesData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.shopProfiles, oldShopProfilesData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewShopProfilesData,
          await newDb.select(newDb.shopProfiles).get(),
        );
      },
    );
  });
}
