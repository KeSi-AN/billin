// Report rows keep every column (empty or not), so conditional expressions
// (not `if` elements, which would drop cells) are intended.
// ignore_for_file: prefer_if_elements_to_conditional_expressions

import 'package:intl/intl.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/import_export/spreadsheet.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// Inter-state B2C invoices above this value go in GSTR-1 table 5 (B2CL)
/// one by one; smaller ones are summarised in B2CS. (₹1 lakh since
/// August 2024.)
const b2clThreshold = Money.rupees(100000);

/// GST split of a tax amount: IGST for inter-state, else CGST + SGST
/// (odd paisa to SGST, as on the invoice).
typedef TaxSplit = ({Money igst, Money cgst, Money sgst});

TaxSplit splitTax(Money tax, {required bool interState}) {
  if (interState) return (igst: tax, cgst: Money.zero, sgst: Money.zero);
  final cgst = Money.paise(tax.paise ~/ 2);
  return (igst: Money.zero, cgst: cgst, sgst: tax - cgst);
}

TaxSplit _add(TaxSplit a, TaxSplit b) =>
    (igst: a.igst + b.igst, cgst: a.cgst + b.cgst, sgst: a.sgst + b.sgst);

const TaxSplit _noTax = (igst: Money.zero, cgst: Money.zero, sgst: Money.zero);

/// Everything recorded in a period, ready to report on.
class ReportInput {
  const ReportInput({
    required this.shop,
    required this.from,
    required this.to,
    required this.bills,
    required this.creditNotes,
    required this.creditNoteBills,
    required this.purchases,
    required this.expenses,
    this.items = const [],
    this.parties = const [],
    this.entries = const [],
  });

  final ShopProfile shop;
  final DateTime from;
  final DateTime to;

  /// Bills dated in the period, including cancelled ones.
  final List<Bill> bills;
  final List<CreditNote> creditNotes;

  /// The original bill of each credit note (may be from an earlier month).
  final Map<int, Bill> creditNoteBills;
  final List<Purchase> purchases;
  final List<Expense> expenses;

  /// Current items (for stock value and item names); not period-bound.
  final List<Item> items;

  /// Customers and suppliers, current balances.
  final List<Party> parties;

  /// Ledger entries of every party in the period, oldest first.
  final List<PartyEntry> entries;
}

class MonthSummary {
  const MonthSummary({
    required this.billCount,
    required this.cancelledCount,
    required this.sales,
    required this.salesTaxable,
    required this.outputTax,
    required this.returns,
    required this.returnsTax,
    required this.purchases,
    required this.inputTax,
    required this.expenses,
    required this.grossProfit,
    required this.profitIsPartial,
  });

  final int billCount;
  final int cancelledCount;

  /// Invoice value of completed bills.
  final Money sales;
  final Money salesTaxable;
  final TaxSplit outputTax;

  /// Credit notes (returns) issued in the period.
  final Money returns;
  final TaxSplit returnsTax;
  final Money purchases;

  /// GST paid on purchases from registered suppliers (input tax credit).
  final TaxSplit inputTax;
  final Money expenses;

  /// Sales minus cost of goods (on lines whose cost is known), net of
  /// returns.
  final Money grossProfit;
  final bool profitIsPartial;

  Money get netSales => sales - returns;
  Money get netProfit => grossProfit - expenses;

  Money _total(TaxSplit t) => t.igst + t.cgst + t.sgst;
  Money get netOutputTax => _total(outputTax) - _total(returnsTax);
  Money get totalInputTax => _total(inputTax);

  /// Output GST minus input credit. Negative: credit carried forward.
  Money get gstPayable => netOutputTax - totalInputTax;
}

/// Builds the month summary and the GSTR-1 style workbook.
class GstReport {
  GstReport(this.input);

  final ReportInput input;

  final _date = DateFormat('dd-MMM-yyyy', 'en_IN');

  Iterable<Bill> get _completed => input.bills.where((b) => !b.isCancelled);

  String _pos(String? code) {
    final c = code ?? input.shop.stateCode;
    return '$c-${stateByCode(c)?.name ?? ''}';
  }

