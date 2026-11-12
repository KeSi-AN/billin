import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/billing/domain/bill.dart';

/// Print and share for a saved bill. An interface so screens don't depend on
/// Bluetooth or PDF code directly, and tests can pass a fake.
abstract interface class BillActions {
  Future<void> print(BuildContext context, Bill bill);

  Future<void> share(BuildContext context, Bill bill);
}
