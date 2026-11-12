import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/data/party_ledger.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/inventory/data/stock_ledger.dart';

class DriftBillRepository implements BillRepository {
  DriftBillRepository(this._db, {this._clock = DateTime.now})
    : _ledger = StockLedger(_db, _clock),
      _dues = PartyLedger(_db, _clock);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final StockLedger _ledger;
  final PartyLedger _dues;

  @override
  Future<Bill> create(BillDraft draft) async {
    if (draft.lines.isEmpty) {
      throw ArgumentError.value(
        draft,
        'draft',
        'A bill needs at least one line',
      );
    }
    if (draft.paymentMode == PaymentMode.credit && draft.partyId == null) {
      throw ArgumentError.value(
        draft,
        'draft',
        'A credit sale needs a customer',
      );
    }
    final now = _clock();
    final id = await _db.transaction(() async {
      final settings = await (_db.select(
        _db.appSettings,
      )..where((t) => t.id.equals(1))).getSingleOrNull();
      final totals = BillCalculator.calculate(
        [for (final l in draft.lines) l.input],
        billDiscount: draft.billDiscount,
        roundToRupee: settings?.roundToRupee ?? true,
      );

      // Next number in this financial year. Inside the transaction, so two
      // bills can never get the same number.
      final fy = FinancialYear.of(now);
      final counter = await (_db.select(
        _db.invoiceCounters,
      )..where((t) => t.fyStart.equals(fy.startYear))).getSingleOrNull();
      final sequence = (counter?.lastSequence ?? 0) + 1;
      await _db
          .into(_db.invoiceCounters)
          .insertOnConflictUpdate(
            InvoiceCountersCompanion.insert(
              fyStart: Value(fy.startYear),
              lastSequence: sequence,
            ),
          );

      // Place of supply: a customer in another state means IGST; a
      // customer with a GSTIN makes this a B2B invoice.
      final party = draft.partyId == null
          ? null
          : await (_db.select(
              _db.parties,
            )..where((p) => p.id.equals(draft.partyId!))).getSingleOrNull();
      final shop = await _db.select(_db.shopProfiles).getSingleOrNull();
      final partyState = party?.stateCode;
      final interState =
          partyState != null && shop != null && partyState != shop.stateCode;

      // Cost of goods per line (before GST), for profit.
      final costs = <int?>[];
      for (final line in draft.lines) {
        if (line.itemId == null) {
          costs.add(null);
          continue;
        }
        final item = await (_db.select(
          _db.items,
        )..where((t) => t.id.equals(line.itemId!))).getSingleOrNull();
        final unitCost = item?.costPricePaise;
        costs.add(
          unitCost == null
              ? null
              : divRound(unitCost * line.baseQuantity.milli, 1000),
        );
      }

      final billId = await _db
          .into(_db.bills)
          .insert(
            BillsCompanion.insert(
              invoiceNo: InvoiceNumber.format(
                prefix: settings?.invoicePrefix ?? InvoiceNumber.defaultPrefix,
                year: fy,
                sequence: sequence,
              ),
              fyStart: fy.startYear,
              sequence: sequence,
              billedAt: now,
              customerName: Value(_blankToNull(draft.customerName)),
              customerPhone: Value(_blankToNull(draft.customerPhone)),
              itemsTotalPaise: totals.itemsTotal.paise,
              billDiscountPaise: totals.billDiscount.paise,
              taxablePaise: totals.taxable.paise,
              taxPaise: totals.tax.paise,
              roundOffPaise: totals.roundOff.paise,
              grandTotalPaise: totals.grandTotal.paise,
              paymentMode: draft.paymentMode.name,
              partyId: Value(draft.partyId),
              duePaise: Value(_due(draft, totals.grandTotal).paise),
              interState: Value(interState),
              placeOfSupply: Value(interState ? partyState : null),
              buyerGstin: Value(party?.gstin),
            ),
          );

      await _db.batch((batch) {
        batch.insertAll(_db.billLines, [
          for (var i = 0; i < draft.lines.length; i++)
            _lineCompanion(
              billId,
              i,
              draft.lines[i],
              totals.lines[i],
              costs[i],
            ),
        ]);
      });

      // Take sold items out of stock, in the same transaction as the bill.
      for (final line in draft.lines) {
        if (line.itemId == null) continue;
        await _ledger.sell(
          itemId: line.itemId!,
          quantityMilli: line.baseQuantity.milli,
          billId: billId,
        );
      }
      // Credit: the bill goes on the customer's account; anything paid at
      // the counter comes straight off it.
      if (draft.paymentMode == PaymentMode.credit) {
        await _dues.post(
          partyId: draft.partyId!,
          amountPaise: totals.grandTotal.paise,
          type: EntryType.sale,
          billId: billId,
        );
        final paid = totals.grandTotal - _due(draft, totals.grandTotal);
        await _dues.post(
          partyId: draft.partyId!,
          amountPaise: -paid.paise,
          type: EntryType.payment,
          billId: billId,
          paymentMode: PaymentMode.cash.name,
          note: 'Paid at billing',
        );
      }
      return billId;
    });
    return (await byId(id))!;
  }

  BillLinesCompanion _lineCompanion(
    int billId,
    int position,
    DraftLine line,
    LineAmounts amounts,
    int? costPaise,
  ) => BillLinesCompanion.insert(
    billId: billId,
    position: position,
    itemId: Value(line.itemId),
    name: line.name.trim(),
    unit: line.unit,
    hsn: Value(line.hsn),
    quantityMilli: line.quantity.milli,
    unitPricePaise: line.unitPrice.paise,
    taxRateBp: line.taxRate.bp,
    priceIncludesTax: line.priceIncludesTax,
    discountPaise: amounts.discount.paise,
    billDiscountSharePaise: amounts.billDiscountShare.paise,
    taxablePaise: amounts.taxable.paise,
    taxPaise: amounts.tax.paise,
    totalPaise: amounts.total.paise,
    unitFactorMilli: Value(line.unitFactor.milli),
    costPaise: Value(costPaise),
  );