  static String _num(Money m) {
    final p = m.paise;
    final sign = p < 0 ? '-' : '';
    final a = p.abs();
    return '$sign${a ~/ 100}.${(a % 100).toString().padLeft(2, '0')}';
  }

  static String _rate(TaxRate r) => r.label.replaceAll('%', '');

  /// Per-rate taxable and tax for a set of lines.
  static Map<int, (Money, Money)> _byRate(
    Iterable<(TaxRate, Money, Money)> lines,
  ) {
    final out = <int, (Money, Money)>{};
    for (final (rate, taxable, tax) in lines) {
      final (t, x) = out[rate.bp] ?? (Money.zero, Money.zero);
      out[rate.bp] = (t + taxable, x + tax);
    }
    return out;
  }

  MonthSummary summary() {
    var output = _noTax;
    var returnsTax = _noTax;
    var input = _noTax;
    var profit = Money.zero;
    var partial = false;
    for (final b in _completed) {
      for (final bucket in b.taxBuckets) {
        output = _add(output, splitTax(bucket.tax, interState: b.interState));
      }
      if (b.profit != null) profit = profit + b.profit!;
      partial = partial || b.profitIsPartial;
    }
    for (final cn in this.input.creditNotes) {
      final bill = this.input.creditNoteBills[cn.billId]!;
      for (final rate in _byRate(
        cn.lines.map((l) => (l.taxRate, l.taxable, l.tax)),
      ).values) {
        returnsTax = _add(
          returnsTax,
          splitTax(rate.$2, interState: bill.interState),
        );
      }
      for (final l in cn.lines) {
        if (l.cost == null) {
          partial = true;
        } else {
          profit = profit - (l.taxable - l.cost!);
        }
      }
    }
    final activePurchases = this.input.purchases.where((p) => !p.isCancelled);
    for (final p in activePurchases) {
      if (p.supplierGstin == null) continue; // no credit without a GSTIN
      input = _add(input, splitTax(p.tax, interState: p.interState));
    }
    Money sum<T>(Iterable<T> xs, Money Function(T) f) =>
        xs.fold(Money.zero, (s, x) => s + f(x));
    return MonthSummary(
      billCount: _completed.length,
      cancelledCount: this.input.bills.where((b) => b.isCancelled).length,
      sales: sum(_completed, (b) => b.grandTotal),
      salesTaxable: sum(_completed, (b) => b.taxable),
      outputTax: output,
      returns: sum(this.input.creditNotes, (c) => c.total),
      returnsTax: returnsTax,
      purchases: sum(activePurchases, (p) => p.total),
      inputTax: input,
      expenses: sum(this.input.expenses, (e) => e.amount),
      grossProfit: profit,
      profitIsPartial: partial,
    );
  }

  /// Things the CA should know before filing (missing HSN etc.).
  List<String> warnings() {
    final out = <String>[];
    final noHsn = <String>{
      for (final b in _completed)
        for (final l in b.lines)
          if (l.hsn == null && !l.taxRate.isZero) l.name,
    };
    if (noHsn.isNotEmpty) {
      out.add('Missing HSN code on: ${(noHsn.toList()..sort()).join(', ')}');
    }
    if (input.shop.gstin == null) {
      out.add('The shop has no GSTIN: these are not GST invoices.');
    }
    return out;
  }

  List<SheetData> workbook() => [
    _summarySheet(),
    _b2b(),
    _b2cl(),
    _b2cs(),
    _cdnr(),
    _hsn(b2b: true),
    _hsn(b2b: false),
    _docs(),
    _purchases(),
  ];

