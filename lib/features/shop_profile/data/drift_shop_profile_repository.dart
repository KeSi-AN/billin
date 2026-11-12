import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';

class DriftShopProfileRepository implements ShopProfileRepository {
  DriftShopProfileRepository(
    this._db, {
    required this._storageDir,
    this._clock = DateTime.now,
  });

  final AppDatabase _db;
  final Future<Directory> Function() _storageDir;
  final DateTime Function() _clock;

  SimpleSelectStatement<$ShopProfilesTable, ShopProfileRow> get _query =>
      _db.select(_db.shopProfiles)..where((t) => t.id.equals(1));

  @override
  Stream<ShopProfile?> watch() =>
      _query.watchSingleOrNull().map((row) => row?.toDomain());

  @override
  Future<ShopProfile?> load() async =>
      (await _query.getSingleOrNull())?.toDomain();

  @override
  Future<void> save(ShopProfile profile) async {
    final now = _clock();
    await _db.transaction(() async {
      final existing = await _query.getSingleOrNull();
      final previousLogo = existing?.logoPath;
      await _db
          .into(_db.shopProfiles)
          .insertOnConflictUpdate(
            ShopProfilesCompanion.insert(
              id: const Value(1),
              name: profile.name.trim(),
              stateCode: profile.stateCode,
              phone: Value(_blankToNull(profile.phone)),
              addressLine: Value(_blankToNull(profile.addressLine)),
              city: Value(_blankToNull(profile.city)),
              pincode: Value(_blankToNull(profile.pincode)),
              gstin: Value(_blankToNull(profile.gstin)),
              logoPath: Value(profile.logoPath),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
            ),
          );
      // Old logo file is no longer referenced: clean it up.
      if (previousLogo != null && previousLogo != profile.logoPath) {
        final old = File(previousLogo);
        if (old.existsSync()) await old.delete();
      }
    });
  }

  @override
  Future<String> importLogo(String sourcePath) async {
    final dir = Directory(p.join((await _storageDir()).path, 'logos'));
    await dir.create(recursive: true);
    final ext = p.extension(sourcePath).toLowerCase();
    final target = p.join(
      dir.path,
      'logo_${_clock().millisecondsSinceEpoch}${ext.isEmpty ? '.png' : ext}',
    );
    await File(sourcePath).copy(target);
    return target;
  }

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}

extension on ShopProfileRow {
  ShopProfile toDomain() => ShopProfile(
    name: name,
    stateCode: stateCode,
    phone: phone,
    addressLine: addressLine,
    city: city,
    pincode: pincode,
    gstin: gstin,
    logoPath: logoPath,
  );
}
