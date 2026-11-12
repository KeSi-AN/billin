import 'package:shop_app/core/money/money.dart';

/// A UPI deep link any UPI app can scan to pay this exact amount:
/// `upi://pay?pa=shop@okaxis&pn=Sharma%20Kirana&am=170.00&cu=INR&tn=...`
String upiPaymentUri({
  required String upiId,
  required String payeeName,
  required Money amount,
  String? note,
}) {
  final rupees = amount.paise ~/ 100;
  final paise = (amount.paise % 100).toString().padLeft(2, '0');
  final params = {
    'pa': upiId.trim(),
    'pn': payeeName.trim(),
    'am': '$rupees.$paise',
    'cu': 'INR',
    if (note != null && note.isNotEmpty) 'tn': note,
  };
  final query = params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');
  return 'upi://pay?$query';
}
