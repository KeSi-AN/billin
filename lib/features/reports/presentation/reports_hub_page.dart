import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/reports/domain/business_reports.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// All reports, one tap each.
class ReportsHubPage extends StatelessWidget {
  const ReportsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    (IconData, String, String) info(ReportKind k) => switch (k) {
      ReportKind.sales => (
        Icons.receipt_long_outlined,
        l10n.rpSales,
        l10n.rpSalesHelp,
      ),
      ReportKind.purchases => (
        Icons.local_shipping_outlined,
        l10n.rpPurchases,
        l10n.rpPurchasesHelp,
      ),
      ReportKind.profitLoss => (
        Icons.trending_up,
        l10n.rpProfitLoss,
        l10n.rpProfitLossHelp,
      ),
      ReportKind.stockValue => (
        Icons.warehouse_outlined,
        l10n.rpStockValue,
        l10n.rpStockValueHelp,
      ),
      ReportKind.itemWise => (
        Icons.inventory_2_outlined,
        l10n.rpItemWise,
        l10n.rpItemWiseHelp,
      ),
      ReportKind.customerWise => (
        Icons.people_outline,
        l10n.rpCustomerWise,
        l10n.rpCustomerWiseHelp,
      ),
      ReportKind.dayBook => (
        Icons.menu_book_outlined,
        l10n.rpDayBook,
        l10n.rpDayBookHelp,
      ),
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: ListView(
        children: [
          ListTile(
            key: const Key('report_gst'),
            leading: const Icon(Icons.account_balance_outlined),
            title: Text(l10n.rpGstReturns),
            subtitle: Text(l10n.rpGstHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.gstReport),
          ),
          for (final k in ReportKind.values)
            ListTile(
              key: Key('report_${k.name}'),
              leading: Icon(info(k).$1),
              title: Text(info(k).$2),
              subtitle: Text(info(k).$3),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.report(k)),
            ),
        ],
      ),
    );
  }
}
