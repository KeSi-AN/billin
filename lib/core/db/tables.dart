import 'package:drift/drift.dart';

/// The shop's own details. Always exactly one row (id = 1).
@DataClassName('ShopProfileRow')
class ShopProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get addressLine => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get pincode => text().nullable()();

  /// GST state code (`27` = Maharashtra). Drives CGST/SGST vs IGST later.
  TextColumn get stateCode => text().withLength(min: 2, max: 2)();
  TextColumn get gstin => text().nullable()();

  /// Absolute path to the logo copied into the app's private storage.
  TextColumn get logoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}
