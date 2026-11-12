import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/item_import.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Returns the picked file's bytes, or `null` if cancelled.
typedef PickSpreadsheet = Future<Uint8List?> Function();

/// Hands a file to the share sheet (save to Drive, WhatsApp, email…).
typedef ShareSpreadsheet = Future<void> Function(String path, String text);

Future<Uint8List?> _pickWithSystem() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['xlsx', 'csv'],
  );
  if (files.isEmpty) return null;
  return await files.single.xFile.readAsBytes();
}

Future<void> _shareWithSystem(String path, String text) async {
  await SharePlus.instance.share(ShareParams(files: [XFile(path)], text: text));
}

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({
    this.pickFile = _pickWithSystem,
    this.shareFile = _shareWithSystem,
    this.tempDir = getTemporaryDirectory,
    super.key,
  });

  final PickSpreadsheet pickFile;
  final ShareSpreadsheet shareFile;
  final Future<Directory> Function() tempDir;

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

sealed class _Stage {
  const _Stage();
}

class _Idle extends _Stage {
  const _Idle();
}

class _Busy extends _Stage {
  const _Busy(this.message, [this.progress]);

  final String message;
  final double? progress;
}

class _Preview extends _Stage {
  const _Preview(this.plan);

  final ImportPlan plan;
}

class _Done extends _Stage {
  const _Done(this.result);

  final ImportResult result;
}

class _ImportExportPageState extends State<ImportExportPage> {
  _Stage _stage = const _Idle();

  ItemImporter get _importer => ItemImporter(
    items: context.read<ItemRepository>(),
    inventory: context.read<InventoryRepository>(),
  );

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context);
    final importer = _importer;
    final bytes = await widget.pickFile();
    if (bytes == null || !mounted) return;
    setState(() => _stage = _Busy(l10n.importReading));
    try {
      final plan = await importer.plan(readSpreadsheet(bytes));
      if (mounted) setState(() => _stage = _Preview(plan));
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _stage = const _Idle());
      showSnack(context, l10n.importFailed(e.toString()));
    }
  }

  Future<void> _apply(ImportPlan plan) async {
    final l10n = AppLocalizations.of(context);
    final importer = _importer;
    final result = await importer.apply(
      plan,
      onProgress: (done, total) {
        if (mounted) {
          setState(
            () =>
                _stage = _Busy(l10n.importProgress(done, total), done / total),
          );
        }
      },
    );
    if (mounted) setState(() => _stage = _Done(result));
  }

  Future<void> _share(Rows rows, String fileName) async {
    final l10n = AppLocalizations.of(context);
    final shop = await context.read<ShopProfileRepository>().load();
    try {
      final dir = Directory(p.join((await widget.tempDir()).path, 'exports'));
      await dir.create(recursive: true);
      final file = File(p.join(dir.path, fileName));
      await file.writeAsBytes(
        writeXlsx(rows, numericColumns: itemNumericColumns),
        flush: true,
      );
      await widget.shareFile(file.path, l10n.exportShareText(shop?.name ?? ''));
    } on Object {
      if (mounted) showSnack(context, l10n.exportFailed);
    }
  }

  Future<void> _export() async {
    final rows = await exportItems(
      context.read<ItemRepository>(),
      context.read<InventoryRepository>(),
    );
    final today = DateTime.now();
    final stamp =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await _share(rows, 'Items_$stamp.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.importExportTitle)),
      body: switch (_stage) {
        _Idle() => ListView(
          children: [
            ListTile(
              key: const Key('importTile'),
              leading: const Icon(Icons.upload_file),
              title: Text(l10n.importTitle),
              subtitle: Text(l10n.importSubtitle),
              onTap: _import,
            ),
            ListTile(
              key: const Key('exportTile'),
              leading: const Icon(Icons.download_outlined),
              title: Text(l10n.exportTitle),
              subtitle: Text(l10n.exportSubtitle),
              onTap: _export,
            ),
            ListTile(
              key: const Key('templateTile'),
              leading: const Icon(Icons.table_chart_outlined),
              title: Text(l10n.templateTitle),
              subtitle: Text(l10n.templateSubtitle),
              onTap: () => _share(itemTemplate(), 'Items_template.xlsx'),
            ),
          ],
        ),
        _Busy(:final message, :final progress) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
        ),
        _Preview(:final plan) => _PreviewView(
          plan: plan,
          onImport: () => _apply(plan),
          onCancel: () => setState(() => _stage = const _Idle()),
        ),
        _Done(:final result) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.importDone(result.created, result.updated),
                  key: const Key('importDoneText'),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (result.failed > 0)
                  Text(l10n.importDoneFailed(result.failed)),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.importViewItems),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }
}

class _PreviewView extends StatelessWidget {
  const _PreviewView({
    required this.plan,
    required this.onImport,
    required this.onCancel,
  });

  final ImportPlan plan;
  final VoidCallback onImport;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final count = plan.creates + plan.updates;
    final invalid = plan.invalid.toList();
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.importSummary(plan.creates, plan.updates, invalid.length),
                key: const Key('importSummary'),
                style: text.titleMedium,
              ),
              if (plan.unknownHeaders.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.importUnknownColumns(plan.unknownHeaders.join(', ')),
                  ),
                ),
              if (plan.updates > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(l10n.importStockNote, style: text.bodySmall),
                ),
              if (invalid.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.importErrorsTitle, style: text.titleSmall),
                for (final row in invalid)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.error_outline, color: scheme.error),
                    title: Text(l10n.importRow(row.rowNumber)),
                    subtitle: Text(row.errors.join('\n')),
                  ),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TextButton(onPressed: onCancel, child: Text(l10n.cancel)),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    key: const Key('importGoButton'),
                    onPressed: count == 0 ? null : onImport,
                    child: Text(
                      count == 0 ? l10n.importNothing : l10n.importGo(count),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
