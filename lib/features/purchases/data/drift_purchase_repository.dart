import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/data/party_ledger.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/inventory/data/stock_ledger.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';

class DriftPurchaseRepository implements PurchaseRepository {
  DriftPurchaseRepository(this._db, {this._clock = DateTime.now})
    : _stock = StockLedger(_db, _clock),
      _dues = PartyLedger(_db, _clock);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final StockLedger _stock;
  final PartyLedger _dues;

  @override
  Future<Purchase> create(PurchaseDraft draft) async {
    if (draft.lines.isEmpty) {
      throw ArgumentError.value(draft, 'draft', 'A purchase needs a line');
    }
    final credit = draft.paymentMode == PaymentMode.credit;
    if (credit && draft.partyId == null) {
      throw const SupplierRequiredException();
    }

    final id = await _db.transaction(() async {
      final totals = BillCalculator.calculate([
        for (final l in draft.lines)
          BillLineInput(
            unitPrice: l.unitCost,
            quantity: l.quantity,
            taxRate: l.taxRate,
            priceIncludesTax: l.costIncludesTax,
          ),
      ], roundToRupee: false);

      final supplier = draft.partyId == null
          ? null
          : await (_db.select(
              _db.parties,
            )..where((p) => p.id.equals(draft.partyId!))).getSingle();
      final shop = await _db.select(_db.shopProfiles).getSingleOrNull();
      final interState =
          supplier?.stateCode != null &&
          shop != null &&
          supplier!.stateCode != shop.stateCode;
      final paid = draft.paidNow > totals.grandTotal
          ? totals.grandTotal
          : draft.paidNow;
      final due = credit ? totals.grandTotal - paid : Money.zero;

      final purchaseId = await _db
          .into(_db.purchases)
          .insert(
            PurchasesCompanion.insert(
              partyId: Value(draft.partyId),
              supplierName: Value(supplier?.name),
              supplierGstin: Value(supplier?.gstin),
              supplierInvoiceNo: Value(_blankToNull(draft.supplierInvoiceNo)),
              purchasedAt: draft.purchasedAt ?? _clock(),
              interState: Value(interState),
              taxablePaise: totals.taxable.paise,
              taxPaise: totals.tax.paise,
              totalPaise: totals.grandTotal.paise,
              duePaise: Value(due.paise),
              paymentMode: draft.paymentMode.name,
              note: Value(_blankToNull(draft.note)),
            ),
          );

      for (var i = 0; i < draft.lines.length; i++) {
        final line = draft.lines[i];
        final amounts = totals.lines[i];
        await _db
            .into(_db.purchaseLines)
            .insert(
              PurchaseLinesCompanion.insert(
                purchaseId: purchaseId,
                position: i,
                itemId: Value(line.itemId),
                name: line.name.trim(),
                unit: line.unit,
                hsn: Value(line.hsn),
                quantityMilli: line.quantity.milli,
                unitCostPaise: line.unitCost.paise,
                costIncludesTax: line.costIncludesTax,
                taxRateBp: line.taxRate.bp,
                taxablePaise: amounts.taxable.paise,
                taxPaise: amounts.tax.paise,
                totalPaise: amounts.total.paise,
                batchNo: Value(_blankToNull(line.batchNo)),
                expiry: Value(line.expiry),
              ),
            );
        if (line.itemId != null) {
          await _receive(line, amounts.taxable, purchaseId);
        }
      }

      if (due.isPositive) {
        await _dues.post(
          partyId: draft.partyId!,
          amountPaise: due.paise,
          type: EntryType.purchase,
          note: _purchaseNote(purchaseId, draft.supplierInvoiceNo),
        );
      }
      return purchaseId;
    });
    return (await byId(id))!;
  }

