import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

void main() {
  late AppDatabase db;
  late Directory storage;
  late DriftShopProfileRepository repo;
  var now = DateTime(2026, 11, 12, 10);

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    storage = await Directory.systemTemp.createTemp('shop_app_test');
    repo = DriftShopProfileRepository(
      db,
      storageDir: () async => storage,
      clock: () => now,
    );
  });

  tearDown(() async {
    await db.close();
    await storage.delete(recursive: true);
  });

  const profile = ShopProfile(
    name: '  Sharma General Store ',
    stateCode: '27',
    phone: '9876543210',
    city: 'Pune',
    addressLine: '   ',
  );

  test('is empty before setup', () async {
    expect(await repo.load(), isNull);
  });

  test('saves, trims, and turns blank fields into null', () async {
    await repo.save(profile);
    final loaded = await repo.load();
    expect(loaded?.name, 'Sharma General Store');
    expect(loaded?.addressLine, isNull);
    expect(loaded?.city, 'Pune');
  });

  test('keeps a single row and preserves createdAt on update', () async {
    await repo.save(profile);
    now = now.add(const Duration(days: 1));
    await repo.save(profile.copyWith(name: 'Sharma Kirana'));

    final rows = await db.select(db.shopProfiles).get();
    expect(rows, hasLength(1));
    expect(rows.single.name, 'Sharma Kirana');
    expect(rows.single.updatedAt.isAfter(rows.single.createdAt), isTrue);
  });

  test('watch emits null, then every saved version', () async {
    final emitted = <String?>[];
    final sub = repo.watch().listen((p) => emitted.add(p?.name));
    await pumpEventQueue();
    await repo.save(profile);
    await pumpEventQueue();
    await repo.save(profile.copyWith(name: 'B'));
    await pumpEventQueue();
    await sub.cancel();
    expect(emitted, [null, 'Sharma General Store', 'B']);
  });

  test(
    'imports a logo into app storage and deletes the replaced one',
    () async {
      final picked = File(p.join(storage.path, 'picked.JPG'))
        ..writeAsBytesSync([1, 2, 3]);

      final first = await repo.importLogo(picked.path);
      expect(p.isWithin(p.join(storage.path, 'logos'), first), isTrue);
      expect(p.extension(first), '.jpg');
      await repo.save(profile.copyWith(logoPath: first));

      now = now.add(const Duration(seconds: 1));
      final second = await repo.importLogo(picked.path);
      await repo.save(profile.copyWith(logoPath: second));

      expect(File(first).existsSync(), isFalse);
      expect(File(second).existsSync(), isTrue);
    },
  );

  test('survives an app restart (database file closed and reopened)', () async {
    final file = File(p.join(storage.path, 'restart.sqlite'));

    final firstRun = AppDatabase(NativeDatabase(file));
    await DriftShopProfileRepository(
      firstRun,
      storageDir: () async => storage,
    ).save(profile.copyWith(gstin: '27AAPFU0939F1ZV'));
    await firstRun.close();

    final secondRun = AppDatabase(NativeDatabase(file));
    final loaded = await DriftShopProfileRepository(
      secondRun,
      storageDir: () async => storage,
    ).load();
    await secondRun.close();

    expect(loaded?.name, 'Sharma General Store');
    expect(loaded?.gstin, '27AAPFU0939F1ZV');
    expect(loaded?.stateCode, '27');
  });
}
