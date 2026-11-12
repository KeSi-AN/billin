import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';

class DriftBillRepository implements BillRepository {
  DriftBillRepository(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final DateTime Function() _clock;

  @override
  Future<Bill> create(BillDraft draft) async {
    if (draft.lines.isEmpty) {
      throw ArgumentError.value(
        draft,
        'draft',
        'A bill needs at least one line',
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
            ),
          );

      await _db.batch((batch) {
        batch.insertAll(_db.billLines, [
          for (var i = 0; i < draft.lines.length; i++)
            _lineCompanion(billId, i, draft.lines[i], totals.lines[i]),
        ]);
      });
      return billId;
    });
    return (await byId(id))!;
  }

  BillLinesCompanion _lineCompanion(
    int billId,
    int position,
    DraftLine line,
    LineAmounts amounts,
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
  Future<void> cancel(int id, {String? reason}) async {
    await (_db.update(
      _db.bills,
    )..where((t) => t.id.equals(id) & t.status.equals('completed'))).write(
      BillsCompanion(
        status: Value(BillStatus.cancelled.name),
        cancelledAt: Value(_clock()),
        cancelReason: Value(_blankToNull(reason)),
      ),
    );
  }

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
  );

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
