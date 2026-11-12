import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shop_app/core/db/tables.dart';

part 'app_database.g.dart';

/// The local SQLite database: the app's source of truth (offline-first).
///
/// Changing a table? Bump [schemaVersion], add a step to [migration], then
/// run `dart run drift_dev make-migrations` to snapshot the schema and
/// generate a migration test. Never edit an old schema snapshot.
@DriftDatabase(tables: [ShopProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _open() => driftDatabase(name: 'shop_app');
}
