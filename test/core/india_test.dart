import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/india/phone.dart';

/// Builds a GSTIN with a correct check character from its first 14 chars.
String withCheck(String first14) => first14 + Gstin.checkCharacter(first14);

void main() {
  group('Gstin', () {
    test('accepts a GSTIN with a correct check character', () {
      final gstin = withCheck('27AAPFU0939F1Z');
      expect(Gstin.validate(gstin), isNull);
      expect(Gstin.stateCode(gstin), '27');
    });

    test('normalizes case and spaces', () {
      final gstin = withCheck('29ABCDE1234F1Z');
      expect(Gstin.validate(' ${gstin.toLowerCase()} '), isNull);
    });

    test('catches a single mistyped character (checksum)', () {
      final gstin = withCheck('07AAACB1234C1Z');
      final last = gstin[14];
      final wrong = gstin.substring(0, 14) + (last == 'A' ? 'B' : 'A');
      expect(Gstin.validate(wrong), GstinError.checksum);
    });

    test('reports structural problems', () {
      expect(Gstin.validate('27AAPFU0939F1Z'), GstinError.length);
      expect(Gstin.validate('27AAPFU0939F1X5'), GstinError.format);
      expect(Gstin.validate(withCheck('99AAPFU0939F1Z')), GstinError.unknownState);
    });
  });

  group('Indian states', () {
    test('codes are unique and two digits', () {
      final codes = indianStates.map((s) => s.code).toList();
      expect(codes.toSet().length, codes.length);
      expect(codes.every((c) => RegExp(r'^\d{2}$').hasMatch(c)), isTrue);
      expect(stateByCode('27')?.name, 'Maharashtra');
      expect(stateByCode('25'), isNull);
    });
  });

  group('IndianPhone', () {
    test('normalizes common formats', () {
      expect(IndianPhone.normalize('+91 98765 43210'), '9876543210');
      expect(IndianPhone.normalize('098765-43210'), '9876543210');
    });

    test('validates mobile numbers', () {
      expect(IndianPhone.isValidMobile('9876543210'), isTrue);
      expect(IndianPhone.isValidMobile('+919876543210'), isTrue);
      expect(IndianPhone.isValidMobile('5876543210'), isFalse);
      expect(IndianPhone.isValidMobile('98765'), isFalse);
    });

    test('validates PIN codes', () {
      expect(isValidPincode('400001'), isTrue);
      expect(isValidPincode('040001'), isFalse);
      expect(isValidPincode('4000'), isFalse);
    });
  });
}
