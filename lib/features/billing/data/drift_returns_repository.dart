import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/data/party_ledger.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/inventory/data/stock_ledger.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';

class DriftReturnsRepository implements ReturnsRepository {
  DriftReturnsRepository(this._db, {this._clock = DateTime.now})
    : _stock = StockLedger(_db, _clock),
      _dues = PartyLedger(_db, _clock);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final StockLedger _stock;
  final PartyLedger _dues;

  static const prefix = 'CN';

  @override
  Future<CreditNote> returnItems(
    int billId,
    List<ReturnLine> lines, {
    PaymentMode refundMode = PaymentMode.cash,
    String? reason,
  }) async {
    final wanted = lines.where((l) => l.quantity.isPositive).toList();
    if (wanted.isEmpty) {
      throw ArgumentError.value(lines, 'lines', 'Nothing to return');
    }
    final id = await _db.transaction(() async {
      final bill = await (_db.select(
        _db.bills,
      )..where((b) => b.id.equals(billId))).getSingle();
      if (bill.status != 'completed') {
        throw StateError('Cannot return goods on a cancelled bill');
      }

      // Amounts per returned line. Returning everything that's left uses
      // exactly what's left, so repeated part-returns never lose a paisa.
      final computed = <(BillLineRow, int, int, int)>[];
      for (final r in wanted) {
        final line =
            await (_db.select(_db.billLines)..where(
                  (l) => l.id.equals(r.billLineId) & l.billId.equals(billId),
                ))
                .getSingle();
        final left = line.quantityMilli - line.returnedMilli;
        if (r.quantity.milli > left) throw ReturnTooLargeException(line.name);
        final int taxable;
        final int tax;
        if (r.quantity.milli == left) {
          final done = await _returnedAmounts(line.id);
          taxable = line.taxablePaise - done.$1;
          tax = line.taxPaise - done.$2;
        } else {
          taxable = divRound(
            line.taxablePaise * r.quantity.milli,
            line.quantityMilli,
          );
          tax = divRound(line.taxPaise * r.quantity.milli, line.quantityMilli);
        }
        computed.add((line, r.quantity.milli, taxable, tax));
      }

      final now = _clock();
      final fy = FinancialYear.of(now);
      final counter = await (_db.select(
        _db.creditNoteCounters,
      )..where((c) => c.fyStart.equals(fy.startYear))).getSingleOrNull();
      final sequence = (counter?.lastSequence ?? 0) + 1;
      await _db
          .into(_db.creditNoteCounters)
          .insertOnConflictUpdate(
            CreditNoteCountersCompanion.insert(
              fyStart: Value(fy.startYear),
              lastSequence: sequence,
            ),
          );

      final taxable = computed.fold(0, (s, c) => s + c.$3);
      final tax = computed.fold(0, (s, c) => s + c.$4);
      // Credit bills with a customer: the return comes off their dues.
      final toDues =
          bill.paymentMode == PaymentMode.credit.name && bill.partyId != null;
      final noteId = await _db
          .into(_db.creditNotes)
          .insert(
            CreditNotesCompanion.insert(
              noteNo: InvoiceNumber.format(
                prefix: prefix,
                year: fy,
                sequence: sequence,
              ),
              fyStart: fy.startYear,
              sequence: sequence,
              billId: billId,
              issuedAt: now,
              reason: Value(_blankToNull(reason)),
              taxablePaise: taxable,
              taxPaise: tax,
              totalPaise: taxable + tax,
              refundMode: toDues ? PaymentMode.credit.name : refundMode.name,
            ),
          );

      for (final (line, qty, lineTaxable, lineTax) in computed) {
        await _db
            .into(_db.creditNoteLines)
            .insert(
              CreditNoteLinesCompanion.insert(
                creditNoteId: noteId,
                billLineId: line.id,
                quantityMilli: qty,
                taxablePaise: lineTaxable,
                taxPaise: lineTax,
                totalPaise: lineTaxable + lineTax,
              ),
            );
        await (_db.update(
          _db.billLines,
        )..where((l) => l.id.equals(line.id))).write(
          BillLinesCompanion(returnedMilli: Value(line.returnedMilli + qty)),
        );
        if (line.itemId != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId!))).getSingleOrNull();
          if (item != null && item.trackStock) {
            await _stock.post(
              itemId: item.id,
              quantityMilli: divRound(qty * line.unitFactorMilli, 1000),
              type: MovementType.salesReturn,
              billId: billId,
            );
          }
        }
      }

