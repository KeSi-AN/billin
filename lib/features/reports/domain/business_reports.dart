// Report rows keep every column (empty or not), so conditional expressions
// (not `if` elements, which would drop cells) are intended.
// ignore_for_file: prefer_if_elements_to_conditional_expressions

import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/reports/domain/gst_report.dart';
import 'package:shop_app/features/reports/domain/report_doc.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

enum ReportKind {
  sales,
  purchases,
  profitLoss,
  stockValue,
  itemWise,
  customerWise,
  dayBook,
}

/// Quantity in base units (a box of 12 sold = 12 pcs).
Quantity _baseQty(Quantity q, Quantity unitFactor) =>
    Quantity.milli(divRound(q.milli * unitFactor.milli, 1000));

Amount _a(Money m) => Amount(m);
Amount? _an(Money? m) => m == null ? null : Amount(m);

/// What one item sold in a period, net of returns.
class ItemSales {
  ItemSales(this.name, this.unit);

  final String name;
  final String unit;
  Quantity quantity = Quantity.zero;

  /// Invoice value (with GST).
  Money sales = Money.zero;
  Money taxable = Money.zero;
  Money cost = Money.zero;

  /// Some sales of this item had no cost price.
  bool costMissing = false;

  Money? get profit => costMissing ? null : taxable - cost;
}

/// Item-wise sales, biggest first. Lines are matched by item (quick items by
/// name); returns are taken off the item they came from.
List<ItemSales> itemSales(
  Iterable<Bill> bills, {
  Iterable<CreditNote> notes = const [],
  Map<int, Bill> noteBills = const {},
  Map<int, Item> items = const {},
}) {
  final out = <Object, ItemSales>{};
  ItemSales entry(BillLine l) {
    final item = l.itemId == null ? null : items[l.itemId];
    return out.putIfAbsent(
      l.itemId ?? 'name:${l.name.toLowerCase()}',
      () => ItemSales(item?.name ?? l.name, item?.unit ?? l.unit),
    );
  }

  for (final b in bills.where((b) => !b.isCancelled)) {
    for (final l in b.lines) {
      final e = entry(l)
        ..quantity += _baseQty(l.quantity, l.unitFactor)
        ..sales += l.total
        ..taxable += l.taxable;
      if (l.cost == null) {
        e.costMissing = true;
      } else {
        e.cost += l.cost!;
      }
    }
  }
  for (final n in notes) {
    final bill = noteBills[n.billId];
    if (bill == null) continue;
    for (final r in n.lines) {
      final l = bill.lines.where((x) => x.id == r.billLineId).firstOrNull;
      if (l == null) continue;
      final e = entry(l)
        ..quantity -= _baseQty(r.quantity, l.unitFactor)
        ..sales -= r.total
        ..taxable -= r.taxable;
      if (r.cost != null) e.cost -= r.cost!;
    }
  }
  return out.values.toList()
    ..sort((a, b) => b.sales.paise.compareTo(a.sales.paise));
}

/// The business reports (everything except the GST export), built from the
/// records of a period.
class BusinessReports {
  BusinessReports(this.input, this.l10n);

  final ReportInput input;
  final AppLocalizations l10n;

  Iterable<Bill> get _completed => input.bills.where((b) => !b.isCancelled);

  Money _sum<T>(Iterable<T> xs, Money Function(T) f) =>
      xs.fold(Money.zero, (s, x) => s + f(x));

  String _mode(PaymentMode m) => switch (m) {
    PaymentMode.cash => l10n.paymentCash,
    PaymentMode.upi => l10n.paymentUpi,
    PaymentMode.card => l10n.paymentCard,
    PaymentMode.credit => l10n.paymentCredit,
  };

  String title(ReportKind kind) => switch (kind) {
    ReportKind.sales => l10n.rpSales,
    ReportKind.purchases => l10n.rpPurchases,
    ReportKind.profitLoss => l10n.rpProfitLoss,
    ReportKind.stockValue => l10n.rpStockValue,
    ReportKind.itemWise => l10n.rpItemWise,
    ReportKind.customerWise => l10n.rpCustomerWise,
    ReportKind.dayBook => l10n.rpDayBook,
  };

  ReportDoc build(ReportKind kind) => switch (kind) {
    ReportKind.sales => sales(),
    ReportKind.purchases => purchases(),
    ReportKind.profitLoss => profitLoss(),
    ReportKind.stockValue => stockValue(),
    ReportKind.itemWise => itemWise(),
    ReportKind.customerWise => customerWise(),
    ReportKind.dayBook => dayBook(),
  };