  /// Brings one line's stock in and updates the item's cost price.
  Future<void> _receive(
    PurchaseDraftLine line,
    Money taxable,
    int purchaseId,
  ) async {
    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(line.itemId!))).getSingle();
    // Cost per base unit, before GST (the GST comes back as input credit).
    if (line.quantity.isPositive) {
      await (_db.update(_db.items)..where((t) => t.id.equals(item.id))).write(
        ItemsCompanion(
          costPricePaise: Value(
            divRound(taxable.paise * 1000, line.quantity.milli),
          ),
        ),
      );
    }
    if (!item.trackStock) return;
    int? batchId;
    if (item.tracksBatches) {
      batchId = await _stock.batchFor(
        item.id,
        _blankToNull(line.batchNo) ?? 'P$purchaseId',
        line.expiry,
      );
    }
    await _stock.post(
      itemId: item.id,
      quantityMilli: line.quantity.milli,
      type: MovementType.purchase,
      batchId: batchId,
      note: 'Purchase #$purchaseId',
    );
  }

  @override
  Future<Purchase?> byId(int id) async {
    final row = await (_db.select(
      _db.purchases,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final lines =
        await (_db.select(_db.purchaseLines)
              ..where((l) => l.purchaseId.equals(id))
              ..orderBy([(l) => OrderingTerm.asc(l.position)]))
            .get();
    return _toDomain(row, lines);
  }

  @override
  Stream<List<Purchase>> watchBetween(DateTime from, DateTime to) {
    final query = _db.select(_db.purchases)
      ..where(
        (p) =>
            p.purchasedAt.isBiggerOrEqualValue(from) &
            p.purchasedAt.isSmallerThanValue(to),
      )
      ..orderBy([(p) => OrderingTerm.desc(p.purchasedAt)]);
    return query.watch().asyncMap((rows) async {
      final ids = rows.map((r) => r.id).toList();
      final lines = ids.isEmpty
          ? <PurchaseLineRow>[]
          : await (_db.select(_db.purchaseLines)
                  ..where((l) => l.purchaseId.isIn(ids))
                  ..orderBy([(l) => OrderingTerm.asc(l.position)]))
                .get();
      return [
        for (final r in rows)
          _toDomain(r, lines.where((l) => l.purchaseId == r.id).toList()),
      ];
    });
  }

  @override
  Future<void> cancel(int id) => _db.transaction(() async {
    final changed =
        await (_db.update(
          _db.purchases,
        )..where((p) => p.id.equals(id) & p.status.equals('completed'))).write(
          PurchasesCompanion(
            status: const Value('cancelled'),
            cancelledAt: Value(_clock()),
          ),
        );
    if (changed == 0) return;
    final purchase = (await byId(id))!;
    for (final line in purchase.lines) {
      if (line.itemId == null) continue;
      final item = await (_db.select(
        _db.items,
      )..where((t) => t.id.equals(line.itemId!))).getSingle();
      if (!item.trackStock) continue;
      int? batchId;
      if (item.tracksBatches) {
        batchId = await _stock.batchFor(item.id, line.batchNo ?? 'P$id', null);
      }
      await _stock.post(
        itemId: item.id,
        quantityMilli: -line.quantity.milli,
        type: MovementType.cancel,
        batchId: batchId,
        note: 'Purchase #$id cancelled',
      );
    }
    if (purchase.due.isPositive && purchase.partyId != null) {
      await _dues.post(
        partyId: purchase.partyId!,
        amountPaise: -purchase.due.paise,
        type: EntryType.cancel,
        note: 'Cancelled: ${_purchaseNote(id, purchase.supplierInvoiceNo)}',
      );
    }
  });

  static String _purchaseNote(int id, String? supplierInvoiceNo) {
    final no = _blankToNull(supplierInvoiceNo);
    return no == null ? 'Purchase #$id' : 'Purchase #$id (bill $no)';
  }

  static Purchase _toDomain(PurchaseRow r, List<PurchaseLineRow> lines) =>
      Purchase(
        id: r.id,
        partyId: r.partyId,
        supplierName: r.supplierName,
        supplierGstin: r.supplierGstin,
        supplierInvoiceNo: r.supplierInvoiceNo,
        purchasedAt: r.purchasedAt,
        interState: r.interState,
        taxable: Money.paise(r.taxablePaise),
        tax: Money.paise(r.taxPaise),
        total: Money.paise(r.totalPaise),
        due: Money.paise(r.duePaise),
        paymentMode: PaymentMode.values.byName(r.paymentMode),
        note: r.note,
        isCancelled: r.status == 'cancelled',
        lines: [
          for (final l in lines)
            PurchaseLine(
              itemId: l.itemId,
              name: l.name,
              unit: l.unit,
              hsn: l.hsn,
              quantity: Quantity.milli(l.quantityMilli),
              unitCost: Money.paise(l.unitCostPaise),
              costIncludesTax: l.costIncludesTax,
              taxRate: TaxRate(l.taxRateBp),
              taxable: Money.paise(l.taxablePaise),
              tax: Money.paise(l.taxPaise),
              total: Money.paise(l.totalPaise),
              batchNo: l.batchNo,
              expiry: l.expiry,
            ),
        ],
      );

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
