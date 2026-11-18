import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/printing/domain/receipt_template.dart';
import 'package:shop_app/features/printing/domain/sample_bill.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

import '../../helpers/fakes.dart';

const sadiya = ShopProfile(
  name: 'Sadiya Fashion',
  phone: '9849985750',
  addressLine: '8-4-31, near Visakha Eye Hospital, Nauka Nagar',
  city: 'Visakhapatnam',
  stateCode: '37',
  pincode: '530017',
);

const upi = AppSettingsData(upiId: 'sadiya@okaxis');

List<String> text(Bill bill, ShopProfile shop, AppSettingsData s, int w) =>
    ReceiptFormatter(width: w)
        .lines(bill, shop, s)
        .map((l) => l.toString())
        .toList();

void main() {
  final at = DateTime(2026, 9, 24, 18, 43, 5);

  test('80mm bill matches the shop layout', () {
    final lines = text(sampleBill(gst: false, at: at), sadiya, upi, 48);
    expect(lines.take(3), [
      'Sadiya Fashion',
      '9849985750',
      'Address: 8-4-31, near Visakha Eye Hospital,',
    ]);
    expect(lines, contains('Date: 24 Sep 2026 06:43:05 PM'));
    expect(lines, contains('Payment: UPI'));
    expect(lines, contains('ITEM                    QTY.     RATE     AMOUNT'));
    expect(lines, contains('kurti set                  1     1555       1555'));
    expect(lines, contains('SAREE                      1      775        775'));
    expect(lines, contains('Disc : -75'.padLeft(48)));
    expect(lines, contains('Total Qty: 2'));
    expect(lines, contains('Subtotal:                                   2330'));
    expect(lines, contains('Total Discount:                              -75'));
    expect(lines, contains('TOTAL                                    Rs 2255'));
    expect(
      lines,
      contains(
        [
          '[QR upi://pay?pa=sadiya%40okaxis',
          'pn=Sadiya%20Fashion',
          'am=2255.00',
          'cu=INR',
          'tn=SAMPLE]',
        ].join('&'),
      ),
    );
    expect(lines.sublist(lines.length - 4), [
      'SCAN TO PAY',
      '-' * 48,
      'Thank you for shopping with us!',
      'Visit again',
    ]);
    for (final l in lines.where((l) => !l.startsWith('[QR'))) {
      expect(l.length, lessThanOrEqualTo(48), reason: l);
    }
  });

  test('GSTIN and the GST breakup appear once the shop has a GSTIN', () {
    const gstShop = ShopProfile(
      name: 'Sadiya Fashion',
      stateCode: '37',
      gstin: '37AAPFU0939F1ZV',
    );
    final lines = text(sampleBill(gst: true, at: at), gstShop, upi, 48);
    expect(lines, contains('GSTIN: 37AAPFU0939F1ZV'));
    expect(lines, contains('TAX INVOICE'));
    expect(lines.any((l) => l.startsWith('  CGST 2.5%:')), isTrue);
    expect(lines, contains('(GST included in prices)'));
    // Prices include GST, so the total doesn't change.
    expect(lines, contains('TOTAL                                    Rs 2255'));
  });

  test('template switches lines off and changes the text', () {
    final s = upi.copyWith(
      receiptTemplate: const ReceiptTemplate(
        showPhone: false,
        showRate: false,
        showTotalQty: false,
        addressLabel: '',
        headerNote: 'No exchange without bill',
        qrCaption: 'Pay by any UPI app',
        footer: 'Shukriya!',
      ),
    );
    final lines = text(sampleBill(gst: false, at: at), sadiya, s, 48);
    expect(lines, isNot(contains('9849985750')));
    expect(lines[1], startsWith('8-4-31'));
    expect(lines, contains('No exchange without bill'));
    expect(lines, contains('ITEM                             QTY.     AMOUNT'));
    expect(lines.where((l) => l.startsWith('Total Qty')), isEmpty);
    expect(lines, contains('Pay by any UPI app'));
    expect(lines.last, 'Shukriya!');
  });

  group('payment QR', () {
    Bill bill(PaymentMode mode, {Money due = Money.zero}) {
      final b = sampleBill(gst: false, at: at);
      return Bill(
        id: 1,
        invoiceNo: 'INV/26-27/0007',
        billedAt: at,
        lines: b.lines,
        itemsTotal: b.itemsTotal,
        billDiscount: b.billDiscount,
        taxable: b.taxable,
        tax: b.tax,
        roundOff: b.roundOff,
        grandTotal: b.grandTotal,
        paymentMode: mode,
        due: due,
      );
    }

    String? qr(Bill b, QrMode mode, {String? upiId = 'sadiya@okaxis'}) =>
        ReceiptFormatter.upiUri(
          b,
          sadiya,
          AppSettingsData(
            upiId: upiId,
            receiptTemplate: ReceiptTemplate(qrMode: mode),
          ),
        );

    test('carries the bill total', () {
      expect(
        qr(bill(PaymentMode.upi), QrMode.upiAndCredit),
        contains('am=2255.00'),
      );
    });

    test('credit bills ask only for what is still due', () {
      final b = bill(PaymentMode.credit, due: const Money.rupees(1255));
      expect(qr(b, QrMode.upiAndCredit), contains('am=1255.00'));
    });

    test('cash bills only with "all bills"; never when off', () {
      expect(qr(bill(PaymentMode.cash), QrMode.upiAndCredit), isNull);
      expect(qr(bill(PaymentMode.cash), QrMode.always), contains('am=2255.00'));
      expect(qr(bill(PaymentMode.upi), QrMode.off), isNull);
    });

    test('needs a UPI ID', () {
      expect(qr(bill(PaymentMode.upi), QrMode.always, upiId: null), isNull);
    });
  });

  test('template survives a JSON round trip; bad JSON falls back', () {
    const t = ReceiptTemplate(
      showLogo: false,
      logoWidthPercent: 80,
      qrMode: QrMode.always,
      footer: 'Line 1\nLine 2',
    );
    expect(ReceiptTemplate.fromJson(t.toJson()), t);
    expect(ReceiptTemplate.fromJson('{oops'), const ReceiptTemplate());
    expect(ReceiptTemplate.fromJson(null), const ReceiptTemplate());
  });

  group('logo', () {
    Uint8List png() {
      // 100×50 logo: black left half, transparent right half.
      final image = img.Image(width: 100, height: 50, numChannels: 4);
      for (final p in image) {
        p.setRgba(0, 0, 0, p.x < 50 ? 255 : 0);
      }
      return img.encodePng(image);
    }

    test('is scaled, made black and white, and centred on the paper', () {
      final logo = MonoImage.fromEncoded(png(), paperDots: 576, percent: 50)!;
      expect(logo.width, 576);
      expect(logo.height, 144); // 288 dots wide, same shape
      const left = (576 - 288) ~/ 2;
      expect(logo.isBlack(left + 10, 70), isTrue); // black half
      expect(logo.isBlack(left + 250, 70), isFalse); // transparent = paper
      expect(logo.isBlack(5, 70), isFalse); // margin
    });

    test('not an image: no logo', () {
      expect(
        MonoImage.fromEncoded(Uint8List.fromList([1, 2, 3]), paperDots: 384),
        isNull,
      );
    });

    test('is printed only when the shop has one and the template allows', () {
      final withLogo = sadiya.copyWith(logoPath: '/logo.png');
      expect(
        text(sampleBill(gst: false, at: at), withLogo, upi, 48).first,
        '[LOGO]',
      );
      expect(
        text(
          sampleBill(gst: false, at: at),
          withLogo,
          upi.copyWith(receiptTemplate: const ReceiptTemplate(showLogo: false)),
          48,
        ).first,
        'Sadiya Fashion',
      );
    });

    test('goes out as raster bands (GS v 0)', () {
      final logo = MonoImage.fromEncoded(png(), paperDots: 384)!;
      final bytes = const ReceiptFormatter(width: 32).bytes(
        sampleBill(gst: false, at: at),
        sadiya.copyWith(logoPath: '/logo.png'),
        upi,
        logo: logo,
      );
      final header = [0x1D, 0x76, 0x30, 0x00, 48, 0];
      var found = false;
      for (var i = 0; i + header.length < bytes.length; i++) {
        if (List.generate(6, (j) => bytes[i + j]).join(',') ==
            header.join(',')) {
          found = true;
          break;
        }
      }
      expect(found, isTrue);
    });
  });

  test('58mm: every line fits 32 columns', () {
    final b = sampleBill(gst: false, at: at);
    for (final l in text(
      b,
      sadiya,
      upi,
      32,
    ).where((l) => !l.startsWith('[QR'))) {
      expect(l.length, lessThanOrEqualTo(32), reason: l);
    }
    expect(EscPosBuilder.toAscii('Rs 2255'), 'Rs 2255');
    expect(Quantity.one.format(), '1');
    expect(testShop.name, isNotEmpty);
  });
}
