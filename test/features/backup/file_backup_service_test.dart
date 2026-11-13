import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/backup/data/file_backup_service.dart';
import 'package:shop_app/features/backup/domain/backup.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';

import '../../helpers/fakes.dart';

/// One phone: a database file plus app storage and temp folders.
class Phone {
  Phone(Directory root, String name)
    : dir = Directory(p.join(root.path, name))..createSync(),
      _now = DateTime(2026, 11, 13, 21, 5);

  final Directory dir;
  final DateTime _now;
  late AppDatabase db;

  File get dbFile => File(p.join(dir.path, 'shop_app.sqlite'));
  Directory get storage =>
      Directory(p.join(dir.path, 'files'))..createSync(recursive: true);
  Directory get temp =>
      Directory(p.join(dir.path, 'cache'))..createSync(recursive: true);

  void open() => db = AppDatabase(NativeDatabase(dbFile));

  DriftItemRepository get items =>
      DriftItemRepository(db, storageDir: () async => storage);

  FileBackupService get backup => FileBackupService(
    db,
    databaseFile: () async => dbFile,
    storageDir: () async => storage,
    tempDir: () async => temp,
    clock: () => _now,
  );
}

void main() {
  late Directory root;

  setUp(() => root = Directory.systemTemp.createTempSync('backup_test'));
  tearDown(() => root.deleteSync(recursive: true));

  test('back up, then restore onto a new phone (photos relinked)', () async {
    final old = Phone(root, 'old')..open();
    await DriftShopProfileRepository(
      old.db,
      storageDir: () async => old.storage,
    ).save(testShop);
    final photo = File(p.join(root.path, 'photo.jpg'))
      ..writeAsBytesSync([1, 2, 3, 4]);
    final imagePath = await old.items.importImage(photo.path);
    await old.items.save(
      Item(
        name: 'Parle-G',
        salePrice: const Money.rupees(10),
        imagePath: imagePath,
      ),
    );

    expect(await old.backup.lastBackupAt(), isNull);
    final path = await old.backup.create();
    expect(p.basename(path), 'ShopBackup_2026-11-13_2105.zip');
    expect(await old.backup.lastBackupAt(), DateTime(2026, 11, 13, 21, 5));
    final bytes = File(path).readAsBytesSync();

    final info = await old.backup.inspect(bytes);
    expect(info.shopName, testShop.name);
    expect(info.items, 1);
    expect(info.schemaVersion, old.db.schemaVersion);
    await old.db.close();

    // The new phone already has something else on it: replaced.
    final fresh = Phone(root, 'new')..open();
    await fresh.items.save(
      const Item(name: 'Old junk', salePrice: Money.rupees(1)),
    );
    await fresh.backup.restore(bytes);

    fresh.open(); // as the app does after a restart
    final restored = await fresh.items.watchAll().first;
    expect(restored.map((i) => i.name), ['Parle-G']);
    final newPhoto = restored.single.imagePath!;
    expect(p.isWithin(fresh.storage.path, newPhoto), isTrue);
    expect(File(newPhoto).readAsBytesSync(), [1, 2, 3, 4]);
    final shop = await DriftShopProfileRepository(
      fresh.db,
      storageDir: () async => fresh.storage,
    ).load();
    expect(shop!.name, testShop.name);
    await fresh.db.close();
  });

  test('rejects files that are not backups', () async {
    final phone = Phone(root, 'p')..open();
    addTearDown(phone.db.close);
    expect(
      () => phone.backup.inspect(Uint8List.fromList([1, 2, 3])),
      throwsA(isA<InvalidBackupException>()),
    );
    final notOurs = Archive()
      ..addFile(ArchiveFile('readme.txt', 2, utf8.encode('hi')));
    expect(
      () => phone.backup.restore(
        Uint8List.fromList(ZipEncoder().encode(notOurs)),
      ),
      throwsA(isA<InvalidBackupException>()),
    );
  });

  test('refuses a backup from a newer app, leaving data alone', () async {
    final phone = Phone(root, 'p')..open();
    await phone.items.save(
      const Item(name: 'Kept', salePrice: Money.rupees(5)),
    );
    final future = Archive()
      ..addFile(
        ArchiveFile.string(
          'manifest.json',
          jsonEncode({
            'app': 'shop_app',
            'schemaVersion': 99,
            'createdAt': '2027-01-01T00:00:00.000',
          }),
        ),
      )
      ..addFile(ArchiveFile('shop_app.sqlite', 3, [0, 0, 0]));
    await expectLater(
      phone.backup.restore(Uint8List.fromList(ZipEncoder().encode(future))),
      throwsA(isA<BackupTooNewException>()),
    );
    final items = await phone.items.watchAll().first;
    expect(items.single.name, 'Kept');
    await phone.db.close();
  });
}
