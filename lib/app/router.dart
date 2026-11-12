import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/billing/presentation/bill_page.dart';
import 'package:shop_app/features/billing/presentation/billing_page.dart';
import 'package:shop_app/features/billing/presentation/sales_page.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/presentation/customer_form_page.dart';
import 'package:shop_app/features/customers/presentation/customer_page.dart';
import 'package:shop_app/features/customers/presentation/customers_page.dart';
import 'package:shop_app/features/expenses/presentation/expenses_page.dart';
import 'package:shop_app/features/home/presentation/home_page.dart';
import 'package:shop_app/features/inventory/presentation/item_stock_page.dart';
import 'package:shop_app/features/inventory/presentation/stock_overview_page.dart';
import 'package:shop_app/features/items/import_export/import_export_page.dart';
import 'package:shop_app/features/items/presentation/item_form_page.dart';
import 'package:shop_app/features/items/presentation/items_page.dart';
import 'package:shop_app/features/printing/presentation/labels_page.dart';
import 'package:shop_app/features/printing/presentation/printer_settings_page.dart';
import 'package:shop_app/features/purchases/presentation/purchase_form_page.dart';
import 'package:shop_app/features/purchases/presentation/purchase_page.dart';
import 'package:shop_app/features/purchases/presentation/purchases_page.dart';
import 'package:shop_app/features/reports/presentation/reports_page.dart';
import 'package:shop_app/features/scanner/scan_page.dart';
import 'package:shop_app/features/settings/presentation/billing_settings_page.dart';
import 'package:shop_app/features/settings/presentation/settings_page.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/pages/shop_setup_page.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const setup = '/setup';
  static const home = '/home';
  static const billing = '/billing';
  static const sales = '/bills';
  static String bill(int id, {bool justSaved = false}) =>
      '/bills/$id${justSaved ? '?saved=1' : ''}';
  static const items = '/items';
  static const newItem = '/items/new';
  static String newItemWithBarcode(String barcode) =>
      Uri(path: newItem, queryParameters: {'barcode': barcode}).toString();
  static String editItem(int id) => '/items/$id';
  static String itemStock(int id) => '/items/$id/stock';
  static const stock = '/stock';
  static const importExport = '/items/transfer';
  static const labels = '/labels';
  static const customers = '/customers';
  static const suppliers = '/suppliers';
  static String _base(PartyType t) =>
      t == PartyType.supplier ? suppliers : customers;
  static String customer(int id) => '/customers/$id';
  static String party(PartyType t, int id) => '${_base(t)}/$id';
  static String editParty(PartyType t, int id) => '${_base(t)}/$id/edit';
  static String newParty(PartyType t, {String? name}) => Uri(
    path: '${_base(t)}/new',
    queryParameters: name == null || name.isEmpty ? null : {'name': name},
  ).toString();
  static String newCustomer({String? name}) =>
      newParty(PartyType.customer, name: name);
  static const purchases = '/purchases';
  static const newPurchase = '/purchases/new';
  static String purchase(int id) => '/purchases/$id';
  static const expenses = '/expenses';
  static const reports = '/reports';
  static const scan = '/scan';
  static const settings = '/settings';
  static const editShop = '/settings/shop';
  static const billingSettings = '/settings/billing';
  static const printerSettings = '/settings/printer';
}

/// Routes, plus the first-launch rule: no shop profile → setup screen.
GoRouter buildRouter(ShopProfileCubit profile) => GoRouter(
  initialLocation: AppRoutes.splash,
  // Re-check redirects only when the *kind* of state changes (loading →
  // missing → ready). Re-running them on every profile edit would rebuild
  // the route stack mid-navigation and undo a `pop()`.
  refreshListenable: _StreamListenable(
    profile.stream.map((s) => s.runtimeType).distinct(),
  ),
  redirect: (context, state) {
    final at = state.matchedLocation;
    return switch (profile.state) {
      ShopProfileLoading() => at == AppRoutes.splash ? null : AppRoutes.splash,
      ShopProfileMissing() => at == AppRoutes.setup ? null : AppRoutes.setup,
      ShopProfileReady() =>
        at == AppRoutes.splash || at == AppRoutes.setup ? AppRoutes.home : null,
    };
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: AppRoutes.setup,
      builder: (context, state) => const ShopSetupPage(isEditing: false),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.billing,
      builder: (context, state) => const BillingPage(),
    ),
    GoRoute(
      path: AppRoutes.sales,
      builder: (context, state) => const SalesPage(),
    ),
    GoRoute(
      path: '/bills/:id',
      builder: (context, state) => BillPage(
        billId: int.parse(state.pathParameters['id']!),
        justSaved: state.uri.queryParameters['saved'] == '1',
      ),
    ),
    GoRoute(
      path: AppRoutes.items,
      builder: (context, state) => const ItemsPage(),
    ),
    GoRoute(
      path: AppRoutes.newItem,
      builder: (context, state) =>
          ItemFormPage(initialBarcode: state.uri.queryParameters['barcode']),
    ),
    GoRoute(
      path: AppRoutes.importExport,
      builder: (context, state) => const ImportExportPage(),
    ),
    GoRoute(
      path: '/items/:id',
      builder: (context, state) =>
          ItemFormPage(itemId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/items/:id/stock',
      builder: (context, state) =>
          ItemStockPage(itemId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: AppRoutes.stock,
      builder: (context, state) => const StockOverviewPage(),
    ),
    GoRoute(
      path: '/customers',
      builder: (context, state) => const CustomersPage(),
    ),
    GoRoute(
      path: '/customers/new',
      builder: (context, state) =>
          CustomerFormPage(initialName: state.uri.queryParameters['name']),
    ),
    GoRoute(
      path: '/customers/:id',
      builder: (context, state) =>
          CustomerPage(partyId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/customers/:id/edit',
      builder: (context, state) =>
          CustomerFormPage(partyId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/suppliers',
      builder: (context, state) =>
          const CustomersPage(type: PartyType.supplier),
    ),
    GoRoute(
      path: '/suppliers/new',
      builder: (context, state) => CustomerFormPage(
        type: PartyType.supplier,
        initialName: state.uri.queryParameters['name'],
      ),
    ),
    GoRoute(
      path: '/suppliers/:id',
      builder: (context, state) =>
          CustomerPage(partyId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/suppliers/:id/edit',
      builder: (context, state) => CustomerFormPage(
        type: PartyType.supplier,
        partyId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.purchases,
      builder: (context, state) => const PurchasesPage(),
    ),
    GoRoute(
      path: AppRoutes.newPurchase,
      builder: (context, state) => const PurchaseFormPage(),
    ),
    GoRoute(
      path: '/purchases/:id',
      builder: (context, state) =>
          PurchasePage(purchaseId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: AppRoutes.expenses,
      builder: (context, state) => const ExpensesPage(),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => const ReportsPage(),
    ),
    GoRoute(
      path: AppRoutes.labels,
      builder: (context, state) => const LabelsPage(),
    ),
    GoRoute(
      path: AppRoutes.scan,
      builder: (context, state) => const ScanPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.editShop,
      builder: (context, state) => const ShopSetupPage(isEditing: true),
    ),
    GoRoute(
      path: AppRoutes.billingSettings,
      builder: (context, state) => const BillingSettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.printerSettings,
      builder: (context, state) => const PrinterSettingsPage(),
    ),
  ],
);

class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
