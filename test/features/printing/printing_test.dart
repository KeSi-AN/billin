import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/billing/domain/upi.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
import 'package:shop_app/features/printing/domain/esc_pos.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

import '../../helpers/fakes.dart';

/// A realistic bill built through the same fake the app tests use.
Future<Bill> sampleBill({
  PaymentMode mode = PaymentMode.upi,
  bool cancel = false,
}) async {
  final bills = FakeBills(FakeSettings());
  final bill = await bills.create(
    BillDraft(
      paymentMode: mode,
      customerName: 'Ravi',
      billDiscount: const Money.rupees(2),
      lines: const [
        DraftLine(
          name: 'Parle-G 100g',
          unitPrice: Money.rupees(10),
          quantity: Quantity.whole(2),
          taxRate: TaxRate(500),
        ),
        DraftLine(
          name: 'Basmati rice premium long grain extra',
          unit: 'kg',
          unitPrice: Money.paise(12050),
          quantity: Quantity.milli(1500),
          taxRate: TaxRate(500),
          priceIncludesTax: false,
          discount: Money.rupees(5),
        ),
      ],
    ),
  );
  if (cancel) await bills.cancel(bill.id, reason: 'test');
  return (await bills.byId(bill.id))!;
}

void main() {
  setUpAll(initDateFormatting);

  group('EscPosBuilder', () {
    test('init, bold, size, text, cut', () {
      final bytes =
          (EscPosBuilder()
                ..init()
                ..bold()
                ..size(width: 2, height: 2)
                ..line('Hi')
                ..cut())
              .build();
      expect(bytes, [
        0x1B, 0x40, // init
        0x1B, 0x45, 1, // bold
        0x1D, 0x21, 0x11, // 2x2
        0x48, 0x69, 0x0A, // "Hi\n"
        0x1D, 0x56, 0x42, 0x00, // cut
      ]);
    });

    test('QR store command carries the data length', () {
      final bytes = (EscPosBuilder()..qr('ABC')).build();
      final store = [0x1D, 0x28, 0x6B, 6, 0, 0x31, 0x50, 0x30, 65, 66, 67];
      expect(_containsSequence(bytes, store), isTrue);
    });

    test('non-ASCII becomes printable', () {
      expect(EscPosBuilder.toAscii('₹10 × 2 – “ok”'), 'Rs.10 x 2 - "ok"');
      expect(EscPosBuilder.toAscii('चाय'), '???');
    });
  });

  group('ReceiptFormatter', () {
    for (final width in [32, 48]) {
      test('every line fits $width columns and the numbers add up', () async {
        final bill = await sampleBill();
        final lines = ReceiptFormatter(
          width: width,
        ).lines(bill, testShop, const AppSettingsData(upiId: 'sharma@okaxis'));
        for (final l in lines) {
          final limit = l.big ? width ~/ 2 : width;
          expect(l.text.length <= limit, isTrue, reason: '"${l.text}"');
        }
        final text = lines.map((l) => l.text).join('\n');
        expect(text, contains('TAX INVOICE'));
        expect(text, contains('GSTIN: 27AAPFU0939F1ZV'));
        expect(text, contains('No: ${bill.invoiceNo}'));
        expect(
          text,
          contains('Rs.${bill.grandTotal.format(withSymbol: false)}'),
        );
        expect(text, contains('GST summary'));
        expect(text, contains('Paid by UPI'));
        expect(lines.where((l) => l.qrData != null), hasLength(1));
      });
    }

    test('no UPI QR for cash, none when cancelled', () async {
      const settings = AppSettingsData(upiId: 'sharma@okaxis');
      const f = ReceiptFormatter(width: 32);
      final cash = await sampleBill(mode: PaymentMode.cash);
      expect(
        f.lines(cash, testShop, settings).where((l) => l.qrData != null),
        isEmpty,
      );
      final cancelled = await sampleBill(cancel: true);
      final text = f.lines(cancelled, testShop, settings);
      expect(text.where((l) => l.qrData != null), isEmpty);
      expect(
        text.map((l) => l.text),
        contains('       *** CANCELLED ***'.trim()),
      );
    });

    test('bytes start with init and end with a cut', () async {
      final bytes = const ReceiptFormatter(width: 32)
          .bytes(await sampleBill(), testShop, const AppSettingsData());
      expect(bytes.take(2), [0x1B, 0x40]);
      expect(bytes.skip(bytes.length - 4), [0x1D, 0x56, 0x42, 0x00]);
    });
  });

  test('UPI link', () {
    expect(
      upiPaymentUri(
        upiId: 'sharma@okaxis',
        payeeName: 'Sharma Kirana',
        amount: const Money.paise(17050),
        note: 'INV/26-27/0001',
      ),
      'upi://pay?pa=sharma%40okaxis&pn=Sharma%20Kirana&am=170.50&cu=INR&tn=INV%2F26-27%2F0001',
    );
  });

  group('InvoicePdf', () {
    test('builds a PDF for GST, non-GST and cancelled bills', () async {
      const pdf = InvoicePdf(InvoiceFonts());
      for (final (bill, shop) in [
        (await sampleBill(), testShop),
        (
          await sampleBill(mode: PaymentMode.cash),
          testShop.copyWith(gstin: null),
        ),
        (await sampleBill(cancel: true), testShop),
      ]) {
        final bytes = await pdf.build(
          bill,
          shop,
          const AppSettingsData(upiId: 'a@okaxis'),
        );
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
        expect(bytes.length, greaterThan(1000));
      }
    });

    test('file name is safe', () async {
      expect(
        InvoicePdf.fileName(await sampleBill()),
        'Invoice_INV-26-27-0001.pdf',
      );
    });
  });

  group('PrinterService', () {
    late FakePrinterTransport transport;
    late FakeSettings settings;
    late PrinterService service;

    setUp(() {
      transport = FakePrinterTransport();
      settings = FakeSettings(
        const AppSettingsData(printerAddress: 'AA:BB', printerName: 'RPP02N'),
      );
      service = PrinterService(transport, settings);
    });

    test('connects and writes to the saved printer', () async {
      await service.printBytes(EscPosBuilder().init().build());
      expect(transport.log, ['connect AA:BB', 'write 2']);
    });

    test('reconnects once after a dropped connection', () async {
      transport.failWrites = 1;
      await service.printBytes(EscPosBuilder().init().build());
      expect(transport.log, [
        'connect AA:BB',
        'write failed',
        'disconnect',
        'connect AA:BB',
        'write 2',
      ]);
    });

    test('gives up after the retry fails', () {
      transport.failWrites = 2;
      expect(
        () => service.printBytes(EscPosBuilder().init().build()),
        throwsA(
          isA<PrintException>().having(
            (e) => e.error,
            'error',
            PrintError.failed,
          ),
        ),
      );
    });

    test('explains why it cannot print', () async {
      Future<PrintError> errorOf() async {
        try {
          await service.printBytes(EscPosBuilder().build());
        } on PrintException catch (e) {
          return e.error;
        }
        fail('expected PrintException');
      }

      transport.bluetooth = BluetoothState.off;
      expect(await errorOf(), PrintError.bluetoothOff);
      transport.permission = false;
      expect(await errorOf(), PrintError.permissionDenied);
      await settings.save(const AppSettingsData());
      expect(await errorOf(), PrintError.notConfigured);
    });
  });
}

bool _containsSequence(List<int> haystack, List<int> needle) {
  for (var i = 0; i + needle.length <= haystack.length; i++) {
    var match = true;
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) {
        match = false;
        break;
      }
    }
    if (match) return true;
  }
  return false;
}
