import 'package:shop_app/features/billing/domain/upi.dart';
import 'package:shop_app/features/customers/domain/party.dart';

/// The WhatsApp payment reminder text.
String reminderMessage({
  required Party party,
  required String shopName,
  String? upiId,
}) {
  final due = party.balance.format();
  final lines = [
    'Namaste ${party.name},',
    'Your pending balance at $shopName is $due.',
    if (upiId != null) ...[
      'Pay by UPI to $upiId, or tap:',
      upiPaymentUri(
        upiId: upiId,
        payeeName: shopName,
        amount: party.balance,
        note: 'Dues $shopName',
      ),
    ],
    'Thank you!',
  ];
  return lines.join('\n');
}

/// `https://wa.me/919876543210?text=...` opens a chat with the message
/// typed in, ready to send (the shopkeeper still taps Send).
Uri whatsAppUri(String phone, String message) => Uri(
  scheme: 'https',
  host: 'wa.me',
  path: '/91$phone',
  queryParameters: {'text': message},
);
