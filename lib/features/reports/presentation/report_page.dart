import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/data/report_loader.dart';
import 'package:shop_app/features/reports/domain/business_reports.dart';
import 'package:shop_app/features/reports/domain/report_doc.dart';
import 'package:shop_app/features/reports/domain/report_pdf.dart';
import 'package:shop_app/features/reports/presentation/period_picker.dart';
import 'package:shop_app/features/reports/presentation/report_export.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Rows shown on screen per table; exports always have everything.
const screenRowLimit = 300;

/// One business report with a period filter and PDF / Excel export.
class ReportPage extends StatefulWidget {
  const ReportPage({
    required this.kind,
    this.shareFile = shareReportWithSystem,
    this.tempDir = getTemporaryDirectory,
    this.loadFonts = InvoiceFonts.load,
    super.key,
  });

  final ReportKind kind;
  final ShareReport shareFile;
  final Future<Directory> Function() tempDir;
  final Future<InvoiceFonts> Function() loadFonts;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Period _period = Period.of(
    widget.kind == ReportKind.dayBook
        ? PeriodPreset.today
        : PeriodPreset.thisMonth,
    DateTime.now(),
  );
  late Future<ReportDoc> _doc = _load();
  bool _exporting = false;

  /// Stock value is "as of now": no period to pick.
  bool get _hasPeriod => widget.kind != ReportKind.stockValue;

  Future<ReportDoc> _load() async {
    final l10n = AppLocalizations.of(context);
    final loader = ReportLoader(
      shopProfiles: context.read<ShopProfileRepository>(),
      bills: context.read<BillRepository>(),
      returns: context.read<ReturnsRepository>(),
      purchases: context.read<PurchaseRepository>(),
      expenses: context.read<ExpenseRepository>(),
      items: context.read<ItemRepository>(),
      parties: context.read<PartyRepository>(),
    );
    final input = await loader.load(_period.from, _period.to);
    return BusinessReports(input, l10n).build(widget.kind);
  }

  void _setPeriod(Period p) => setState(() {
    _period = p;
    _doc = _load();
  });

  Future<void> _export(ReportDoc doc, {required bool pdf}) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _exporting = true);
    try {
      final shop = (await context.read<ShopProfileRepository>().load())!;
      final name = exportName(doc.title, _period.from);
      final bytes = pdf
          ? await ReportPdf(await widget.loadFonts()).build(
              doc,
              shopName: shop.name,
              labels: (
                amountsIn: l10n.rpAmountsIn,
                generated: l10n.rpGenerated,
              ),
            )
          : writeWorkbook(doc.sheets(l10n.rpSummary, l10n.rpValue));
      final path = await saveExport(
        widget.tempDir,
        '$name.${pdf ? 'pdf' : 'xlsx'}',
        bytes,
      );
      await widget.shareFile(
        path,
        l10n.rpShareText(doc.title, doc.periodLabel, shop.name),
      );
    } on Object {
      if (mounted) showSnack(context, l10n.exportFailed);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<ReportDoc>(
      future: _doc,
      builder: (context, snapshot) {
        final doc = snapshot.data;
        final ready =
            doc != null && snapshot.connectionState == ConnectionState.done;
        return Scaffold(
          appBar: AppBar(
            title: Text(doc?.title ?? ''),
            actions: [
              IconButton(
                key: const Key('exportPdfButton'),
                tooltip: l10n.rpExportPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: ready && !_exporting
                    ? () => _export(doc, pdf: true)
                    : null,
              ),
              IconButton(
                key: const Key('exportExcelButton'),
                tooltip: l10n.rpExportExcel,
                icon: const Icon(Icons.table_view_outlined),
                onPressed: ready && !_exporting
                    ? () => _export(doc, pdf: false)
                    : null,
              ),
            ],
          ),
          body: Column(
            children: [
              if (_hasPeriod) ...[
                const SizedBox(height: 8),
                PeriodPicker(value: _period, onChanged: _setPeriod),
              ],
              Expanded(
                child: snapshot.hasError
                    ? Center(child: Text(l10n.rpLoadFailed))
                    : !ready
                    ? const Center(child: CircularProgressIndicator())
                    : ReportView(doc: doc, showPeriod: _hasPeriod),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A [ReportDoc] on screen: summary card, notes, then each table.
class ReportView extends StatelessWidget {
  const ReportView({required this.doc, this.showPeriod = true, super.key});

  final ReportDoc doc;
  final bool showPeriod;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      key: const Key('reportView'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        if (showPeriod)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(doc.periodLabel, style: text.labelLarge),
          ),
        if (doc.summary.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final (label, value) in doc.summary)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Expanded(child: Text(label)),
                          Text(
                            cellText(value),
                            key: Key('summary_$label'),
                            style: text.titleSmall?.copyWith(
                              color: value is Amount && value.isNegative
                                  ? scheme.error
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        for (final n in doc.notes)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              n,
              style: text.bodySmall?.copyWith(color: scheme.tertiary),
            ),
          ),
        for (final t in doc.tables) ...[
          const SizedBox(height: 16),
          Text(t.title, style: text.titleMedium),
          const SizedBox(height: 4),
          if (t.rows.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.rpEmpty),
            )
          else
            _TableView(table: t),
          if (t.rows.length > screenRowLimit)
            Text(
              l10n.rpMoreRows(screenRowLimit, t.rows.length),
              style: text.bodySmall,
            ),
        ],
      ],
    );
  }
}

class _TableView extends StatelessWidget {
  const _TableView({required this.table});

  final ReportTable table;

  @override
  Widget build(BuildContext context) {
    final numeric = table.numericColumns;
    final bold = Theme.of(context).textTheme.labelLarge;
    DataRow row(List<Object?> cells, {bool total = false}) => DataRow(
      cells: [
        for (var c = 0; c < table.columns.length; c++)
          DataCell(
            Text(
              c < cells.length ? cellText(cells[c]) : '',
              style: total ? bold : null,
            ),
          ),
      ],
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        horizontalMargin: 8,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 52,
        columns: [
          for (var c = 0; c < table.columns.length; c++)
            DataColumn(
              label: Text(table.columns[c]),
              numeric: numeric.contains(c),
            ),
        ],
        rows: [
          for (final r in table.rows.take(screenRowLimit)) row(r),
          if (table.totals != null) row(table.totals!, total: true),
        ],
      ),
    );
  }
}
