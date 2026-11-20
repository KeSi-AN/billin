import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/features/backup/data/auto_backup.dart';

import '../../helpers/fakes.dart';

void main() {
  test('the backup slot is the last 10:30 pm', () {
    expect(
      lastBackupSlot(DateTime(2026, 11, 20, 22, 45)),
      DateTime(2026, 11, 20, 22, 30),
    );
    expect(
      lastBackupSlot(DateTime(2026, 11, 20, 9)),
      DateTime(2026, 11, 19, 22, 30),
    );
    // Across a month end.
    expect(
      lastBackupSlot(DateTime(2026, 12, 1, 8)),
      DateTime(2026, 11, 30, 22, 30),
    );
  });

  test('next run is the coming 10:30 pm', () {
    expect(
      untilNextSlot(DateTime(2026, 11, 20, 22)),
      const Duration(minutes: 30),
    );
    expect(
      untilNextSlot(DateTime(2026, 11, 20, 23)),
      const Duration(hours: 23, minutes: 30),
    );
  });

  test('due when nothing has been backed up since the last 10:30 pm', () {
    final morning = DateTime(2026, 11, 20, 9);
    expect(backupDue(null, morning), isTrue);
    // Last night's backup ran: nothing to do this morning.
    expect(backupDue(DateTime(2026, 11, 19, 22, 40), morning), isFalse);
    // Missed last night (phone off): catch up.
    expect(backupDue(DateTime(2026, 11, 19, 20), morning), isTrue);
  });

  test(
    'backupIfDue makes a backup, or only syncs the Downloads copy',
    () async {
      final backup = FakeBackup()..last = DateTime(2026, 11, 18, 23);
      await backupIfDue(backup, now: DateTime(2026, 11, 20, 9));
      expect(backup.created, hasLength(1));

      await backupIfDue(backup, now: DateTime.now());
      expect(backup.created, hasLength(1));
      expect(backup.publicSyncs, 1);
    },
  );
}