  ReportDoc _doc(
    ReportKind kind, {
    List<(String, Object)> summary = const [],
    List<ReportTable> tables = const [],
    List<String> notes = const [],
  }) => ReportDoc(
    title: title(kind),
    from: input.from,
    to: input.to,
    summary: summary,
    tables: tables,
    notes: notes,
  );

  // ---------------------------------------------------------------- sales

  ReportDoc sales() {
    final bills = _completed.toList();
    final gross = _sum(bills, (b) => b.grandTotal);
    final returns = _sum(input.creditNotes, (n) => n.total);
    final gst =
        _sum(bills, (b) => b.tax) - _sum(input.creditNotes, (n) => n.tax);
    final cancelled = input.bills.length - bills.length;

    final days = <DateTime, List<Bill>>{};
    for (final b in bills) {
      final d = DateTime(b.billedAt.year, b.billedAt.month, b.billedAt.day);
      days.putIfAbsent(d, () => []).add(b);
    }
    Money byMode(Iterable<Bill> bs, PaymentMode m) =>
        _sum(bs.where((b) => b.paymentMode == m), (b) => b.grandTotal);
    List<Object?> dayRow(Object label, Iterable<Bill> bs) => [
      label,
      bs.length,
      for (final m in PaymentMode.values) _a(byMode(bs, m)),
      _a(_sum(bs, (b) => b.grandTotal)),
    ];

    return _doc(
      ReportKind.sales,
      summary: [
        (l10n.rpBills, bills.length),
        (l10n.rpSalesAmount, _a(gross)),
        (l10n.rpDiscounts, _a(_sum(bills, (b) => b.totalDiscount))),
        (l10n.rpGstCollected, _a(gst)),
        (l10n.rpReturns, _a(returns)),
        (l10n.rpNetSales, _a(gross - returns)),
        if (bills.isNotEmpty)
          (
            l10n.rpAverageBill,
            _a(Money.paise(divRound(gross.paise, bills.length))),
          ),
      ],
      tables: [
        ReportTable(
          title: l10n.rpByDay,
          columns: [
            l10n.rpDate,
            l10n.rpBills,
            for (final m in PaymentMode.values) _mode(m),
            l10n.rpTotal,
          ],
          rows: [
            for (final d in days.keys.toList()..sort())
              dayRow(Day(d), days[d]!),
          ],
          totals: dayRow(l10n.rpTotal, bills),
        ),
        ReportTable(
          title: l10n.rpByMode,
          columns: [l10n.rpMode, l10n.rpBills, l10n.rpAmount],
          rows: [
            for (final m in PaymentMode.values)
              [
                _mode(m),
                bills.where((b) => b.paymentMode == m).length,
                _a(byMode(bills, m)),
              ],
          ],
        ),
      ],
      notes: [if (cancelled > 0) l10n.rpCancelledNote(cancelled)],
    );
  }

  // ------------------------------------------------------------ purchases

