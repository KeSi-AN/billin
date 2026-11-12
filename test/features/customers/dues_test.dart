import 'dart:math';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/customers/data/drift_party_repository.dart';
import 'package:shop_app/features/customers/domain/party.dart';

void main() {
  late AppDatabase db;
  late DriftPartyRepository parties;
  late DriftBillRepository bills;
  var now = DateTime(2026, 11, 12, 10);
  DateTime clock() => now = now.add(const Duration(minutes: 1));

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  setUp(() {
    now = DateTime(2026, 11, 12, 10);
    db = AppDatabase(NativeDatabase.memory());
    parties = DriftPartyRepository(db, clock: clock);
    bills = DriftBillRepository(db, clock: clock);
  });
  tearDown(() => db.close());

  Future<Bill> creditSale(Party p, int rupees, {int paidNow = 0}) =>
      bills.create(
        BillDraft(
          lines: [DraftLine(name: 'Rice', unitPrice: Money.rupees(rupees))],
          paymentMode: PaymentMode.credit,
          partyId: p.id,
          customerName: p.name,
          paidNow: Money.rupees(paidNow),
        ),
      );

  Future<Money> balanceOf(Party p) async =>
      (await parties.byId(p.id!))!.balance;

  test('customer with an opening due', () async {
    final ravi = await parties.save(
      const Party(name: ' Ravi ', phone: '+91 98765 43210'),
      openingDue: const Money.rupees(500),
    );
    expect(ravi.name, 'Ravi');
    expect(ravi.phone, '9876543210');
    expect(ravi.balance, const Money.rupees(500));
    final entries = await parties.watchEntries(ravi.id!).first;
    expect(entries.single.type, EntryType.opening);
  });

  test('phone numbers are unique among customers', () async {
    await parties.save(const Party(name: 'Ravi', phone: '9876543210'));
    expect(
      () => parties.save(const Party(name: 'Other', phone: '098765 43210')),
      throwsA(isA<DuplicatePhoneException>()),
    );
  });

  test('credit sale goes on account; paid-now comes straight off', () async {
    final ravi = await parties.save(const Party(name: 'Ravi'));
    final bill = await creditSale(ravi, 300, paidNow: 100);
    expect(bill.due, const Money.rupees(200));
    expect(bill.paid, const Money.rupees(100));
    expect(bill.partyId, ravi.id);
    expect(await balanceOf(ravi), const Money.rupees(200));

    final entries = await parties.watchEntries(ravi.id!).first;
    expect(entries.map((e) => (e.type, e.amount.paise)), [
      (EntryType.payment, -10000),
      (EntryType.sale, 30000),
    ]);
    expect(entries.last.invoiceNo, bill.invoiceNo);
  });

  test('credit needs a customer; paid bills never touch dues', () async {
    expect(
      () => bills.create(
        const BillDraft(
          lines: [DraftLine(name: 'x', unitPrice: Money.rupees(1))],
          paymentMode: PaymentMode.credit,
        ),
      ),
      throwsArgumentError,
    );
    final ravi = await parties.save(const Party(name: 'Ravi'));
    final cash = await bills.create(
      BillDraft(
        lines: const [DraftLine(name: 'x', unitPrice: Money.rupees(50))],
        partyId: ravi.id,
      ),
    );
    expect(cash.partyId, ravi.id);
    expect(cash.due, Money.zero);
    expect(await balanceOf(ravi), Money.zero);
  });

  test('payments settle dues; over-payment becomes an advance', () async {
    final ravi = await parties.save(const Party(name: 'Ravi'));
    await creditSale(ravi, 300);
    await parties.receivePayment(
      ravi.id!,
      const Money.rupees(120),
      mode: PaymentMode.upi,
    );
    expect(await balanceOf(ravi), const Money.rupees(180));
    await parties.receivePayment(ravi.id!, const Money.rupees(200));
    expect(await balanceOf(ravi), const Money.rupees(-20));
    expect(
      () => parties.receivePayment(ravi.id!, Money.zero),
      throwsArgumentError,
    );
  });

  test('cancelling a credit bill reverses only what it added', () async {
    final ravi = await parties.save(
      const Party(name: 'Ravi'),
      openingDue: const Money.rupees(50),
    );
    final bill = await creditSale(ravi, 300, paidNow: 100);
    expect(await balanceOf(ravi), const Money.rupees(250));
    await bills.cancel(bill.id);
    await bills.cancel(bill.id); // no-op
    expect(await balanceOf(ravi), const Money.rupees(50));
  });

  test('cannot delete a customer who still owes or has an advance', () async {
    final ravi = await parties.save(const Party(name: 'Ravi'));
    await creditSale(ravi, 10);
    expect(
      () => parties.delete(ravi.id!),
      throwsA(isA<PartyHasBalanceException>()),
    );
    await parties.receivePayment(ravi.id!, const Money.rupees(10));
    await parties.delete(ravi.id!);
    expect(await parties.watchAll().first, isEmpty);
  });

  test('list filters and the total due', () async {
    final a = await parties.save(
      const Party(name: 'Asha'),
      openingDue: const Money.rupees(100),
    );
    await parties.save(const Party(name: 'Bina', phone: '9123456780'));
    final c = await parties.save(
      const Party(name: 'Chetan'),
      openingDue: const Money.rupees(300),
    );
    await parties.receivePayment(
      c.id!,
      const Money.rupees(400),
    ); // advance −100

    expect(await parties.watchTotalDue().first, const Money.rupees(100));
    final withDues = await parties
        .watchAll(filter: const PartyFilter(onlyWithDues: true))
        .first;
    expect(withDues.map((p) => p.name), ['Asha']);
    final byPhone = await parties
        .watchAll(filter: const PartyFilter(query: '91234'))
        .first;
    expect(byPhone.single.name, 'Bina');
    final byDue = await parties
        .watchAll(filter: const PartyFilter(sort: PartySort.dueHighFirst))
        .first;
    expect(byDue.first.id, a.id);
  });

  test('statement entries between dates, oldest first', () async {
    final ravi = await parties.save(
      const Party(name: 'Ravi'),
      openingDue: const Money.rupees(10),
    );
    final start = now;
    await creditSale(ravi, 20);
    await parties.receivePayment(ravi.id!, const Money.rupees(5));
    final entries = await parties.entriesBetween(
      ravi.id!,
      start,
      now.add(const Duration(days: 1)),
    );
    expect(entries.map((e) => e.type), [EntryType.sale, EntryType.payment]);
    expect(entries.last.balanceAfter, const Money.rupees(25));
  });

  test(
    'balances always equal the sum of ledger entries (300 random steps)',
    () async {
      final random = Random(7);
      final customers = [
        for (final n in ['A', 'B', 'C', 'D'])
          await parties.save(
            Party(name: n),
            openingDue: Money.paise(random.nextInt(50000)),
          ),
      ];
      final creditBills = <Bill>[];
      for (var step = 0; step < 300; step++) {
        final p = customers[random.nextInt(customers.length)];
        switch (random.nextInt(4)) {
          case 0 || 1:
            final total = 1 + random.nextInt(2000);
            creditBills.add(
              await creditSale(
                p,
                total,
                paidNow: random.nextBool() ? random.nextInt(total + 50) : 0,
              ),
            );
          case 2:
            await parties.receivePayment(
              p.id!,
              Money.paise(1 + random.nextInt(100000)),
            );
          case 3 when creditBills.isNotEmpty:
            await bills.cancel(
              creditBills[random.nextInt(creditBills.length)].id,
            );
        }
      }

      var totalDue = Money.zero;
      for (final p in customers) {
        final entries = await parties.watchEntries(p.id!).first;
        final sum = entries.fold(Money.zero, (s, e) => s + e.amount);
        final balance = await balanceOf(p);
        expect(balance, sum, reason: p.name);
        // Running balances chain correctly (entries are newest first).
        expect(entries.first.balanceAfter, balance, reason: p.name);
        for (var i = 0; i + 1 < entries.length; i++) {
          expect(
            entries[i].balanceAfter,
            entries[i + 1].balanceAfter + entries[i].amount,
            reason: '${p.name} entry ${entries[i].id}',
          );
        }
        if (balance.isPositive) totalDue = totalDue + balance;
      }
      expect(await parties.watchTotalDue().first, totalDue);

      // Every bill's stored due matches what it put on the account, and
      // cancelled bills leave nothing behind.
      for (final b in creditBills) {
        final bill = (await bills.byId(b.id))!;
        final rows = await (db.select(
          db.partyEntries,
        )..where((e) => e.billId.equals(b.id))).get();
        final net = rows.fold(0, (s, e) => s + e.amountPaise);
        expect(
          net,
          bill.isCancelled ? 0 : bill.due.paise,
          reason: bill.invoiceNo,
        );
      }
    },
  );
}