  SheetData _summarySheet() {
    final s = summary();
    final period =
        '${_date.format(input.from)} to ${_date.format(input.to.subtract(const Duration(days: 1)))}';
    final rows = <List<String>>[
      ['Item', 'Value'],
      ['Shop', input.shop.name],
      ['GSTIN', input.shop.gstin ?? '(not registered)'],
      ['Period', period],
      ['Invoices', '${s.billCount}'],
      ['Cancelled invoices', '${s.cancelledCount}'],
      ['Sales (invoice value)', _num(s.sales)],
      ['Sales taxable value', _num(s.salesTaxable)],
      ['Output IGST', _num(s.outputTax.igst)],
      ['Output CGST', _num(s.outputTax.cgst)],
      ['Output SGST', _num(s.outputTax.sgst)],
      ['Credit notes (returns)', _num(s.returns)],
      ['Returns IGST', _num(s.returnsTax.igst)],
      ['Returns CGST', _num(s.returnsTax.cgst)],
      ['Returns SGST', _num(s.returnsTax.sgst)],
      ['Purchases', _num(s.purchases)],
      ['Input tax credit IGST', _num(s.inputTax.igst)],
      ['Input tax credit CGST', _num(s.inputTax.cgst)],
      ['Input tax credit SGST', _num(s.inputTax.sgst)],
      ['GST payable (output - returns - ITC)', _num(s.gstPayable)],
      ['Expenses', _num(s.expenses)],
      [
        s.profitIsPartial
            ? 'Gross profit (items with cost only)'
            : 'Gross profit',
        _num(s.grossProfit),
      ],
      ['Net profit (gross profit - expenses)', _num(s.netProfit)],
      for (final w in warnings()) ['Note', w],
    ];
    return (name: 'Summary', rows: rows, numericColumns: const {1});
  }

  SheetData _b2b() {
    final rows = <List<String>>[
      [
        'GSTIN/UIN of Recipient',
        'Receiver Name',
        'Invoice Number',
        'Invoice date',
        'Invoice Value',
        'Place Of Supply',
        'Reverse Charge',
        'Invoice Type',
        'Rate',
        'Taxable Value',
        'Integrated Tax',
        'Central Tax',
        'State/UT Tax',
        'Cess Amount',
      ],
    ];
    for (final b in _completed.where((b) => b.isB2B)) {
      final rates = _byRate(b.lines.map((l) => (l.taxRate, l.taxable, l.tax)));
      for (final MapEntry(key: bp, value: (taxable, tax)) in rates.entries) {
        final t = splitTax(tax, interState: b.interState);
        rows.add([
          b.buyerGstin!,
          b.customerName ?? '',
          b.invoiceNo,
          _date.format(b.billedAt),
          _num(b.grandTotal),
          _pos(b.placeOfSupply),
          'N',
          'Regular B2B',
          _rate(TaxRate(bp)),
          _num(taxable),
          _num(t.igst),
          _num(t.cgst),
          _num(t.sgst),
          '0.00',
        ]);
      }
    }
    return (
      name: 'B2B',
      rows: rows,
      numericColumns: const {4, 8, 9, 10, 11, 12, 13},
    );
  }

  bool _isB2cl(Bill b) =>
      !b.isB2B && b.interState && b.grandTotal > b2clThreshold;

  SheetData _b2cl() {
    final rows = <List<String>>[
      [
        'Invoice Number',
        'Invoice date',
        'Invoice Value',
        'Place Of Supply',
        'Rate',
        'Taxable Value',
        'Integrated Tax',
        'Cess Amount',
      ],
    ];
    for (final b in _completed.where(_isB2cl)) {
      final rates = _byRate(b.lines.map((l) => (l.taxRate, l.taxable, l.tax)));
      for (final MapEntry(key: bp, value: (taxable, tax)) in rates.entries) {
        rows.add([
          b.invoiceNo,
          _date.format(b.billedAt),
          _num(b.grandTotal),
          _pos(b.placeOfSupply),
          _rate(TaxRate(bp)),
          _num(taxable),
          _num(tax),
          '0.00',
        ]);
      }
    }
    return (name: 'B2CL', rows: rows, numericColumns: const {2, 4, 5, 6, 7});
  }

