import 'dart:typed_data';

/// What a backup file holds (read from its manifest before restoring).
class BackupInfo {
  const BackupInfo({
    required this.createdAt,
    required this.schemaVersion,
    this.shopName,
    this.bills = 0,
    this.items = 0,
    this.parties = 0,
  });

  final DateTime createdAt;

  /// Database version the backup was made with. Older ones are upgraded on
  /// restore; newer ones need the app updated first.
  final int schemaVersion;
  final String? shopName;
  final int bills;
  final int items;
  final int parties;
}

/// Not one of this app's backups (or damaged).
class InvalidBackupException implements Exception {
  const InvalidBackupException();

  @override
  String toString() => 'Not a backup from this app';
}

/// Made by a newer version of the app: update before restoring.
class BackupTooNewException implements Exception {
  const BackupTooNewException();

  @override
  String toString() => 'Backup is from a newer version of the app';
}

/// The whole shop (database, item photos and logo) as one file, so data
/// survives a lost or reset phone before cloud sync exists.
abstract interface class BackupService {
  /// Writes a backup file and returns its path (to share or save).
  Future<String> create();

  /// Reads a backup's manifest. Throws [InvalidBackupException].
  Future<BackupInfo> inspect(Uint8List bytes);

  /// Replaces everything on this phone with [bytes]. The database is
  /// closed afterwards: the app must restart its services.
  /// Throws [InvalidBackupException] or [BackupTooNewException].
  Future<void> restore(Uint8List bytes);

  /// When [create] last succeeded on this phone, if ever.
  Future<DateTime?> lastBackupAt();
}