  @override
  Future<Bill?> byId(int id) async {
    final row = await (_db.select(
      _db.bills,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final lines =
        await (_db.select(_db.billLines)
              ..where((t) => t.billId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    return _toDomain(row, lines);
  }

  @override
  Future<List<Bill>> billsBetween(DateTime from, DateTime to) async {
    final rows =
        await (_db.select(_db.bills)
              ..where(
                (b) =>
                    b.billedAt.isBiggerOrEqualValue(from) &
                    b.billedAt.isSmallerThanValue(to),
              )
              ..orderBy([(b) => OrderingTerm.asc(b.sequence)]))
            .get();
    if (rows.isEmpty) return [];
    final lines =
        await (_db.select(_db.billLines)
              ..where((l) => l.billId.isIn(rows.map((r) => r.id)))
              ..orderBy([(l) => OrderingTerm.asc(l.position)]))
            .get();
    return [
      for (final r in rows)
        _toDomain(r, lines.where((l) => l.billId == r.id).toList()),
    ];
  }

  @override
  Stream<List<BillSummary>> watchBetween(DateTime from, DateTime to) {
    final lineCount = _db.billLines.id.count();
    final query =
        _db.select(_db.bills).join([
            leftOuterJoin(
              _db.billLines,
              _db.billLines.billId.equalsExp(_db.bills.id),
              useColumns: false,
            ),
          ])
          ..addColumns([lineCount])
          ..where(
            _db.bills.billedAt.isBiggerOrEqualValue(from) &
                _db.bills.billedAt.isSmallerThanValue(to),
          )
          ..groupBy([_db.bills.id])
          ..orderBy([OrderingTerm.desc(_db.bills.billedAt)]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          _toSummary(r.readTable(_db.bills), r.read(lineCount) ?? 0),
      ],
    );
  }

  @override
  Future<void> cancel(int id, {String? reason}) => _db.transaction(() async {
    final changed =
        await (_db.update(
          _db.bills,
        )..where((t) => t.id.equals(id) & t.status.equals('completed'))).write(
          BillsCompanion(
            status: Value(BillStatus.cancelled.name),
            cancelledAt: Value(_clock()),
            cancelReason: Value(_blankToNull(reason)),
          ),
        );
    // Only the first cancel puts stock back and reverses any dues.
    if (changed > 0) {
      await _ledger.reverseBill(id);
      await _dues.reverseBill(id);
    }
  });

  static Bill _toDomain(BillRow r, List<BillLineRow> lines) => Bill(
    id: r.id,
    invoiceNo: r.invoiceNo,
    billedAt: r.billedAt,
    customerName: r.customerName,
    customerPhone: r.customerPhone,
    itemsTotal: Money.paise(r.itemsTotalPaise),
    billDiscount: Money.paise(r.billDiscountPaise),
    taxable: Money.paise(r.taxablePaise),
    tax: Money.paise(r.taxPaise),
    roundOff: Money.paise(r.roundOffPaise),
    grandTotal: Money.paise(r.grandTotalPaise),
    paymentMode: PaymentMode.values.byName(r.paymentMode),
    status: BillStatus.values.byName(r.status),
    cancelledAt: r.cancelledAt,
    cancelReason: r.cancelReason,
    partyId: r.partyId,
    due: Money.paise(r.duePaise),
    interState: r.interState,
    placeOfSupply: r.placeOfSupply,
    buyerGstin: r.buyerGstin,
    lines: [
      for (final l in lines)
        BillLine(
          itemId: l.itemId,
          name: l.name,
          unit: l.unit,
          hsn: l.hsn,
          quantity: Quantity.milli(l.quantityMilli),
          unitPrice: Money.paise(l.unitPricePaise),
          taxRate: TaxRate(l.taxRateBp),
          priceIncludesTax: l.priceIncludesTax,
          discount: Money.paise(l.discountPaise),
          billDiscountShare: Money.paise(l.billDiscountSharePaise),
          taxable: Money.paise(l.taxablePaise),
          tax: Money.paise(l.taxPaise),
          total: Money.paise(l.totalPaise),
          unitFactor: Quantity.milli(l.unitFactorMilli),
          id: l.id,
          cost: l.costPaise == null ? null : Money.paise(l.costPaise!),
          returned: Quantity.milli(l.returnedMilli),
        ),
    ],
  );

  static BillSummary _toSummary(BillRow r, int lineCount) => BillSummary(
    id: r.id,
    invoiceNo: r.invoiceNo,
    billedAt: r.billedAt,
    grandTotal: Money.paise(r.grandTotalPaise),
    paymentMode: PaymentMode.values.byName(r.paymentMode),
    status: BillStatus.values.byName(r.status),
    lineCount: lineCount,
    customerName: r.customerName,
    due: Money.paise(r.duePaise),
  );

  /// Unpaid part of a credit bill: total minus what was paid at the counter
  /// (never below zero or above the total).
  static Money _due(BillDraft draft, Money grandTotal) {
    if (draft.paymentMode != PaymentMode.credit) return Money.zero;
    final paid = draft.paidNow.isNegative
        ? Money.zero
        : (draft.paidNow > grandTotal ? grandTotal : draft.paidNow);
    return grandTotal - paid;
  }

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
