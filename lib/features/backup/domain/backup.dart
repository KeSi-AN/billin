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

  /// When a backup was last sent off the phone (Drive, WhatsApp…): the
  /// only copy that survives a lost phone.
  Future<DateTime?> lastSharedAt();

  /// Records that a backup was just handed to the share sheet.
  Future<void> markShared();

  /// Copies the newest kept backup to Downloads if that hasn't happened yet
  /// (a night-time backup can't always reach Downloads on its own).
  Future<void> syncPublicCopy();
}

/// How many backups are kept on the phone (older ones are deleted).
const keptBackups = 14;