  ReportDoc purchases() {
    final list = input.purchases.where((p) => !p.isCancelled).toList()
      ..sort((a, b) => a.purchasedAt.compareTo(b.purchasedAt));
    final bySupplier = <String, (int, Money, Money)>{};
    for (final p in list) {
      final name = p.supplierName ?? l10n.rpNoSupplier;
      final (n, total, due) = bySupplier[name] ?? (0, Money.zero, Money.zero);
      bySupplier[name] = (n + 1, total + p.total, due + p.due);
    }
    final suppliers = bySupplier.entries.toList()
      ..sort((a, b) => b.value.$2.paise.compareTo(a.value.$2.paise));
    final taxable = _sum(list, (p) => p.taxable);
    final tax = _sum(list, (p) => p.tax);
    final total = _sum(list, (p) => p.total);
    final due = _sum(list, (p) => p.due);
    return _doc(
      ReportKind.purchases,
      summary: [
        (l10n.rpPurchaseCount, list.length),
        (l10n.rpTaxable, _a(taxable)),
        (l10n.rpGst, _a(tax)),
        (l10n.rpTotal, _a(total)),
        (l10n.rpOwed, _a(due)),
      ],
      tables: [
        ReportTable(
          title: l10n.rpPurchaseList,
          columns: [
            l10n.rpDate,
            l10n.rpSupplier,
            l10n.rpInvoiceNo,
            l10n.rpItems,
            l10n.rpTaxable,
            l10n.rpGst,
            l10n.rpTotal,
            l10n.rpDue,
          ],
          rows: [
            for (final p in list)
              [
                Day(p.purchasedAt),
                p.supplierName ?? l10n.rpNoSupplier,
                p.supplierInvoiceNo,
                p.lines.length,
                _a(p.taxable),
                _a(p.tax),
                _a(p.total),
                _a(p.due),
              ],
          ],
          totals: [
            l10n.rpTotal,
            null,
            null,
            null,
            _a(taxable),
            _a(tax),
            _a(total),
            _a(due),
          ],
        ),
        ReportTable(
          title: l10n.rpBySupplier,
          columns: [
            l10n.rpSupplier,
            l10n.rpPurchaseCount,
            l10n.rpTotal,
            l10n.rpDue,
          ],
          rows: [
            for (final MapEntry(key: name, value: (n, t, d)) in suppliers)
              [name, n, _a(t), _a(d)],
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------- profit/loss

  ReportDoc profitLoss() {
    var revenue = Money.zero; // taxable value of sales, net of returns
    var cogs = Money.zero;
    var noCost = Money.zero; // revenue from lines with no cost price
    for (final b in _completed) {
      for (final l in b.lines) {
        revenue += l.taxable;
        if (l.cost == null) {
          noCost += l.taxable;
        } else {
          cogs += l.cost!;
        }
      }
    }
    for (final n in input.creditNotes) {
      for (final l in n.lines) {
        revenue -= l.taxable;
        if (l.cost == null) {
          noCost -= l.taxable;
        } else {
          cogs -= l.cost!;
        }
      }
    }
    final gross = revenue - noCost - cogs;
    final byCategory = <String, (int, Money)>{};
    for (final e in input.expenses) {
      final (n, amount) = byCategory[e.category] ?? (0, Money.zero);
      byCategory[e.category] = (n + 1, amount + e.amount);
    }
    final categories = byCategory.entries.toList()
      ..sort((a, b) => b.value.$2.paise.compareTo(a.value.$2.paise));
    final expenses = _sum(input.expenses, (e) => e.amount);
    return _doc(
      ReportKind.profitLoss,
      summary: [
        (l10n.rpSalesExGst, _a(revenue)),
        (l10n.rpCogs, _a(-cogs)),
        (l10n.rpGrossProfit, _a(gross)),
        (l10n.rpExpenses, _a(-expenses)),
        (l10n.rpNetProfit, _a(gross - expenses)),
      ],
      tables: [
        ReportTable(
          title: l10n.rpExpensesByCategory,
          columns: [l10n.rpCategory, l10n.rpCount, l10n.rpAmount],
          rows: [
            for (final MapEntry(key: c, value: (n, a)) in categories)
              [c, n, _a(a)],
          ],
          totals: [l10n.rpTotal, input.expenses.length, _a(expenses)],
        ),
      ],
      notes: [if (noCost.isPositive) l10n.rpNoCostNote(noCost.format())],
    );
  }

  // ----------------------------------------------------------- stock value

  ReportDoc stockValue() {
    final tracked = input.items.where((i) => i.trackStock).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    Money value(Money? price, Quantity q) => price == null || !q.isPositive
        ? Money.zero
        : Money.paise(divRound(price.paise * q.milli, 1000));
    final atCost = _sum(tracked, (i) => value(i.costPrice, i.stock));
    final atSale = _sum(tracked, (i) => value(i.salePrice, i.stock));
    final noCost = tracked
        .where((i) => i.costPrice == null && i.stock.isPositive)
        .length;
    return _doc(
      ReportKind.stockValue,
      summary: [
        (l10n.rpItemsInStock, tracked.where((i) => i.stock.isPositive).length),
        (l10n.rpValueAtCost, _a(atCost)),
        (l10n.rpValueAtSale, _a(atSale)),
      ],
      tables: [
        ReportTable(
          title: l10n.rpStockValue,
          columns: [
            l10n.rpItem,
            l10n.rpStock,
            l10n.rpUnit,
            l10n.rpCostPrice,
            l10n.rpValueAtCost,
            l10n.rpSalePrice,
            l10n.rpValueAtSale,
          ],
          rows: [
            for (final i in tracked)
              [
                i.name,
                Qty(i.stock),
                i.unit,
                _an(i.costPrice),
                i.costPrice == null ? null : _a(value(i.costPrice, i.stock)),
                _a(i.salePrice),
                _a(value(i.salePrice, i.stock)),
              ],
          ],
          totals: [
            l10n.rpTotal,
            null,
            null,
            null,
            _a(atCost),
            null,
            _a(atSale),
          ],
        ),
      ],
      notes: [l10n.rpStockAsOf, if (noCost > 0) l10n.rpMissingCost(noCost)],
    );
  }

  // ------------------------------------------------------------- item-wise

  ReportDoc itemWise() {
    final list = itemSales(
      input.bills,
      notes: input.creditNotes,
      noteBills: input.creditNoteBills,
      items: {for (final i in input.items) i.id!: i},
    );
    final sales = _sum(list, (s) => s.sales);
    final profit = _sum(list.where((s) => s.profit != null), (s) => s.profit!);
    final noCost = list.where((s) => s.costMissing);
    return _doc(
      ReportKind.itemWise,
      summary: [
        (l10n.rpItemsSold, list.where((s) => s.quantity.isPositive).length),
        (l10n.rpSalesAmount, _a(sales)),
        (l10n.rpProfit, _a(profit)),
      ],
      tables: [
        ReportTable(
          title: l10n.rpItemWise,
          columns: [
            l10n.rpItem,
            l10n.rpQtySold,
            l10n.rpUnit,
            l10n.rpSalesAmount,
            l10n.rpProfit,
          ],
          rows: [
            for (final s in list)
              [s.name, Qty(s.quantity), s.unit, _a(s.sales), _an(s.profit)],
          ],
          totals: [l10n.rpTotal, null, null, _a(sales), _a(profit)],
        ),
      ],
      notes: [
        if (noCost.isNotEmpty)
          l10n.rpNoCostNote(_sum(noCost, (s) => s.taxable).format()),
      ],
    );
  }

  // --------------------------------------------------------- customer-wise

  ReportDoc customerWise() {
    final customers = {
      for (final p in input.parties)
        if (p.type == PartyType.customer) p.id!: p,
    };
    final rows = <int?, _CustomerRow>{};
    _CustomerRow row(int? partyId) =>
        rows.putIfAbsent(partyId, _CustomerRow.new);
    for (final b in _completed) {
      final id = customers.containsKey(b.partyId) ? b.partyId : null;
      row(id)
        ..bills += 1
        ..sales += b.grandTotal;
    }
    for (final n in input.creditNotes) {
      final partyId = input.creditNoteBills[n.billId]?.partyId;
      row(customers.containsKey(partyId) ? partyId : null).returns += n.total;
    }
    for (final e in input.entries) {
      if (e.type == EntryType.payment && customers.containsKey(e.partyId)) {
        row(e.partyId).received += -e.amount;
      }
    }
    final ordered = rows.entries.toList()
      ..sort((a, b) => b.value.sales.paise.compareTo(a.value.sales.paise));
    final sales = _sum(rows.values, (r) => r.sales);
    final returns = _sum(rows.values, (r) => r.returns);
    final received = _sum(rows.values, (r) => r.received);
    final totalDue = _sum(
      customers.values.where((p) => p.balance.isPositive),
      (p) => p.balance,
    );
    return _doc(
      ReportKind.customerWise,
      summary: [
        (l10n.rpCustomers, rows.keys.where((k) => k != null).length),
        (l10n.rpSalesAmount, _a(sales)),
        (l10n.rpReceived, _a(received)),
        (l10n.rpBalance, _a(totalDue)),
      ],
      tables: [
        ReportTable(
          title: l10n.rpCustomerWise,
          columns: [
            l10n.rpCustomer,
            l10n.rpBills,
            l10n.rpSalesAmount,
            l10n.rpReturns,
            l10n.rpReceived,
            l10n.rpBalance,
          ],
          rows: [
            for (final MapEntry(key: id, value: r) in ordered)
              [
                id == null ? l10n.rpWalkIn : customers[id]!.name,
                r.bills,
                _a(r.sales),
                _a(r.returns),
                id == null ? null : _a(r.received),
                id == null ? null : _a(customers[id]!.balance),
              ],
          ],
          totals: [
            l10n.rpTotal,
            _completed.length,
            _a(sales),
            _a(returns),
            _a(received),
            null,
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------- day book

  ReportDoc dayBook() {
    final parties = {for (final p in input.parties) p.id!: p};
    final events = <_Event>[];
    for (final b in _completed) {
      final credit = b.paymentMode == PaymentMode.credit;
      events.add(
        _Event(
          at: b.billedAt,
          entry: credit ? l10n.rpEntryCreditSale : l10n.rpEntrySale,
          ref: b.invoiceNo,
          party: b.customerName,
          mode: b.paymentMode,
          amount: b.grandTotal,
          moneyIn: credit ? Money.zero : b.grandTotal,
        ),
      );
    }
    for (final e in input.entries.where((e) => e.type == EntryType.payment)) {
      final p = parties[e.partyId];
      final supplier = p?.type == PartyType.supplier;
      final amount = -e.amount;
      events.add(
        _Event(
          at: e.at,
          entry: supplier ? l10n.rpEntrySupplierPayment : l10n.rpEntryReceipt,
          ref: e.invoiceNo,
          party: p?.name,
          mode: e.paymentMode ?? PaymentMode.cash,
          amount: amount,
          moneyIn: supplier ? Money.zero : amount,
          moneyOut: supplier ? amount : Money.zero,
        ),
      );
    }
    for (final n in input.creditNotes) {
      final refunded = n.refundMode != PaymentMode.credit;
      events.add(
        _Event(
          at: n.issuedAt,
          entry: l10n.rpEntryReturn,
          ref: n.noteNo,
          party: input.creditNoteBills[n.billId]?.customerName,
          mode: n.refundMode,
          amount: n.total,
          moneyOut: refunded ? n.total : Money.zero,
        ),
      );
    }
    for (final p in input.purchases.where((p) => !p.isCancelled)) {
      events.add(
        _Event(
          at: p.purchasedAt,
          entry: l10n.rpEntryPurchase,
          ref: p.supplierInvoiceNo,
          party: p.supplierName,
          // What's paid at purchase time on a credit purchase is cash.
          mode: p.paymentMode == PaymentMode.credit
              ? PaymentMode.cash
              : p.paymentMode,
          amount: p.total,
          moneyOut: p.total - p.due,
        ),
      );
    }
    for (final e in input.expenses) {
      events.add(
        _Event(
          at: e.spentAt,
          entry: l10n.rpEntryExpense,
          ref: e.category,
          party: e.note,
          mode: e.paymentMode,
          amount: e.amount,
          moneyOut: e.amount,
        ),
      );
    }
    events.sort((a, b) => a.at.compareTo(b.at));
    final moneyIn = _sum(events, (e) => e.moneyIn);
    final moneyOut = _sum(events, (e) => e.moneyOut);
    Money net(PaymentMode m) =>
        _sum(events.where((e) => e.mode == m), (e) => e.moneyIn - e.moneyOut);
    return _doc(
      ReportKind.dayBook,
      summary: [
        (l10n.rpIn, _a(moneyIn)),
        (l10n.rpOut, _a(moneyOut)),
        (l10n.rpNet, _a(moneyIn - moneyOut)),
        (l10n.rpCashNet, _a(net(PaymentMode.cash))),
        (l10n.rpUpiNet, _a(net(PaymentMode.upi))),
        (l10n.rpCardNet, _a(net(PaymentMode.card))),
      ],
      tables: [
        ReportTable(
          title: l10n.rpDayBook,
          columns: [
            l10n.rpTime,
            l10n.rpEntry,
            l10n.rpRef,
            l10n.rpParty,
            l10n.rpMode,
            l10n.rpAmount,
            l10n.rpIn,
            l10n.rpOut,
          ],
          rows: [
            for (final e in events)
              [
                e.at,
                e.entry,
                e.ref,
                e.party,
                _mode(e.mode),
                _a(e.amount),
                e.moneyIn.isZero ? null : _a(e.moneyIn),
                e.moneyOut.isZero ? null : _a(e.moneyOut),
              ],
          ],
          totals: [
            l10n.rpTotal,
            null,
            null,
            null,
            null,
            null,
            _a(moneyIn),
            _a(moneyOut),
          ],
        ),
      ],
    );
  }
}

class _CustomerRow {
  int bills = 0;
  Money sales = Money.zero;
  Money returns = Money.zero;
  Money received = Money.zero;
}

class _Event {
  _Event({
    required this.at,
    required this.entry,
    required this.mode,
    required this.amount,
    this.ref,
    this.party,
    this.moneyIn = Money.zero,
    this.moneyOut = Money.zero,
  });

  final DateTime at;
  final String entry;
  final String? ref;
  final String? party;
  final PaymentMode mode;
  final Money amount;
  final Money moneyIn;
  final Money moneyOut;
}
