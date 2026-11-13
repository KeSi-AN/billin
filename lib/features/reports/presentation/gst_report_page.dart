import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/core/widgets/month_switcher.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/data/report_loader.dart';
import 'package:shop_app/features/reports/domain/gst_report.dart';
import 'package:shop_app/features/reports/presentation/report_export.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Month summary (sales, profit, GST) and the GST export for the CA.
class GstReportPage extends StatefulWidget {
  const GstReportPage({
    this.shareFile = shareReportWithSystem,
    this.tempDir = getTemporaryDirectory,
    super.key,
  });

  final ShareReport shareFile;
  final Future<Directory> Function() tempDir;

  @override
  State<GstReportPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<GstReportPage> {
  DateTime _month = monthStart(DateTime.now());
  late Future<GstReport> _report = _load();
  bool _exporting = false;

  Future<GstReport> _load() async {
    final loader = ReportLoader(
      shopProfiles: context.read<ShopProfileRepository>(),
      bills: context.read<BillRepository>(),
      returns: context.read<ReturnsRepository>(),
      purchases: context.read<PurchaseRepository>(),
      expenses: context.read<ExpenseRepository>(),
    );
    return GstReport(await loader.load(_month, nextMonth(_month)));
  }

  void _setMonth(DateTime m) => setState(() {
    _month = m;
    _report = _load();
  });

  Future<void> _export(GstReport report) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _exporting = true);
    try {
      final dir = Directory(p.join((await widget.tempDir()).path, 'exports'));
      await dir.create(recursive: true);
      final stamp = DateFormat('yyyy-MM').format(_month);
      final file = File(p.join(dir.path, 'GST_$stamp.xlsx'));
      await file.writeAsBytes(writeWorkbook(report.workbook()), flush: true);
      await widget.shareFile(
        file.path,
        l10n.reportsShareText(
          DateFormat('MMMM y').format(_month),
          report.input.shop.name,
        ),
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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: Column(
        children: [
          MonthSwitcher(
            month: _month,
            onChanged: _setMonth,
            previousLabel: l10n.reportsPreviousMonth,
            nextLabel: l10n.reportsNextMonth,
          ),
          Expanded(
            child: FutureBuilder<GstReport>(
              key: ValueKey(_month),
              future: _report,
              builder: (context, snapshot) {
                final report = snapshot.data;
                if (report == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _ReportBody(
                  report: report,
                  exporting: _exporting,
                  onExport: () => _export(report),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({
    required this.report,
    required this.exporting,
    required this.onExport,
  });

  final GstReport report;
  final bool exporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final s = report.summary();
    final warnings = report.warnings();

    Widget row(String label, Money amount, {Key? key, bool strong = false}) {
      final style = strong ? text.titleMedium : text.bodyMedium;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label, style: style)),
            Text(amount.format(), key: key, style: style),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reportsBills(s.billCount), style: text.labelLarge),
                const SizedBox(height: 8),
                row(l10n.reportsSales, s.sales, key: const Key('reportSales')),
                if (s.returns.isPositive) row(l10n.reportsReturns, -s.returns),
                row(l10n.reportsNetSales, s.netSales, strong: true),
                const Divider(height: 20),
                row(
                  s.profitIsPartial
                      ? l10n.reportsGrossProfitPartial
                      : l10n.reportsGrossProfit,
                  s.grossProfit,
                ),
                row(l10n.reportsExpenses, -s.expenses),
                row(
                  l10n.reportsNetProfit,
                  s.netProfit,
                  key: const Key('reportNetProfit'),
                  strong: true,
                ),
                const Divider(height: 20),
                row(l10n.reportsPurchases, s.purchases),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reportsGstTitle, style: text.titleMedium),
                const SizedBox(height: 8),
                row(l10n.reportsOutputTax, s.netOutputTax),
                row(l10n.reportsInputTax, -s.totalInputTax),
                if (s.gstPayable.isNegative)
                  row(
                    l10n.reportsGstCredit,
                    -s.gstPayable,
                    key: const Key('reportGstPayable'),
                    strong: true,
                  )
                else
                  row(
                    l10n.reportsGstPayable,
                    s.gstPayable,
                    key: const Key('reportGstPayable'),
                    strong: true,
                  ),
              ],
            ),
          ),
        ),
        if (warnings.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(
            color: scheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.reportsNotes,
                    style: text.titleSmall?.copyWith(
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                  for (final w in warnings)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '• $w',
                        style: TextStyle(color: scheme.onTertiaryContainer),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const Key('exportGstButton'),
          onPressed: exporting ? null : onExport,
          icon: const Icon(Icons.table_view_outlined),
          label: Text(l10n.reportsExport),
        ),
        const SizedBox(height: 8),
        Text(l10n.reportsExportHelp, style: text.bodySmall),
      ],
    );
  }
}
