import 'dart:math';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/data/drift_returns_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/data/drift_party_repository.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/data/drift_expense_repository.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/inventory/data/drift_inventory_repository.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/purchases/data/drift_purchase_repository.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// A Karnataka GSTIN with a correct check character.
final karnatakaGstin =
    '29ABCDE1234F1Z${Gstin.checkCharacter('29ABCDE1234F1Z')}';

void main() {
  late AppDatabase db;
  late DriftItemRepository items;
  late DriftPartyRepository parties;
  late DriftBillRepository bills;
  late DriftPurchaseRepository purchases;
  late DriftReturnsRepository returns;
  late DriftInventoryRepository inventory;
  var now = DateTime(2026, 11, 13, 10);
  DateTime clock() => now = now.add(const Duration(minutes: 1));

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  setUp(() async {
    now = DateTime(2026, 11, 13, 10);
    db = AppDatabase(NativeDatabase.memory());
    items = DriftItemRepository(db, clock: clock);
    parties = DriftPartyRepository(db, clock: clock);
    bills = DriftBillRepository(db, clock: clock);
    purchases = DriftPurchaseRepository(db, clock: clock);
    returns = DriftReturnsRepository(db, clock: clock);
    inventory = DriftInventoryRepository(db, clock: clock);
    // Shop in Maharashtra (27).
    await DriftShopProfileRepository(
      db,
      storageDir: () => throw UnimplementedError(),
    ).save(const ShopProfile(name: 'Sharma Kirana', stateCode: '27'));
  });
  tearDown(() => db.close());

  Future<Item> tracked(
    String name, {
    int priceRupees = 100,
    int taxBp = 1800,
  }) => items.save(
    Item(
      name: name,
      salePrice: Money.rupees(priceRupees),
      taxRate: TaxRate(taxBp),
      trackStock: true,
      hsn: '1905',
    ),
  );

  Future<Quantity> stockOf(Item i) async => (await items.byId(i.id!))!.stock;

  group('place of supply', () {
    Future<Bill> sellTo(Party p) => bills.create(
      BillDraft(
        lines: const [
          DraftLine(
            name: 'x',
            unitPrice: Money.rupees(118),
            taxRate: TaxRate(1800),
          ),
        ],
        partyId: p.id,
        customerName: p.name,
      ),
    );

    test('a GSTIN customer in another state: B2B and IGST', () async {
      final b2b = await parties.save(
        Party(name: 'Karnataka Traders', gstin: karnatakaGstin),
      );
      expect(b2b.stateCode, '29'); // taken from the GSTIN
      final bill = await sellTo(b2b);
      expect(bill.interState, isTrue);
      expect(bill.placeOfSupply, '29');
      expect(bill.buyerGstin, karnatakaGstin);
      expect(bill.isB2B, isTrue);
    });

    test('same state, or no state known: CGST + SGST', () async {
      final local = await parties.save(
        const Party(name: 'Local', stateCode: '27'),
      );
      final unknown = await parties.save(const Party(name: 'Walk-in'));
      for (final p in [local, unknown]) {
        final bill = await sellTo(p);
        expect(bill.interState, isFalse, reason: p.name);
        expect(bill.placeOfSupply, isNull);
        expect(bill.isB2B, isFalse);
      }
    });

    test('a chosen state without GSTIN still decides IGST (B2C)', () async {
      final away = await parties.save(
        const Party(name: 'Tourist', stateCode: '07'),
      );
      final bill = await sellTo(away);
      expect(bill.interState, isTrue);
      expect(bill.isB2B, isFalse);
    });
  });

  group('purchases', () {
    test('stock in, cost price before GST, and the supplier is owed', () async {
      final maggi = await tracked('Maggi', priceRupees: 14, taxBp: 1200);
      final supplier = await parties.save(
        const Party(
          name: 'Metro Wholesale',
          type: PartyType.supplier,
          stateCode: '27',
        ),
      );
      final p = await purchases.create(
        PurchaseDraft(
          partyId: supplier.id,
          supplierInvoiceNo: 'MW-881',
          paymentMode: PaymentMode.credit,
          paidNow: const Money.rupees(200),
          lines: [
            PurchaseDraftLine(
              itemId: maggi.id,
              name: 'Maggi',
              quantity: const Quantity.whole(48),
              unitCost: const Money.rupees(10), // + 12% GST
              taxRate: const TaxRate(1200),
            ),
          ],
        ),
      );
      expect(p.taxable, const Money.rupees(480));
      expect(p.tax, const Money.paise(5760));
      expect(p.total, const Money.paise(53760));
      expect(p.due, const Money.paise(33760));
      expect(p.interState, isFalse);
      expect(await stockOf(maggi), const Quantity.whole(48));
      expect((await items.byId(maggi.id!))!.costPrice, const Money.rupees(10));
      expect(
        (await parties.byId(supplier.id!))!.balance,
        const Money.paise(33760),
      );
      final history = await inventory.watchMovements(maggi.id!).first;
      expect(history.single.type, MovementType.purchase);
    });

    test('credit needs a supplier', () {
      expect(
        () => purchases.create(
          const PurchaseDraft(
            paymentMode: PaymentMode.credit,
            lines: [
              PurchaseDraftLine(
                name: 'x',
                quantity: Quantity.one,
                unitCost: Money.rupees(1),
              ),
            ],
          ),
        ),
        throwsA(isA<SupplierRequiredException>()),
      );
    });

    test('batch items land in the given (or an automatic) batch', () async {
      final crocin = await items.save(
        const Item(
          name: 'Crocin',
          salePrice: Money.rupees(30),
          trackStock: true,
          tracksBatches: true,
        ),
      );
      await purchases.create(
        PurchaseDraft(
          lines: [
            PurchaseDraftLine(
              itemId: crocin.id,
              name: 'Crocin',
              quantity: const Quantity.whole(10),
              unitCost: const Money.rupees(20),
              batchNo: 'B77',
              expiry: DateTime(2027, 5),
            ),
          ],
        ),
      );
      final batch = (await inventory.watchBatches(crocin.id!).first).single;
      expect(batch.batchNo, 'B77');
      expect(batch.expiry, DateTime(2027, 5));
      expect(batch.quantity, const Quantity.whole(10));
    });

    test('cancelling takes stock out and reverses the due', () async {
      final maggi = await tracked('Maggi');
      final supplier = await parties.save(
        const Party(name: 'S', type: PartyType.supplier),
      );
      final p = await purchases.create(
        PurchaseDraft(
          partyId: supplier.id,
          paymentMode: PaymentMode.credit,
          lines: [
            PurchaseDraftLine(
              itemId: maggi.id,
              name: 'Maggi',
              quantity: const Quantity.whole(5),
              unitCost: const Money.rupees(10),
            ),
          ],
        ),
      );
      await purchases.cancel(p.id);
      await purchases.cancel(p.id); // no-op
      expect(await stockOf(maggi), Quantity.zero);
      expect((await parties.byId(supplier.id!))!.balance, Money.zero);
      expect((await purchases.byId(p.id))!.isCancelled, isTrue);
    });
  });

  test('profit = taxable value minus cost, per line and per bill', () async {
    final maggi = await tracked('Maggi', priceRupees: 118); // incl. 18%
    await purchases.create(
      PurchaseDraft(
        lines: [
          PurchaseDraftLine(
            itemId: maggi.id,
            name: 'Maggi',
            quantity: const Quantity.whole(10),
            unitCost: const Money.rupees(80),
          ),
        ],
      ),
    );
    final bill = await bills.create(
      BillDraft(
        lines: [
          DraftLine(
            itemId: maggi.id,
            name: 'Maggi',
            unitPrice: const Money.rupees(118),
            taxRate: const TaxRate(1800),
            quantity: const Quantity.whole(2),
          ),
          const DraftLine(name: 'Quick', unitPrice: Money.rupees(5)),
        ],
      ),
    );
    // 2 × ₹100 taxable − 2 × ₹80 cost = ₹40
    expect(bill.lines.first.cost, const Money.rupees(160));
    expect(bill.lines.first.profit, const Money.rupees(40));
    expect(bill.profit, const Money.rupees(40));
    expect(bill.profitIsPartial, isTrue); // the quick item has no cost
  });

  group('returns (credit notes)', () {
    test('part return: stock back, refund, numbered credit note', () async {
      final maggi = await tracked('Maggi', priceRupees: 118);
      await inventory.addStock(maggi.id!, const Quantity.whole(10));
      final bill = await bills.create(
        BillDraft(
          lines: [
            DraftLine(
              itemId: maggi.id,
              name: 'Maggi',
              unitPrice: const Money.rupees(118),
              taxRate: const TaxRate(1800),
              quantity: const Quantity.whole(3),
            ),
          ],
        ),
      );
      final line = bill.lines.single;
      final cn = await returns.returnItems(bill.id, [
        (billLineId: line.id!, quantity: Quantity.one),
      ], reason: 'Damaged');
      expect(cn.noteNo, 'CN/26-27/0001');
      expect(cn.invoiceNo, bill.invoiceNo);
      expect(cn.total, const Money.rupees(118));
      expect(cn.taxable, const Money.rupees(100));
      expect(cn.refundMode, PaymentMode.cash);
      expect(cn.lines.single.quantity, Quantity.one);
      expect(await stockOf(maggi), const Quantity.whole(8)); // 10 − 3 + 1
      expect((await bills.byId(bill.id))!.lines.single.returned, Quantity.one);

      final second = await returns.returnItems(bill.id, [
        (billLineId: line.id!, quantity: Quantity.one),
      ]);
      expect(second.noteNo, 'CN/26-27/0002');
      expect(await returns.forBill(bill.id), hasLength(2));
    });

    test('cannot return more than is left, or on a cancelled bill', () async {
      final bill = await bills.create(
        const BillDraft(
          lines: [
            DraftLine(
              name: 'x',
              unitPrice: Money.rupees(10),
              quantity: Quantity.whole(2),
            ),
          ],
        ),
      );
      final id = bill.lines.single.id!;
      await returns.returnItems(bill.id, [
        (billLineId: id, quantity: Quantity.one),
      ]);
      expect(
        () => returns.returnItems(bill.id, [
          (billLineId: id, quantity: const Quantity.whole(2)),
        ]),
        throwsA(isA<ReturnTooLargeException>()),
      );
      final other = await bills.create(
        const BillDraft(
          lines: [DraftLine(name: 'y', unitPrice: Money.rupees(10))],
        ),
      );
      await bills.cancel(other.id);
      expect(
        () => returns.returnItems(other.id, [
          (billLineId: other.lines.single.id!, quantity: Quantity.one),
        ]),
        throwsStateError,
      );
    });

    test('credit bill: the return comes off the customer dues', () async {
      final ravi = await parties.save(const Party(name: 'Ravi'));
      final bill = await bills.create(
        BillDraft(
          lines: const [
            DraftLine(
              name: 'Rice',
              unitPrice: Money.rupees(50),
              quantity: Quantity.whole(4),
            ),
          ],
          paymentMode: PaymentMode.credit,
          partyId: ravi.id,
        ),
      );
      final cn = await returns.returnItems(bill.id, [
        (billLineId: bill.lines.single.id!, quantity: Quantity.one),
      ]);
      expect(cn.refundMode, PaymentMode.credit);
      expect((await parties.byId(ravi.id!))!.balance, const Money.rupees(150));
      final entries = await parties.watchEntries(ravi.id!).first;
      expect(entries.first.type, EntryType.salesReturn);
    });

    test('random part-returns always add up to the line exactly', () async {
      final random = Random(11);
      for (var run = 0; run < 40; run++) {
        final qty = 2 + random.nextInt(9);
        final bill = await bills.create(
          BillDraft(
            billDiscount: Money.paise(random.nextInt(300)),
            lines: [
              DraftLine(
                name: 'odd',
                unitPrice: Money.paise(1 + random.nextInt(99999)),
                quantity: Quantity.whole(qty),
                taxRate:
                    TaxRate.choices[random.nextInt(TaxRate.choices.length)],
                priceIncludesTax: random.nextBool(),
              ),
            ],
          ),
        );
        final line = bill.lines.single;
        var left = qty;
        while (left > 0) {
          final take = 1 + random.nextInt(left);
          await returns.returnItems(bill.id, [
            (billLineId: line.id!, quantity: Quantity.whole(take)),
          ]);
          left -= take;
        }
        final notes = await returns.forBill(bill.id);
        final taxable = notes.fold(Money.zero, (s, n) => s + n.taxable);
        final tax = notes.fold(Money.zero, (s, n) => s + n.tax);
        expect(taxable, line.taxable, reason: 'run $run');
        expect(tax, line.tax, reason: 'run $run');
      }
    });
  });

  test('expenses: add, list by date, delete', () async {
    final repo = DriftExpenseRepository(db);
    await repo.add(
      Expense(
        spentAt: DateTime(2026, 11),
        category: 'Rent',
        amount: const Money.rupees(8000),
      ),
    );
    final tea = await repo.add(
      Expense(
        spentAt: DateTime(2026, 11, 13),
        category: 'Tea & snacks',
        amount: const Money.rupees(40),
        paymentMode: PaymentMode.upi,
      ),
    );
    await repo.add(
      Expense(
        spentAt: DateTime(2026, 10, 30),
        category: 'Rent',
        amount: const Money.rupees(8000),
      ),
    );
    var nov = await repo
        .watchBetween(DateTime(2026, 11), DateTime(2026, 12))
        .first;
    expect(nov.map((e) => e.category), ['Tea & snacks', 'Rent']);
    await repo.delete(tea.id!);
    nov = await repo.watchBetween(DateTime(2026, 11), DateTime(2026, 12)).first;
    expect(nov.single.amount, const Money.rupees(8000));
    expect(
      () => repo.add(
        Expense(spentAt: DateTime(2026, 11), category: 'x', amount: Money.zero),
      ),
      throwsArgumentError,
    );
  });
}
