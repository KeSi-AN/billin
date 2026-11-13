import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/core/db/app_database.steps.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 5;

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
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static const _name = 'shop_app';

  static QueryExecutor _open() => driftDatabase(name: _name);

  /// Where [driftDatabase] keeps the file (used by backup and restore).
  static Future<File> file() async => File(
    p.join((await getApplicationDocumentsDirectory()).path, '$_name.sqlite'),
  );
}