  /// B2C (small) sales summarised by place of supply and rate, net of
  /// credit notes on B2C bills.
  SheetData _b2cs() {
    final groups = <(String, int, bool), (Money, Money)>{};
    void add(Bill b, TaxRate rate, Money taxable, Money tax, {int sign = 1}) {
      final key = (
        b.placeOfSupply ?? input.shop.stateCode,
        rate.bp,
        b.interState,
      );
      final (t, x) = groups[key] ?? (Money.zero, Money.zero);
      groups[key] = sign > 0 ? (t + taxable, x + tax) : (t - taxable, x - tax);
    }

    for (final b in _completed.where((b) => !b.isB2B && !_isB2cl(b))) {
      for (final l in b.lines) {
        add(b, l.taxRate, l.taxable, l.tax);
      }
    }
    for (final cn in input.creditNotes) {
      final b = input.creditNoteBills[cn.billId]!;
      if (b.isB2B) continue;
      for (final l in cn.lines) {
        add(b, l.taxRate, l.taxable, l.tax, sign: -1);
      }
    }
    final rows = <List<String>>[
      [
        'Type',
        'Place Of Supply',
        'Rate',
        'Taxable Value',
        'Integrated Tax',
        'Central Tax',
        'State/UT Tax',
        'Cess Amount',
      ],
    ];
    final keys = groups.keys.toList()
      ..sort(
        (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2),
      );
    for (final k in keys) {
      final (taxable, tax) = groups[k]!;
      if (taxable.isZero && tax.isZero) continue;
      final t = splitTax(tax, interState: k.$3);
      rows.add([
        'OE',
        _pos(k.$1),
        _rate(TaxRate(k.$2)),
        _num(taxable),
        _num(t.igst),
        _num(t.cgst),
        _num(t.sgst),
        '0.00',
      ]);
    }
    return (name: 'B2CS', rows: rows, numericColumns: const {2, 3, 4, 5, 6, 7});
  }

  SheetData _cdnr() {
    final rows = <List<String>>[
      [
        'GSTIN/UIN of Recipient',
        'Receiver Name',
        'Note Number',
        'Note Date',
        'Note Type',
        'Place Of Supply',
        'Reverse Charge',
        'Note Value',
        'Rate',
        'Taxable Value',
        'Integrated Tax',
        'Central Tax',
        'State/UT Tax',
        'Cess Amount',
        'Original Invoice',
      ],
    ];
    for (final cn in input.creditNotes) {
      final b = input.creditNoteBills[cn.billId]!;
      if (!b.isB2B) continue;
      final rates = _byRate(cn.lines.map((l) => (l.taxRate, l.taxable, l.tax)));
      for (final MapEntry(key: bp, value: (taxable, tax)) in rates.entries) {
        final t = splitTax(tax, interState: b.interState);
        rows.add([
          b.buyerGstin!,
          b.customerName ?? '',
          cn.noteNo,
          _date.format(cn.issuedAt),
          'C',
          _pos(b.placeOfSupply),
          'N',
          _num(cn.total),
          _rate(TaxRate(bp)),
          _num(taxable),
          _num(t.igst),
          _num(t.cgst),
          _num(t.sgst),
          '0.00',
          cn.invoiceNo,
        ]);
      }
    }
    return (
      name: 'CDNR',
      rows: rows,
      numericColumns: const {7, 8, 9, 10, 11, 12, 13},
    );
  }

  static const _uqc = {
    'pcs': 'NOS',
    'kg': 'KGS',
    'g': 'GMS',
    'l': 'LTR',
    'ml': 'MLT',
    'm': 'MTR',
    'box': 'BOX',
    'pack': 'PAC',
    'dozen': 'DOZ',
    'pair': 'PRS',
    'bottle': 'BTL',
  };

