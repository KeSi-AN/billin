import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/app_restarter.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/backup/domain/backup.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/reports/presentation/report_export.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Returns the picked file's bytes, or `null` if cancelled.
typedef PickBackup = Future<Uint8List?> Function();

Future<Uint8List?> _pickWithSystem() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['zip'],
  );
  if (files.isEmpty) return null;
  return await files.single.xFile.readAsBytes();
}

/// Back up to a file (Google Drive, WhatsApp to self…) and restore from one.
class BackupPage extends StatefulWidget {
  const BackupPage({
    this.pickFile = _pickWithSystem,
    this.shareFile = shareReportWithSystem,
    super.key,
  });

  final PickBackup pickFile;
  final ShareReport shareFile;

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  late Future<DateTime?> _last = _loadLast();
  bool _busy = false;

  Future<DateTime?> _loadLast() => context.read<BackupService>().lastBackupAt();

  Future<void> _backup() async {
    final l10n = AppLocalizations.of(context);
    final backup = context.read<BackupService>();
    setState(() => _busy = true);
    try {
      final path = await backup.create();
      await widget.shareFile(path, l10n.backupShareText);
      if (mounted) showSnack(context, l10n.backupDone);
    } on Object {
      if (mounted) showSnack(context, l10n.backupFailed);
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _last = _loadLast();
        });
      }
    }
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    final backup = context.read<BackupService>();
    final bytes = await widget.pickFile();
    if (bytes == null || !mounted) return;
    final BackupInfo info;
    try {
      info = await backup.inspect(bytes);
    } on InvalidBackupException {
      if (mounted) showSnack(context, l10n.restoreInvalid);
      return;
    }
    if (!mounted) return;
    final ok = await confirm(
      context,
      title: l10n.restoreConfirmTitle,
      body: l10n.restoreConfirmBody(
        info.shopName ?? '—',
        formatDateTime(info.createdAt),
        info.bills,
        info.items,
      ),
      confirmLabel: l10n.restoreConfirm,
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await backup.restore(bytes);
    } on BackupTooNewException {
      if (mounted) {
        setState(() => _busy = false);
        showSnack(context, l10n.restoreTooNew);
      }
      return;
    } on Object {
      if (mounted) {
        setState(() => _busy = false);
        showSnack(context, l10n.restoreFailed);
      }
      return;
    }
    if (!mounted) return;
    // The database was swapped: start the whole app again on it.
    if (!AppRestarter.restart(context)) {
      setState(() => _busy = false);
      showSnack(context, l10n.restoreDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: scheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.backupWhy,
                    style: TextStyle(color: scheme.onSecondaryContainer),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<DateTime?>(
                    future: _last,
                    builder: (context, snapshot) => Text(
                      snapshot.data == null
                          ? l10n.backupNever
                          : l10n.backupLast(formatDateTime(snapshot.data!)),
                      key: const Key('lastBackup'),
                      style: text.titleSmall?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('backupNowButton'),
            onPressed: _busy ? null : _backup,
            icon: const Icon(Icons.cloud_upload_outlined),
            label: Text(l10n.backupNow),
          ),
          const SizedBox(height: 8),
          Text(l10n.backupHowTo, style: text.bodySmall),
          const Divider(height: 40),
          OutlinedButton.icon(
            key: const Key('restoreButton'),
            onPressed: _busy ? null : _restore,
            icon: const Icon(Icons.settings_backup_restore),
            label: Text(l10n.restoreFromFile),
          ),
          const SizedBox(height: 8),
          Text(l10n.restoreHelp, style: text.bodySmall),
          if (_busy) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

/// Home nudge when the last backup is old (or there has never been one
/// and there is something to lose).
class BackupReminder extends StatefulWidget {
  const BackupReminder({super.key});

  static const maxAge = Duration(days: 7);

  @override
  State<BackupReminder> createState() => _BackupReminderState();
}

class _BackupReminderState extends State<BackupReminder> {
  late Future<(DateTime?, bool)> _state = _check();

  /// The last backup, and whether to nag: never backed up but already
  /// billing, or the backup is older than [BackupReminder.maxAge].
  Future<(DateTime?, bool)> _check() async {
    final bills = context.read<BillRepository>();
    final last = await context.read<BackupService>().lastBackupAt();
    if (last != null) {
      return (last, DateTime.now().difference(last) >= BackupReminder.maxAge);
    }
    final now = DateTime.now();
    final recent = await bills.billsBetween(
      now.subtract(const Duration(days: 30)),
      now.add(const Duration(days: 1)),
    );
    return (null, recent.isNotEmpty);
  }

  Future<void> _open() async {
    await context.push(AppRoutes.backup);
    if (!mounted) return;
    setState(() {
      _state = _check();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return FutureBuilder<(DateTime?, bool)>(
      future: _state,
      builder: (context, snapshot) {
        final (last, show) = snapshot.data ?? (null, false);
        if (!show) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Card(
            key: const Key('backupReminder'),
            color: scheme.tertiaryContainer,
            child: ListTile(
              leading: Icon(
                Icons.cloud_off_outlined,
                color: scheme.onTertiaryContainer,
              ),
              title: Text(
                last == null
                    ? l10n.backupReminderNever
                    : l10n.backupReminderOld(
                        DateTime.now().difference(last).inDays,
                      ),
                style: TextStyle(color: scheme.onTertiaryContainer),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: scheme.onTertiaryContainer,
              ),
              onTap: _open,
            ),
          ),
        );
      },
    );
  }
}
