import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/core/db/app_database.steps.dart';
import 'package:shop_app/core/db/sync_schema.dart';
import 'package:shop_app/core/db/tables.dart';

part 'app_database.g.dart';

/// The local SQLite database: the app's source of truth (offline-first).
///
/// Changing a table? Bump [schemaVersion], then run
/// `dart run drift_dev make-migrations`, which snapshots the schema and
/// regenerates `app_database.steps.dart` plus migration tests. Then add the
/// new step to [migration]. Never edit an old schema snapshot.
@DriftDatabase(
  tables: [
    ShopProfiles,
    Items,
    Bills,
    BillLines,
    InvoiceCounters,
    AppSettings,
    Categories,
    ItemBatches,
    StockMovements,
    Parties,
    PartyEntries,
    Purchases,
    PurchaseLines,
    Expenses,
    CreditNotes,
    CreditNoteLines,
    CreditNoteCounters,
    SyncOutbox,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Each step uses that version's schema snapshot (app_database.steps.dart),
    // so a phone several versions behind upgrades one step at a time.
    onUpgrade: stepByStep(
      // Phase 1 (build 0.1): items, bills and settings.
      from1To2: (m, schema) async {
        await m.createTable(schema.items);
        await m.createIndex(schema.itemsName);
        await m.createTable(schema.bills);
        await m.createIndex(schema.billsBilledAt);
        await m.createTable(schema.billLines);
        await m.createTable(schema.invoiceCounters);
        await m.createTable(schema.appSettings);
      },
      // Phase 2 (build 0.2): inventory.
      from2To3: (m, schema) async {
        await m.createTable(schema.categories);
        final items = schema.items;
        for (final column in [
          items.trackStock,
          items.stockMilli,
          items.lowStockMilli,
          items.categoryId,
          items.imagePath,
          items.tracksBatches,
          items.altUnit,
          items.altUnitFactorMilli,
          items.altUnitPricePaise,
        ]) {
          await m.addColumn(items, column);
        }
        await m.addColumn(schema.billLines, schema.billLines.unitFactorMilli);
        await m.createTable(schema.itemBatches);
        await m.createTable(schema.stockMovements);
        await m.createIndex(schema.movementsItem);
      },
      // Phase 3 (build 0.3): customers and dues.
      from3To4: (m, schema) async {
        await m.createTable(schema.parties);
        await m.createIndex(schema.partiesName);
        await m.createTable(schema.partyEntries);
        await m.createIndex(schema.partyEntriesParty);
        await m.addColumn(schema.bills, schema.bills.partyId);
        await m.addColumn(schema.bills, schema.bills.duePaise);
      },
      // Phase 4 (build 0.4): purchases, expenses, returns, full GST.
      from4To5: (m, schema) async {
        await m.addColumn(schema.items, schema.items.costPricePaise);
        await m.addColumn(schema.parties, schema.parties.stateCode);
        for (final c in [
          schema.bills.interState,
          schema.bills.placeOfSupply,
          schema.bills.buyerGstin,
        ]) {
          await m.addColumn(schema.bills, c);
        }
        await m.addColumn(schema.billLines, schema.billLines.costPaise);
        await m.addColumn(schema.billLines, schema.billLines.returnedMilli);
        await m.createTable(schema.purchases);
        await m.createIndex(schema.purchasesDate);
        await m.createTable(schema.purchaseLines);
        await m.createTable(schema.expenses);
        await m.createIndex(schema.expensesDate);
        await m.createTable(schema.creditNotes);
        await m.createIndex(schema.creditNotesDate);
        await m.createTable(schema.creditNoteLines);
        await m.createTable(schema.creditNoteCounters);
      },
      // Build 0.5.1: editable printed-bill template.
      from5To6: (m, schema) async {
        await m.addColumn(
          schema.appSettings,
          schema.appSettings.receiptTemplate,
        );
      },
      // Build 0.5.2: a separate label printer and label size.
      from6To7: (m, schema) async {
        await m.addColumn(schema.appSettings, schema.appSettings.labelSetup);
      },
      // Build 0.6: sharing the shop between phones. Every shared row gets
      // a uid; bill and credit-note numbers become unique per phone series;
      // everything so far is queued to go up to the cloud.
      from7To8: (m, schema) async {
        // Rebuilt (not just a new column): their unique number key changes.
        // Foreign keys are off here (switched on in beforeOpen), so the
        // rebuild doesn't cascade into bill lines or credit-note lines.
        await m.alterTable(
          TableMigration(
            schema.bills,
            newColumns: [schema.bills.uid, schema.bills.series],
          ),
        );
        await m.alterTable(
          TableMigration(
            schema.creditNotes,
            newColumns: [schema.creditNotes.uid, schema.creditNotes.series],
          ),
        );
        // Bills numbered after joining the cloud carry the letter already:
        // INV-A/26-27/0007 -> series A.
        for (final table in ['bills', 'credit_notes']) {
          final number = table == 'bills' ? 'invoice_no' : 'note_no';
          await customStatement(
            'UPDATE $table SET series = substr($number, '
            "instr($number, '/') - 1, 1) "
            "WHERE instr($number, '/') > 2 "
            "AND substr($number, instr($number, '/') - 2, 1) = '-'",
          );
        }
        for (final (table, column) in [
          (schema.categories, schema.categories.uid),
          (schema.items, schema.items.uid),
          (schema.itemBatches, schema.itemBatches.uid),
          (schema.stockMovements, schema.stockMovements.uid),
          (schema.parties, schema.parties.uid),
          (schema.partyEntries, schema.partyEntries.uid),
          (schema.billLines, schema.billLines.uid),
          (schema.purchases, schema.purchases.uid),
          (schema.purchaseLines, schema.purchaseLines.uid),
          (schema.expenses, schema.expenses.uid),
          (schema.creditNoteLines, schema.creditNoteLines.uid),
        ]) {
          await m.addColumn(table, column);
        }
        await m.createTable(schema.syncOutbox);
        await m.createTable(schema.syncState);
        await backfillSync(this);
        for (final index in [
          schema.categoriesUid,
          schema.itemsUid,
          schema.itemBatchesUid,
          schema.movementsUid,
          schema.billsUid,
          schema.partiesUid,
          schema.partyEntriesUid,
          schema.billLinesUid,
          schema.purchasesUid,
          schema.purchaseLinesUid,
          schema.expensesUid,
          schema.creditNotesUid,
          schema.creditNoteLinesUid,
        ]) {
          await m.createIndex(index);
        }
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // The nightly backup may read while the app writes: wait, don't fail.
      await customStatement('PRAGMA busy_timeout = 5000');
      // New rows get a uid and changed rows are queued for the cloud.
      await installSyncTriggers(this);
    },
  );

  static const _name = 'shop_app';

  static QueryExecutor _open() => driftDatabase(name: _name);

  /// Where [driftDatabase] keeps the file (used by backup and restore).
  static Future<File> file() async => File(
    p.join((await getApplicationDocumentsDirectory()).path, '$_name.sqlite'),
  );
}