  /// HSN summary (GSTR-1 table 12), split B2B / B2C as required since
  /// 2025, net of credit notes. Quantities are in each line's selling unit.
  SheetData _hsn({required bool b2b}) {
    final groups =
        <(String, String, int), (Quantity, Money, Money, Money, TaxSplit)>{};
    void add(
      Bill b,
      String? hsn,
      String unit,
      int rateBp,
      Quantity qty,
      Money taxable,
      Money tax,
      Money value, {
      int sign = 1,
    }) {
      final key = (hsn ?? '', _uqc[unit] ?? 'OTH', rateBp);
      final cur =
          groups[key] ??
          (Quantity.zero, Money.zero, Money.zero, Money.zero, _noTax);
      final t = splitTax(tax, interState: b.interState);
      groups[key] = sign > 0
          ? (
              cur.$1 + qty,
              cur.$2 + value,
              cur.$3 + taxable,
              cur.$4 + tax,
              _add(cur.$5, t),
            )
          : (
              cur.$1 - qty,
              cur.$2 - value,
              cur.$3 - taxable,
              cur.$4 - tax,
              (
                igst: cur.$5.igst - t.igst,
                cgst: cur.$5.cgst - t.cgst,
                sgst: cur.$5.sgst - t.sgst,
              ),
            );
    }

    for (final b in _completed.where((b) => b.isB2B == b2b)) {
      for (final l in b.lines) {
        add(
          b,
          l.hsn,
          l.unit,
          l.taxRate.bp,
          l.quantity,
          l.taxable,
          l.tax,
          l.total,
        );
      }
    }
    for (final cn in input.creditNotes) {
      final b = input.creditNoteBills[cn.billId]!;
      if (b.isB2B != b2b) continue;
      for (final l in cn.lines) {
        add(
          b,
          l.hsn,
          l.unit,
          l.taxRate.bp,
          l.quantity,
          l.taxable,
          l.tax,
          l.total,
          sign: -1,
        );
      }
    }
    final rows = <List<String>>[
      [
        'HSN',
        'Description',
        'UQC',
        'Total Quantity',
        'Total Value',
        'Rate',
        'Taxable Value',
        'Integrated Tax Amount',
        'Central Tax Amount',
        'State/UT Tax Amount',
        'Cess Amount',
      ],
    ];
    final keys = groups.keys.toList()
      ..sort(
        (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$3.compareTo(b.$3),
      );
    for (final k in keys) {
      final g = groups[k]!;
      if (g.$1.isZero && g.$3.isZero) continue;
      rows.add([
        k.$1,
        '',
        k.$2,
        g.$1.format(),
        _num(g.$2),
        _rate(TaxRate(k.$3)),
        _num(g.$3),
        _num(g.$5.igst),
        _num(g.$5.cgst),
        _num(g.$5.sgst),
        '0.00',
      ]);
    }
    return (
      name: b2b ? 'HSN B2B' : 'HSN B2C',
      rows: rows,
      numericColumns: const {3, 4, 5, 6, 7, 8, 9, 10},
    );
  }

  SheetData _docs() {
    final rows = <List<String>>[
      [
        'Nature of Document',
        'Sr. No. From',
        'Sr. No. To',
        'Total Number',
        'Cancelled',
      ],
    ];
    if (input.bills.isNotEmpty) {
      rows.add([
        'Invoices for outward supply',
        input.bills.first.invoiceNo,
        input.bills.last.invoiceNo,
        '${input.bills.length}',
        '${input.bills.where((b) => b.isCancelled).length}',
      ]);
    }
    if (input.creditNotes.isNotEmpty) {
      rows.add([
        'Credit Note',
        input.creditNotes.first.noteNo,
        input.creditNotes.last.noteNo,
        '${input.creditNotes.length}',
        '0',
      ]);
    }
    return (name: 'Docs', rows: rows, numericColumns: const {3, 4});
  }

  SheetData _purchases() {
    final rows = <List<String>>[
      [
        'Supplier GSTIN',
        'Supplier',
        'Supplier Invoice',
        'Date',
        'Taxable Value',
        'Integrated Tax',
        'Central Tax',
        'State/UT Tax',
        'Total',
        'ITC eligible',
      ],
    ];
    for (final p in input.purchases.where((p) => !p.isCancelled)) {
      final t = splitTax(p.tax, interState: p.interState);
      rows.add([
        p.supplierGstin ?? '',
        p.supplierName ?? '',
        p.supplierInvoiceNo ?? '',
        _date.format(p.purchasedAt),
        _num(p.taxable),
        _num(t.igst),
        _num(t.cgst),
        _num(t.sgst),
        _num(p.total),
        p.supplierGstin == null ? 'No' : 'Yes',
      ]);
    }
    return (
      name: 'Purchases',
      rows: rows,
      numericColumns: const {4, 5, 6, 7, 8},
    );
  }
}
