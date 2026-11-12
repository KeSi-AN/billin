import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/data/drift_returns_repository.dart';
import 'package:shop_app/features/customers/data/channel_contact_picker.dart';
import 'package:shop_app/features/customers/data/drift_party_repository.dart';
import 'package:shop_app/features/customers/presentation/app_customer_actions.dart';
import 'package:shop_app/features/expenses/data/drift_expense_repository.dart';
import 'package:shop_app/features/inventory/data/drift_inventory_repository.dart';
import 'package:shop_app/features/inventory/data/notification_stock_alerts.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
import 'package:shop_app/features/printing/presentation/app_bill_actions.dart';
import 'package:shop_app/features/purchases/data/drift_purchase_repository.dart';
import 'package:shop_app/features/settings/data/drift_settings_repository.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDateFormatting();

  final db = AppDatabase();
  final shopProfiles = DriftShopProfileRepository(
    db,
    storageDir: getApplicationSupportDirectory,
  );
  final settings = DriftSettingsRepository(db);
  final printer = PrinterService(MethodChannelPrinterTransport(), settings);
  final parties = DriftPartyRepository(db);

  runApp(
    ShopApp(
      services: AppServices(
        shopProfiles: shopProfiles,
        items: DriftItemRepository(
          db,
          storageDir: getApplicationSupportDirectory,
        ),
        bills: DriftBillRepository(db),
        settings: settings,
        printer: printer,
        inventory: DriftInventoryRepository(db),
        stockAlerts: NotificationStockAlerts(),
        parties: parties,
        contactPicker: ChannelContactPicker(),
        purchases: DriftPurchaseRepository(db),
        returns: DriftReturnsRepository(db),
        expenses: DriftExpenseRepository(db),
        customerActions: AppCustomerActions(
          parties: parties,
          shopProfiles: shopProfiles,
          settings: settings,
          tempDir: getTemporaryDirectory,
          shareFile: shareFileWithSystem,
        ),
        billActions: AppBillActions(
          printer: printer,
          settings: settings,
          shopProfiles: shopProfiles,
          tempDir: getTemporaryDirectory,
        ),
      ),
    ),
  );
}