      if (toDues) {
        await _dues.post(
          partyId: bill.partyId!,
          amountPaise: -(taxable + tax),
          type: EntryType.salesReturn,
          billId: billId,
        );
      }
      return noteId;
    });
    return (await _byId(id))!;
  }

  Future<(int, int)> _returnedAmounts(int billLineId) async {
    final rows = await (_db.select(
      _db.creditNoteLines,
    )..where((l) => l.billLineId.equals(billLineId))).get();
    return (
      rows.fold(0, (s, r) => s + r.taxablePaise),
      rows.fold(0, (s, r) => s + r.taxPaise),
    );
  }

  Future<CreditNote?> _byId(int id) async {
    final notes = await _load(
      _db.select(_db.creditNotes)..where((n) => n.id.equals(id)),
    );
    return notes.firstOrNull;
  }

  @override
  Future<List<CreditNote>> forBill(int billId) => _load(
    _db.select(_db.creditNotes)
      ..where((n) => n.billId.equals(billId))
      ..orderBy([(n) => OrderingTerm.asc(n.issuedAt)]),
  );

  @override
  Future<List<CreditNote>> between(DateTime from, DateTime to) => _load(
    _db.select(_db.creditNotes)
      ..where(
        (n) =>
            n.issuedAt.isBiggerOrEqualValue(from) &
            n.issuedAt.isSmallerThanValue(to),
      )
      ..orderBy([
        (n) => OrderingTerm.asc(n.issuedAt),
        (n) => OrderingTerm.asc(n.id),
      ]),
  );

  Future<List<CreditNote>> _load(
    SimpleSelectStatement<$CreditNotesTable, CreditNoteRow> query,
  ) async {
    final notes = await query.get();
    final result = <CreditNote>[];
    for (final n in notes) {
      final bill = await (_db.select(
        _db.bills,
      )..where((b) => b.id.equals(n.billId))).getSingle();
      final rows = await (_db.select(_db.creditNoteLines).join([
        innerJoin(
          _db.billLines,
          _db.billLines.id.equalsExp(_db.creditNoteLines.billLineId),
        ),
      ])..where(_db.creditNoteLines.creditNoteId.equals(n.id))).get();
      result.add(
        CreditNote(
          id: n.id,
          noteNo: n.noteNo,
          billId: n.billId,
          invoiceNo: bill.invoiceNo,
          issuedAt: n.issuedAt,
          reason: n.reason,
          taxable: Money.paise(n.taxablePaise),
          tax: Money.paise(n.taxPaise),
          total: Money.paise(n.totalPaise),
          refundMode: PaymentMode.values.byName(n.refundMode),
          lines: [
            for (final r in rows)
              () {
                final cl = r.readTable(_db.creditNoteLines);
                final bl = r.readTable(_db.billLines);
                return CreditNoteLine(
                  billLineId: bl.id,
                  name: bl.name,
                  unit: bl.unit,
                  hsn: bl.hsn,
                  quantity: Quantity.milli(cl.quantityMilli),
                  taxRate: TaxRate(bl.taxRateBp),
                  taxable: Money.paise(cl.taxablePaise),
                  tax: Money.paise(cl.taxPaise),
                  total: Money.paise(cl.totalPaise),
                  cost: bl.costPaise == null
                      ? null
                      : Money.paise(
                          divRound(
                            bl.costPaise! * cl.quantityMilli,
                            bl.quantityMilli,
                          ),
                        ),
                );
              }(),
          ],
        ),
      );
    }
    return result;
  }

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
