import 'package:material_ui/material_ui.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

extension PaymentModeLabel on PaymentMode {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMode.cash => l10n.paymentCash,
    PaymentMode.upi => l10n.paymentUpi,
    PaymentMode.card => l10n.paymentCard,
    PaymentMode.credit => l10n.paymentCredit,
  };

  IconData get icon => switch (this) {
    PaymentMode.cash => Icons.payments_outlined,
    PaymentMode.upi => Icons.qr_code_2,
    PaymentMode.card => Icons.credit_card,
    PaymentMode.credit => Icons.schedule,
  };
}
