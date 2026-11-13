import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/backup/domain/backup.dart';

/// A zip with `manifest.json`, the SQLite database and the photo folders.
///
/// The database copy is made with `VACUUM INTO`, which gives a consistent
/// snapshot while the app keeps running.
class FileBackupService implements BackupService {
  FileBackupService(
    this._db, {
    required this._databaseFile,
    required this._storageDir,
    required this._tempDir,
    this._clock = DateTime.now,
  });

  final AppDatabase _db;

  /// The live database file (closed and replaced on restore).
  final Future<File> Function() _databaseFile;

  /// App storage holding [mediaFolders] and the last-backup marker.
  final Future<Directory> Function() _storageDir;
  final Future<Directory> Function() _tempDir;
  final DateTime Function() _clock;

  static const formatVersion = 1;
  static const _manifest = 'manifest.json';
  static const _database = 'shop_app.sqlite';
  static const _marker = 'last_backup.txt';

  /// Folders in app storage that belong in a backup.
  static const mediaFolders = ['item_images', 'logos'];

  Future<int> _count(String table) async {
    final row = await _db
        .customSelect('SELECT COUNT(*) AS c FROM $table')
        .getSingle();
    return row.read<int>('c');
  }

  @override
  Future<String> create() async {
    final now = _clock();
    final work = Directory(p.join((await _tempDir()).path, 'backup_work'));
    if (work.existsSync()) await work.delete(recursive: true);
    await work.create(recursive: true);

    final dbCopy = File(p.join(work.path, _database));
    await _db.customStatement(
      "VACUUM INTO '${dbCopy.path.replaceAll("'", "''")}'",
    );
    final shop = await _db
        .customSelect('SELECT name FROM shop_profiles LIMIT 1')
        .getSingleOrNull();
    final manifest = {
      'app': 'shop_app',
      'format': formatVersion,
      'schemaVersion': _db.schemaVersion,
      'createdAt': now.toIso8601String(),
      'shopName': shop?.read<String>('name'),
      'bills': await _count('bills'),
      'items': await _count('items'),
      'parties': await _count('parties'),
    };

    final archive = Archive();
    void add(String name, List<int> data) =>
        archive.addFile(ArchiveFile(name, data.length, data));
    add(_manifest, utf8.encode(jsonEncode(manifest)));
    add(_database, await dbCopy.readAsBytes());
    final storage = await _storageDir();
    for (final folder in mediaFolders) {
      final dir = Directory(p.join(storage.path, folder));
      if (!dir.existsSync()) continue;
      for (final f in dir.listSync().whereType<File>()) {
        add('$folder/${p.basename(f.path)}', await f.readAsBytes());
      }
    }
    final bytes = ZipEncoder().encode(archive);
    await work.delete(recursive: true);

    final out = Directory(p.join((await _tempDir()).path, 'exports'));
    await out.create(recursive: true);
    String two(int n) => n.toString().padLeft(2, '0');
    final stamp =
        '${now.year}-${two(now.month)}-${two(now.day)}_${two(now.hour)}${two(now.minute)}';
    final file = File(p.join(out.path, 'ShopBackup_$stamp.zip'));
    await file.writeAsBytes(bytes, flush: true);
    await File(p.join(storage.path, _marker))
        .writeAsString(now.toIso8601String());
    return file.path;
  }

  Archive _decode(Uint8List bytes) {
    try {
      return ZipDecoder().decodeBytes(bytes);
    } on Object {
      throw const InvalidBackupException();
    }
  }

  BackupInfo _info(Archive zip) {
    final manifest = zip.findFile(_manifest);
    if (manifest == null || zip.findFile(_database) == null) {
      throw const InvalidBackupException();
    }
    try {
      final m =
          jsonDecode(utf8.decode(manifest.content)) as Map<String, Object?>;
      if (m['app'] != 'shop_app') throw const InvalidBackupException();
      return BackupInfo(
        createdAt: DateTime.parse(m['createdAt']! as String),
        schemaVersion: m['schemaVersion']! as int,
        shopName: m['shopName'] as String?,
        bills: m['bills'] as int? ?? 0,
        items: m['items'] as int? ?? 0,
        parties: m['parties'] as int? ?? 0,
      );
    } on InvalidBackupException {
      rethrow;
    } on Object {
      throw const InvalidBackupException();
    }
  }

  @override
  Future<BackupInfo> inspect(Uint8List bytes) async => _info(_decode(bytes));

  @override
  Future<void> restore(Uint8List bytes) async {
    final zip = _decode(bytes);
    final info = _info(zip);
    if (info.schemaVersion > _db.schemaVersion) {
      throw const BackupTooNewException();
    }
    final storage = await _storageDir();
    final work = Directory(p.join((await _tempDir()).path, 'restore_work'));
    if (work.existsSync()) await work.delete(recursive: true);
    await work.create(recursive: true);

    // Open the backup on its own first: this upgrades an older backup to
    // the current schema and points photo paths at this phone's storage.
    final staged = File(p.join(work.path, _database));
    await staged.writeAsBytes(zip.findFile(_database)!.content, flush: true);
    final copy = AppDatabase(NativeDatabase(staged));
    try {
      await _relink(copy, 'items', 'image_path', storage);
      await _relink(copy, 'shop_profiles', 'logo_path', storage);
    } finally {
      await copy.close();
    }

    // Swap the live database for the staged one.
    await _db.close();
    final live = await _databaseFile();
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File('${live.path}$suffix');
      if (f.existsSync()) await f.delete();
    }
    await staged.copy(live.path);

    for (final folder in mediaFolders) {
      final dir = Directory(p.join(storage.path, folder));
      if (dir.existsSync()) await dir.delete(recursive: true);
    }
    for (final f in zip.files) {
      final folder = p.posix.dirname(f.name);
      if (!f.isFile || !mediaFolders.contains(folder)) continue;
      final target = File(
        p.join(storage.path, folder, p.posix.basename(f.name)),
      );
      await target.parent.create(recursive: true);
      await target.writeAsBytes(f.content, flush: true);
    }
    await work.delete(recursive: true);
  }

  /// Photo paths are absolute; the folder name and file name are what
  /// matter. Re-point them at [storage] (a new phone or app flavour).
  static Future<void> _relink(
    AppDatabase db,
    String table,
    String column,
    Directory storage,
  ) async {
    final rows = await db
        .customSelect(
          'SELECT id, $column AS path FROM $table WHERE $column IS NOT NULL',
        )
        .get();
    for (final r in rows) {
      final old = r.read<String>('path');
      final parts = old.replaceAll(r'\', '/').split('/');
      final folder = parts.length > 1 ? parts[parts.length - 2] : '';
      final next = mediaFolders.contains(folder)
          ? p.join(storage.path, folder, parts.last)
          : null;
      await db.customUpdate(
        'UPDATE $table SET $column = ? WHERE id = ?',
        variables: [Variable(next), Variable(r.read<int>('id'))],
      );
    }
  }

  @override
  Future<DateTime?> lastBackupAt() async {
    final f = File(p.join((await _storageDir()).path, _marker));
    if (!f.existsSync()) return null;
    return DateTime.tryParse((await f.readAsString()).trim());
  }
}
