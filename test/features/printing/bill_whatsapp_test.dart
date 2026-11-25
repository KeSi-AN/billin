import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/printing/data/bill_image_renderer.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/presentation/app_bill_actions.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

import '../../helpers/fakes.dart';

Bill bill({String? name, String? phone}) => Bill(
  id: 7,
  invoiceNo: 'INV-A/26-27/0007',
  billedAt: DateTime(2026, 11, 25, 11, 47),
  lines: const [
    BillLine(
      name: 'Shifon Saree',
      unit: 'pcs',
      quantity: Quantity.whole(2),
      unitPrice: Money.rupees(565),
      taxRate: TaxRate.zero,
      priceIncludesTax: true,
      discount: Money.zero,
      billDiscountShare: Money.zero,
      taxable: Money.rupees(1130),
      tax: Money.zero,
      total: Money.rupees(1130),
    ),
  ],
  itemsTotal: const Money.rupees(1130),
  billDiscount: Money.zero,
  taxable: const Money.rupees(1130),
  tax: Money.zero,
  roundOff: Money.zero,
  grandTotal: const Money.rupees(1130),
  paymentMode: PaymentMode.cash,
  customerName: name,
  customerPhone: phone,
);

class FakeWhatsApp implements WhatsAppSender {
  final calls = <String>[];

  @override
  Future<void> openChat(String phone, String text) async =>
      calls.add('chat $phone: $text');

  @override
  Future<void> sendFile(String path, String? phone, String text) async =>
      calls.add('file $path to ${phone ?? 'picker'}: $text');
}

class MemoryChats implements ChatMemory {
  final known = <String>{};

  @override
  Future<bool> knows(String phone) async => known.contains(phone);

  @override
  Future<void> remember(String phone) async => known.add(phone);
}

void main() {
  testWidgets('the bill picture is 1080 px wide, white, with ink', (
    tester,
  ) async {
    final png = (await tester.runAsync(
      () => const BillImageRenderer().render(
        bill(name: 'Adham', phone: '9885819674'),
        testShop,
        const AppSettingsData(),
      ),
    ))!;
    final image = img.decodePng(png)!;
    expect(image.width, 1080);
    expect(image.height, greaterThan(600));
    expect(image.getPixel(5, 5).r, 255); // white margin
    var dark = 0;
    for (final p in image) {
      if (p.r < 100) dark++;
    }
    expect(dark, greaterThan(2000));
    expect(BillImageRenderer.fileName(bill()), 'Bill_INV-A-26-27-0007.png');
  });

  group('WhatsApp', () {
    late FakeWhatsApp whatsApp;
    late MemoryChats chats;
    late bool cameBack;
    late AppBillActions actions;

    setUp(() {
      whatsApp = FakeWhatsApp();
      chats = MemoryChats();
      cameBack = true;
      final settings = FakeSettings();
      actions = AppBillActions(
        printer: PrinterService(FakePrinterTransport(), settings),
        settings: settings,
        shopProfiles: FakeShopProfiles(testShop),
        tempDir: () async => Directory.systemTemp,
        storageDir: () async => Directory.systemTemp,
        whatsApp: whatsApp,
        waitForReturn: () async => cameBack,
        chats: chats,
        billImage: (b) async => '/tmp/${BillImageRenderer.fileName(b)}',
      );
    });

    Future<void> send(WidgetTester tester, Bill b) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (c) {
                ctx = c;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      await actions.whatsapp(ctx, b);
      await tester.pump(const Duration(seconds: 10));
    }

    const picture = '/tmp/Bill_INV-A-26-27-0007.png';

    testWidgets('a new number: chat first, then the picture', (tester) async {
      const message =
          'Hi Adham, thank you for shopping at Sharma Kirana! '
          'Bill INV-A/26-27/0007 · Total ₹1,130.00';
      await send(tester, bill(name: 'Adham', phone: '9885819674'));
      expect(whatsApp.calls, [
        'chat 9885819674: $message',
        'file $picture to 9885819674: INV-A/26-27/0007',
      ]);
      expect(chats.known, {'9885819674'});

      // Next time WhatsApp knows the chat: the picture goes straight in.
      whatsApp.calls.clear();
      await send(tester, bill(name: 'Adham', phone: '9885819674'));
      expect(whatsApp.calls, ['file $picture to 9885819674: $message']);
    });

    testWidgets('not back from WhatsApp: the picture waits', (tester) async {
      cameBack = false;
      await send(tester, bill(phone: '9885819674'));
      expect(whatsApp.calls, hasLength(1));
      expect(whatsApp.calls.single, startsWith('chat 9885819674: Thank you'));
    });

    testWidgets('no mobile: WhatsApp asks whom to send it to', (tester) async {
      await send(tester, bill());
      expect(whatsApp.calls.single, startsWith('file $picture to picker'));
    });
  });
}
