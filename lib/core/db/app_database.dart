import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shop_app/core/db/tables.dart';

part 'app_database.g.dart';

/// The local SQLite database: the app's source of truth (offline-first).
///
/// Changing a table? Bump [schemaVersion], then run
/// `dart run drift_dev make-migrations`, which snapshots the schema and
/// regenerates `app_database.steps.dart` plus migration tests. Then add the
/// new step to [migration]. Never edit an old schema snapshot.
@DriftDatabase(
  tables: [ShopProfiles, Items, Bills, BillLines, InvoiceCounters, AppSettings],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Phase 1 (build 0.1): items, bills and settings.
      if (from < 2) {
        await m.createTable(items);
        await m.createIndex(itemsName);
        await m.createTable(bills);
        await m.createIndex(billsBilledAt);
        await m.createTable(billLines);
        await m.createTable(invoiceCounters);
        await m.createTable(appSettings);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _open() => driftDatabase(name: 'shop_app');
}
