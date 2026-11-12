import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$AppSettingsTable, SettingsRow> get _row =>
      _db.select(_db.appSettings)..where((t) => t.id.equals(1));

  @override
  Stream<AppSettingsData> watch() => _row.watchSingleOrNull().map(_toDomain);

  @override
  Future<AppSettingsData> load() async =>
      _toDomain(await _row.getSingleOrNull());

  @override
  Future<void> save(AppSettingsData s) async {
    String? blank(String? v) =>
        (v == null || v.trim().isEmpty) ? null : v.trim();
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            id: const Value(1),
            invoicePrefix: Value(s.invoicePrefix.trim().toUpperCase()),
            roundToRupee: Value(s.roundToRupee),
            upiId: Value(blank(s.upiId)),
            receiptFooter: Value(blank(s.receiptFooter)),
            printerAddress: Value(s.printerAddress),
            printerName: Value(s.printerName),
            paperWidthMm: Value(s.paperWidth.mm),
          ),
        );
  }

  static AppSettingsData _toDomain(SettingsRow? r) => r == null
      ? const AppSettingsData()
      : AppSettingsData(
          invoicePrefix: r.invoicePrefix,
          roundToRupee: r.roundToRupee,
          upiId: r.upiId,
          receiptFooter: r.receiptFooter,
          printerAddress: r.printerAddress,
          printerName: r.printerName,
          paperWidth: PaperWidth.fromMm(r.paperWidthMm),
        );
}
