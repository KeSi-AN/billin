import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/money/money.dart';

void main() {
  group('Money.tryParse', () {
    test('parses whole rupees, decimals and Indian formatting', () {
      expect(Money.tryParse('99'), const Money.paise(9900));
      expect(Money.tryParse('0.5'), const Money.paise(50));
      expect(Money.tryParse('0.05'), const Money.paise(5));
      expect(Money.tryParse('1,00,000.75'), const Money.paise(10000075));
      expect(Money.tryParse(' ₹ 12.30 '), const Money.paise(1230));
    });

    test('rejects invalid input', () {
      for (final bad in ['', 'abc', '-5', '1.234', '1.2.3', '.5', '1e3']) {
        expect(Money.tryParse(bad), isNull, reason: bad);
      }
    });
  });

  group('Money arithmetic', () {
    test('adds and subtracts in whole paise, no float drift', () {
      // 0.1 + 0.2 != 0.3 with doubles; in paise it is exact.
      final total = Money.tryParse('0.10')! + Money.tryParse('0.20')!;
      expect(total, Money.tryParse('0.30'));
      expect(
        const Money.rupees(10) - const Money.paise(1),
        const Money.paise(999),
      );
      expect(const Money.paise(1250).times(3), const Money.paise(3750));
    });

    test('compares', () {
      expect(const Money.paise(1) > Money.zero, isTrue);
      expect(const Money.paise(-1).isNegative, isTrue);
      expect(Money.zero.isZero, isTrue);
    });
  });

  group('Money.format', () {
    test('uses lakh/crore grouping', () {
      expect(const Money.paise(10000000).format(), '₹1,00,000.00');
      expect(const Money.paise(1234567890).format(), '₹1,23,45,678.90');
      expect(const Money.paise(5).format(), '₹0.05');
      expect(const Money.paise(-25050).format(), '-₹250.50');
      expect(const Money.rupees(999).format(withSymbol: false), '999.00');
    });
  });
}
