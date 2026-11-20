import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/features/backup/data/file_backup_service.dart';
import 'package:shop_app/features/backup/domain/backup.dart';
import 'package:workmanager/workmanager.dart';

/// The nightly backup time: 10:30 pm.
const nightlyBackupHour = 22;
const nightlyBackupMinute = 30;

/// The most recent 10:30 pm at or before [now].
DateTime lastBackupSlot(DateTime now) {
  final today = DateTime(
    now.year,
    now.month,
    now.day,
    nightlyBackupHour,
    nightlyBackupMinute,
  );
  return now.isBefore(today)
      ? DateTime(
          today.year,
          today.month,
          today.day - 1,
          today.hour,
          today.minute,
        )
      : today;
}

/// Time until the next 10:30 pm after [now].
Duration untilNextSlot(DateTime now) {
  final slot = lastBackupSlot(now);
  final next = DateTime(
    slot.year,
    slot.month,
    slot.day + 1,
    slot.hour,
    slot.minute,
  );
  return next.difference(now);
}

/// A backup is due when none has been made since the last 10:30 pm.
bool backupDue(DateTime? last, DateTime now) =>
    last == null || last.isBefore(lastBackupSlot(now));

const _task = 'nightlyBackup';

/// Asks Android to run a backup around 10:30 pm every night.
/// Android picks the exact moment (it batches background work to save
/// battery), so the app also catches up when opened: see
/// [backupIfDue].
Future<void> scheduleNightlyBackup() async {
  await Workmanager().initialize(nightlyBackupDispatcher);
  await Workmanager().registerPeriodicTask(
    _task,
    _task,
    frequency: const Duration(days: 1),
    initialDelay: untilNextSlot(DateTime.now()),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

/// Runs a backup if one is due (the phone was off at 10:30 pm, the app
/// was killed…). Also finishes a Downloads copy a night-time backup
/// couldn't make.
Future<void> backupIfDue(BackupService backup, {DateTime? now}) async {
  try {
    if (backupDue(await backup.lastBackupAt(), now ?? DateTime.now())) {
      await backup.create();
    } else {
      await backup.syncPublicCopy();
    }
  } on Object catch (e) {
    debugPrint('Automatic backup failed: $e');
  }
}

/// Copies a backup to Downloads/ShopBackups through `DownloadsChannel.kt`.
/// Returns `false` where the channel isn't available (background engine,
/// older Android).
Future<bool> copyBackupToDownloads(String path) async {
  try {
    return await const MethodChannel('shop_app/downloads')
            .invokeMethod<bool>('saveBackup', {'path': path}) ??
        false;
  } on MissingPluginException {
    return false;
  }
}

/// The backup service wired to the real phone folders.
FileBackupService phoneBackupService(AppDatabase db) => FileBackupService(
  db,
  databaseFile: AppDatabase.file,
  storageDir: getApplicationSupportDirectory,
  tempDir: getTemporaryDirectory,
  keepDir: getExternalStorageDirectory,
  publicCopy: copyBackupToDownloads,
);

/// Entry point Android calls in the background.
@pragma('vm:entry-point')
void nightlyBackupDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task != _task) return true;
    WidgetsFlutterBinding.ensureInitialized();
    final db = AppDatabase();
    try {
      await phoneBackupService(db).create();
      return true;
    } on Object catch (e) {
      debugPrint('Nightly backup failed: $e');
      return false; // WorkManager retries later.
    } finally {
      await db.close();
    }
  });
}
