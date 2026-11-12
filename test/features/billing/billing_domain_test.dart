import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/format/amount_in_words.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

void main() {
  group('divRound', () {
    test('rounds halves away from zero', () {
      expect(divRound(5, 2), 3);
      expect(divRound(4, 3), 1);
      expect(divRound(-5, 2), -3);
      expect(divRound(0, 7), 0);
    });
  });

  group('Quantity', () {
    test('parses and formats', () {
      expect(Quantity.tryParse('2'), const Quantity.whole(2));
      expect(Quantity.tryParse('0.5'), const Quantity.milli(500));
      expect(Quantity.tryParse('1.250'), const Quantity.milli(1250));
      expect(Quantity.tryParse('1.2345'), isNull);
      expect(Quantity.tryParse('-1'), isNull);
      expect(const Quantity.milli(500).format(), '0.5');
      expect(const Quantity.milli(1250).format(), '1.25');
      expect(const Quantity.milli(1).format(), '0.001');
      expect(const Quantity.whole(12).format(), '12');
    });
  });

  group('TaxRate', () {
    test('labels', () {
      expect(const TaxRate(1800).label, '18%');
      expect(const TaxRate(25).label, '0.25%');
      expect(const TaxRate(250).label, '2.5%');
      expect(TaxRate.zero.label, '0%');
      expect(const TaxRate(1800).halfLabel, '9%');
      expect(const TaxRate(500).halfLabel, '2.5%');
    });
  });

  group('Invoice numbers', () {
    test('financial year runs April to March', () {
      expect(FinancialYear.of(DateTime(2026, 3, 31)).short, '25-26');
      expect(FinancialYear.of(DateTime(2026, 4)).short, '26-27');
      expect(FinancialYear.of(DateTime(2099, 12)).short, '99-00');
    });

    test('format stays within the GST 16-character limit', () {
      const fy = FinancialYear(2026);
      expect(
        InvoiceNumber.format(prefix: 'INV', year: fy, sequence: 1),
        'INV/26-27/0001',
      );
      expect(
        InvoiceNumber.format(prefix: '', year: fy, sequence: 42),
        '26-27/0042',
      );
      final longest = InvoiceNumber.format(
        prefix: 'ABCD',
        year: fy,
        sequence: 99999,
      );
      expect(longest.length <= 16, isTrue, reason: longest);
    });

    test('prefix rules', () {
      expect(InvoiceNumber.isValidPrefix('INV'), isTrue);
      expect(InvoiceNumber.isValidPrefix(''), isTrue);
      expect(InvoiceNumber.isValidPrefix('inv'), isFalse);
      expect(InvoiceNumber.isValidPrefix('TOOLONG'), isFalse);
      expect(InvoiceNumber.isValidPrefix('A/B'), isFalse);
    });
  });

  group('Amount in words', () {
    test('uses lakh and crore', () {
      expect(numberInIndianWords(0), 'Zero');
      expect(numberInIndianWords(15), 'Fifteen');
      expect(numberInIndianWords(105), 'One Hundred Five');
      expect(numberInIndianWords(100000), 'One Lakh');
      expect(
        numberInIndianWords(12345678),
        'One Crore Twenty Three Lakh Forty Five Thousand Six Hundred Seventy Eight',
      );
    });

    test('formats invoice amounts', () {
      expect(
        amountInWords(const Money.paise(125050)),
        'Rupees One Thousand Two Hundred Fifty and Fifty Paise Only',
      );
      expect(
        amountInWords(const Money.rupees(500)),
        'Rupees Five Hundred Only',
      );
    });
  });
}
