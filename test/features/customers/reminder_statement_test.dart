import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/domain/reminder.dart';
import 'package:shop_app/features/printing/domain/invoice_pdf.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/printing/domain/statement_pdf.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

import '../../helpers/fakes.dart';

void main() {
  setUpAll(initDateFormatting);
  const ravi = Party(
    id: 1,
    name: 'Ravi',
    phone: '9876543210',
    balance: Money.paise(25050),
  );

  test('reminder text includes the due and a UPI link when set up', () {
    final withUpi = reminderMessage(
      party: ravi,
      shopName: 'Sharma Kirana',
      upiId: 'sharma@okaxis',
    );
    expect(withUpi, contains('Namaste Ravi,'));
    expect(withUpi, contains('₹250.50'));
    expect(withUpi, contains('upi://pay?pa=sharma%40okaxis'));
    expect(withUpi, contains('am=250.50'));
    final without = reminderMessage(party: ravi, shopName: 'Sharma Kirana');
    expect(without, isNot(contains('upi://')));
  });

  test('WhatsApp link opens a chat with the number and text', () {
    final uri = whatsAppUri('9876543210', 'Hi there & more');
    expect(uri.toString(), 'https://wa.me/919876543210?text=Hi+there+%26+more');
  });

  test('statement PDF builds with entries', () async {
    final entries = [
      PartyEntry(
        id: 1,
        partyId: 1,
        type: EntryType.opening,
        amount: const Money.rupees(100),
        balanceAfter: const Money.rupees(100),
        at: DateTime(2026, 11),
      ),
      PartyEntry(
        id: 2,
        partyId: 1,
        type: EntryType.sale,
        amount: const Money.paise(20050),
        balanceAfter: const Money.paise(30050),
        at: DateTime(2026, 11, 5),
        billId: 3,
        invoiceNo: 'INV/26-27/0003',
      ),
      PartyEntry(
        id: 3,
        partyId: 1,
        type: EntryType.payment,
        amount: const Money.rupees(-50),
        balanceAfter: const Money.paise(25050),
        at: DateTime(2026, 11, 6),
        paymentMode: PaymentMode.upi,
      ),
    ];
    final bytes = await const StatementPdf(InvoiceFonts()).build(
      party: ravi,
      shop: testShop,
      entries: entries,
      generatedAt: DateTime(2026, 11, 12),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('credit bill receipt shows paid and balance due', () async {
    final h = TestHarness(shop: testShop);
    final p = await h.parties.save(const Party(name: 'Ravi'));
    final bill = await h.bills.create(
      BillDraft(
        lines: const [DraftLine(name: 'Rice', unitPrice: Money.rupees(100))],
        paymentMode: PaymentMode.credit,
        partyId: p.id,
        customerName: 'Ravi',
        paidNow: const Money.rupees(30),
      ),
    );
    final text = const ReceiptFormatter(width: 32)
        .lines(bill, testShop, const AppSettingsData())
        .map((l) => l.text)
        .join('\n');
    expect(text, contains('Paid'));
    expect(text, contains('Balance due'));
    expect(text, contains('70.00'));
  });
}
