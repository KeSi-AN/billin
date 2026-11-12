import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/customers/domain/party.dart';

/// Reaching out to a customer: WhatsApp reminder, statement PDF. An
/// interface so screens don't depend on url_launcher / PDF code directly.
abstract interface class CustomerActions {
  Future<void> remind(BuildContext context, Party party);

  Future<void> shareStatement(BuildContext context, Party party);
}
