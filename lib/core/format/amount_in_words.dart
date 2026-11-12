import 'package:shop_app/core/money/money.dart';

const _ones = [
  '',
  'One',
  'Two',
  'Three',
  'Four',
  'Five',
  'Six',
  'Seven',
  'Eight',
  'Nine',
  'Ten',
  'Eleven',
  'Twelve',
  'Thirteen',
  'Fourteen',
  'Fifteen',
  'Sixteen',
  'Seventeen',
  'Eighteen',
  'Nineteen',
];
const _tens = [
  '',
  '',
  'Twenty',
  'Thirty',
  'Forty',
  'Fifty',
  'Sixty',
  'Seventy',
  'Eighty',
  'Ninety',
];

String _belowHundred(int n) {
  if (n < 20) return _ones[n];
  final rest = n % 10;
  return rest == 0 ? _tens[n ~/ 10] : '${_tens[n ~/ 10]} ${_ones[rest]}';
}

String _belowThousand(int n) {
  final hundreds = n ~/ 100;
  final rest = n % 100;
  final parts = [
    if (hundreds > 0) '${_ones[hundreds]} Hundred',
    if (rest > 0) _belowHundred(rest),
  ];
  return parts.join(' ');
}

/// Whole number in Indian words: 1,23,45,678 → "One Crore Twenty Three Lakh
/// Forty Five Thousand Six Hundred Seventy Eight".
String numberInIndianWords(int n) {
  if (n == 0) return 'Zero';
  if (n < 0) return 'Minus ${numberInIndianWords(-n)}';
  final crore = n ~/ 10000000;
  final lakh = (n % 10000000) ~/ 100000;
  final thousand = (n % 100000) ~/ 1000;
  final rest = n % 1000;
  return [
    if (crore > 0) '${numberInIndianWords(crore)} Crore',
    if (lakh > 0) '${_belowHundred(lakh)} Lakh',
    if (thousand > 0) '${_belowHundred(thousand)} Thousand',
    if (rest > 0) _belowThousand(rest),
  ].join(' ');
}

/// For invoices: "Rupees One Thousand Two Hundred and Fifty Paise Only".
String amountInWords(Money amount) {
  final rupees = amount.paise.abs() ~/ 100;
  final paise = amount.paise.abs() % 100;
  final sign = amount.isNegative ? 'Minus ' : '';
  final paisePart = paise > 0 ? ' and ${_belowHundred(paise)} Paise' : '';
  return '${sign}Rupees ${numberInIndianWords(rupees)}$paisePart Only';
}
