import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/app/flavor.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/billing/presentation/bill_actions.dart';
import 'package:shop_app/features/customers/domain/contact_picker.dart';
import 'package:shop_app/features/customers/domain/customer_actions.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/inventory/domain/stock_alerts.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';

// In-memory stand-ins for the Drift repositories. Widget tests use these
// because Drift's stream timers don't mix with the test clock; the Drift
// implementations have their own tests against a real in-memory SQLite.

class FakeShopProfiles implements ShopProfileRepository {
  FakeShopProfiles([this._profile]);

  ShopProfile? _profile;
  final _changes = StreamController<ShopProfile?>.broadcast();

  ShopProfile? get current => _profile;

  @override
  Stream<ShopProfile?> watch() async* {
    yield _profile;
    yield* _changes.stream;
  }

  @override
  Future<ShopProfile?> load() async => _profile;

  @override
  Future<void> save(ShopProfile profile) async {
    _profile = profile;
    _changes.add(profile);
  }

  @override
  Future<String> importLogo(String sourcePath) async => sourcePath;
}

class FakeItems implements ItemRepository {
  final _items = <Item>[];
  final _changes = StreamController<void>.broadcast();
  var _nextId = 1;

  List<Item> get all => List.unmodifiable(_items);

  bool _match(Item i, String q) {
    final query = q.trim().toLowerCase();
    return i.name.toLowerCase().contains(query) ||
        (i.barcode?.startsWith(query) ?? false);
  }

  List<Item> _sorted(Iterable<Item> items) =>
      items.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  Stream<List<Item>> watchAll({ItemFilter filter = const ItemFilter()}) async* {
    List<Item> current() {
      var list = _sorted(
        _items.where(
          (i) =>
              (filter.query.isEmpty || _match(i, filter.query)) &&
              (filter.categoryId == null ||
                  i.categoryId == filter.categoryId) &&
              switch (filter.stock) {
                StockFilter.all => true,
                StockFilter.low => i.isLowStock,
                StockFilter.out => i.isOutOfStock,
              },
        ),
      );
      if (filter.sort == ItemSort.stockLowFirst) {
        list = list..sort((a, b) => a.stock.milli.compareTo(b.stock.milli));
      }
      return list;
    }

    yield current();
    yield* _changes.stream.map((_) => current());
  }

  /// Test helper: what the stock ledger would do.
  void setStock(int id, Quantity stock) {
    final i = _items.indexWhere((x) => x.id == id);
    _items[i] = _items[i].copyWith(stock: stock);
    _changes.add(null);
  }

  @override
  Future<String> importImage(String sourcePath) async => sourcePath;

  @override
  Future<Item?> byId(int id) async =>
      _items.where((i) => i.id == id).firstOrNull;

  @override
  Future<Item?> byBarcode(String barcode) async =>
      _items.where((i) => i.barcode == barcode.trim()).firstOrNull;

  @override
  Future<List<Item>> search(String query, {int limit = 20}) async =>
      query.trim().isEmpty
      ? []
      : _sorted(_items.where((i) => _match(i, query))).take(limit).toList();

  @override
  Future<Item> save(Item item) async {
    final barcode = (item.barcode?.trim().isEmpty ?? true)
        ? null
        : item.barcode!.trim();
    final clash = _items
        .where(
          (i) => barcode != null && i.barcode == barcode && i.id != item.id,
        )
        .firstOrNull;
    if (clash != null) throw DuplicateBarcodeException(barcode!, clash.name);
    // Like the real repository, saving never changes stock.
    final existingStock =
        _items.where((i) => i.id == item.id).firstOrNull?.stock ??
        Quantity.zero;
    final saved = item.copyWith(
      id: item.id ?? _nextId++,
      barcode: barcode,
      stock: existingStock,
    );
    _items
      ..removeWhere((i) => i.id == saved.id)
      ..add(saved);
    _changes.add(null);
    return saved;
  }

  @override
  Future<void> delete(int id) async {
    _items.removeWhere((i) => i.id == id);
    _changes.add(null);
  }
}

class FakeSettings implements SettingsRepository {
  FakeSettings([this._settings = const AppSettingsData()]);

  AppSettingsData _settings;
  final _changes = StreamController<AppSettingsData>.broadcast();

  AppSettingsData get current => _settings;

  @override
  Stream<AppSettingsData> watch() async* {
    yield _settings;
    yield* _changes.stream;
  }

  @override
  Future<AppSettingsData> load() async => _settings;

  @override
  Future<void> save(AppSettingsData settings) async {
    _settings = settings;
    _changes.add(settings);
  }
}

class FakeBills implements BillRepository {
  FakeBills(this._settings, {this.clock = _now, this.items, this.parties});

  /// When set, credit sales go on the customer's account.
  final FakeParties? parties;

  /// When set, sales take tracked items' stock down like the real ledger.
  final FakeItems? items;

  static DateTime _now() => DateTime(2026, 11, 12, 10, 30);

  final FakeSettings _settings;
  DateTime Function() clock;
  final _bills = <Bill>[];
  var _nextLineId = 1;
  final _changes = StreamController<void>.broadcast();

  List<Bill> get all => List.unmodifiable(_bills);

  @override
  Future<Bill> create(BillDraft draft) async {
    final s = await _settings.load();
    final totals = BillCalculator.calculate(
      [for (final l in draft.lines) l.input],
      billDiscount: draft.billDiscount,
      roundToRupee: s.roundToRupee,
    );
    if (draft.paymentMode == PaymentMode.credit && draft.partyId == null) {
      throw ArgumentError('A credit sale needs a customer');
    }
    final now = clock();
    final paidNow = draft.paidNow > totals.grandTotal
        ? totals.grandTotal
        : draft.paidNow;
    final due = draft.paymentMode == PaymentMode.credit
        ? totals.grandTotal - paidNow
        : Money.zero;
    final bill = Bill(
      id: _bills.length + 1,
      partyId: draft.partyId,
      due: due,
      invoiceNo: InvoiceNumber.format(
        prefix: s.invoicePrefix,
        year: FinancialYear.of(now),
        sequence: _bills.length + 1,
      ),
      billedAt: now,
      customerName: (draft.customerName?.trim().isEmpty ?? true)
          ? null
          : draft.customerName!.trim(),
      customerPhone: draft.customerPhone,
      paymentMode: draft.paymentMode,
      itemsTotal: totals.itemsTotal,
      billDiscount: totals.billDiscount,
      taxable: totals.taxable,
      tax: totals.tax,
      roundOff: totals.roundOff,
      grandTotal: totals.grandTotal,
      lines: [
        for (var i = 0; i < draft.lines.length; i++)
          BillLine(
            id: _nextLineId++,
            itemId: draft.lines[i].itemId,
            name: draft.lines[i].name,
            unit: draft.lines[i].unit,
            quantity: draft.lines[i].quantity,
            unitPrice: draft.lines[i].unitPrice,
            taxRate: draft.lines[i].taxRate,
            priceIncludesTax: draft.lines[i].priceIncludesTax,
            discount: totals.lines[i].discount,
            billDiscountShare: totals.lines[i].billDiscountShare,
            taxable: totals.lines[i].taxable,
            tax: totals.lines[i].tax,
            total: totals.lines[i].total,
            unitFactor: draft.lines[i].unitFactor,
          ),
      ],
    );
    _bills.add(bill);
    if (due.isPositive) {
      parties?.post(
        draft.partyId!,
        due,
        EntryType.sale,
        billId: bill.id,
        invoiceNo: bill.invoiceNo,
      );
    }
    for (final line in draft.lines) {
      final item = line.itemId == null ? null : await items?.byId(line.itemId!);
      if (item != null && item.trackStock) {
        items!.setStock(item.id!, item.stock - line.baseQuantity);
      }
    }
    _changes.add(null);
    return bill;
  }

  @override
  Future<Bill?> byId(int id) async =>
      _bills.where((b) => b.id == id).firstOrNull;

  @override
  Future<List<Bill>> billsBetween(DateTime from, DateTime to) async => [
    for (final b in _bills)
      if (!b.billedAt.isBefore(from) && b.billedAt.isBefore(to)) b,
  ];

  @override
  Stream<List<BillSummary>> watchBetween(DateTime from, DateTime to) async* {
    List<BillSummary> current() => [
      for (final b in _bills.reversed)
        if (!b.billedAt.isBefore(from) && b.billedAt.isBefore(to))
          BillSummary(
            id: b.id,
            invoiceNo: b.invoiceNo,
            billedAt: b.billedAt,
            grandTotal: b.grandTotal,
            paymentMode: b.paymentMode,
            status: b.status,
            lineCount: b.lines.length,
            customerName: b.customerName,
            due: b.due,
          ),
    ];
    yield current();
    yield* _changes.stream.map((_) => current());
  }

  @override
  Future<void> cancel(int id, {String? reason}) async {
    final i = _bills.indexWhere((b) => b.id == id);
    final b = _bills[i];
    _bills[i] = Bill(
      id: b.id,
      invoiceNo: b.invoiceNo,
      billedAt: b.billedAt,
      lines: b.lines,
      itemsTotal: b.itemsTotal,
      billDiscount: b.billDiscount,
      taxable: b.taxable,
      tax: b.tax,
      roundOff: b.roundOff,
      grandTotal: b.grandTotal,
      paymentMode: b.paymentMode,
      customerName: b.customerName,
      customerPhone: b.customerPhone,
      status: BillStatus.cancelled,
      cancelledAt: clock(),
      cancelReason: reason,
      partyId: b.partyId,
      due: b.due,
    );
    if (b.due.isPositive && b.status == BillStatus.completed) {
      parties?.post(
        b.partyId!,
        -b.due,
        EntryType.cancel,
        billId: b.id,
        invoiceNo: b.invoiceNo,
      );
    }
    _changes.add(null);
  }
}

class FakeBillActions implements BillActions {
  final printed = <Bill>[];
  final shared = <Bill>[];

  @override
  Future<void> print(BuildContext context, Bill bill) async =>
      printed.add(bill);

  @override
  Future<void> share(BuildContext context, Bill bill) async => shared.add(bill);
}

class FakePrinterTransport implements PrinterTransport {
  FakePrinterTransport({
    this.permission = true,
    this.bluetooth = BluetoothState.on,
    this.devices = const [],
    this.failWrites = 0,
  });

  bool permission;
  BluetoothState bluetooth;
  List<PrinterDevice> devices;

  /// How many writes fail before one succeeds.
  int failWrites;
  final written = <Uint8List>[];
  final log = <String>[];

  @override
  Future<bool> ensurePermission() async => permission;

  @override
  Future<BluetoothState> state() async => bluetooth;

  @override
  Future<List<PrinterDevice>> bondedDevices() async => devices;

  @override
  Future<void> connect(String address) async => log.add('connect $address');

  @override
  Future<void> write(Uint8List bytes) async {
    if (failWrites > 0) {
      failWrites--;
      log.add('write failed');
      throw PlatformException(code: 'PRINTER', message: 'broken pipe');
    }
    log.add('write ${bytes.length}');
    written.add(bytes);
  }

  @override
  Future<void> disconnect() async => log.add('disconnect');

  @override
  Future<void> openBluetoothSettings() async => log.add('open settings');
}

class FakeInventory implements InventoryRepository {
  FakeInventory(this._items);

  final FakeItems _items;
  final categories = <Category>[];
  final movements = <StockMovement>[];
  final _changes = StreamController<void>.broadcast();

  Stream<T> _watch<T>(T Function() current) async* {
    yield current();
    yield* _changes.stream.map((_) => current());
  }

  @override
  Stream<List<Category>> watchCategories() => _watch(() => [...categories]);

  @override
  Future<Category> addCategory(String name, {int? parentId}) async {
    final existing = categories
        .where(
          (c) =>
              c.name.toLowerCase() == name.trim().toLowerCase() &&
              c.parentId == parentId,
        )
        .firstOrNull;
    if (existing != null) return existing;
    final c = Category(
      id: categories.length + 1,
      name: name.trim(),
      parentId: parentId,
    );
    categories.add(c);
    _changes.add(null);
    return c;
  }

  Future<void> _post(
    int itemId,
    Quantity delta,
    MovementType type,
    String? note,
  ) async {
    final item = (await _items.byId(itemId))!;
    final balance = item.stock + delta;
    _items.setStock(itemId, balance);
    movements.insert(
      0,
      StockMovement(
        id: movements.length + 1,
        itemId: itemId,
        quantity: delta,
        type: type,
        balanceAfter: balance,
        at: DateTime(2026, 11, 12, 10),
        note: note,
      ),
    );
    _changes.add(null);
  }

  @override
  Future<void> addStock(
    int itemId,
    Quantity quantity, {
    String? batchNo,
    DateTime? expiry,
    String? note,
    bool opening = false,
  }) => _post(
    itemId,
    quantity,
    opening ? MovementType.opening : MovementType.stockIn,
    note,
  );

  @override
  Future<void> adjustStock(
    int itemId,
    Quantity actual, {
    int? batchId,
    String? note,
  }) async {
    final item = (await _items.byId(itemId))!;
    await _post(itemId, actual - item.stock, MovementType.adjust, note);
  }

  @override
  Stream<List<StockMovement>> watchMovements(int itemId, {int limit = 100}) =>
      _watch(() => movements.where((m) => m.itemId == itemId).toList());

  @override
  Stream<List<StockBatch>> watchBatches(int itemId) => _watch(() => []);

  @override
  Stream<List<Item>> watchLowStock() =>
      _items.watchAll(filter: const ItemFilter(stock: StockFilter.low));

  @override
  Stream<List<ExpiringBatch>> watchExpiring({required DateTime before}) =>
      _watch(() => []);
}

class FakeStockAlerts implements StockAlerts {
  final alerted = <List<Item>>[];

  @override
  Future<void> lowStock(List<Item> items) async => alerted.add(items);
}

class FakeParties implements PartyRepository {
  final _parties = <Party>[];
  final entries = <PartyEntry>[];
  final _changes = StreamController<void>.broadcast();

  List<Party> get all => List.unmodifiable(_parties);

  Stream<T> _watch<T>(T Function() current) async* {
    yield current();
    yield* _changes.stream.map((_) => current());
  }

  /// What the real party ledger does.
  void post(
    int partyId,
    Money amount,
    EntryType type, {
    int? billId,
    String? invoiceNo,
    PaymentMode? mode,
    String? note,
  }) {
    final i = _parties.indexWhere((p) => p.id == partyId);
    final balance = _parties[i].balance + amount;
    _parties[i] = _parties[i].copyWith(balance: balance);
    entries.insert(
      0,
      PartyEntry(
        id: entries.length + 1,
        partyId: partyId,
        type: type,
        amount: amount,
        balanceAfter: balance,
        at: DateTime(2026, 11, 12, 10),
        billId: billId,
        invoiceNo: invoiceNo,
        paymentMode: mode,
        note: note,
      ),
    );
    _changes.add(null);
  }

  @override
  Stream<List<Party>> watchAll({PartyFilter filter = const PartyFilter()}) =>
      _watch(() {
        final q = filter.query.trim().toLowerCase();
        final list =
            _parties
                .where(
                  (p) =>
                      (q.isEmpty ||
                          p.name.toLowerCase().contains(q) ||
                          (p.phone ?? '').contains(q)) &&
                      (!filter.onlyWithDues || p.hasDue) &&
                      p.type == filter.type,
                )
                .toList()
              ..sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
              );
        return list;
      });

  @override
  Stream<Money> watchTotalDue({PartyType type = PartyType.customer}) => _watch(
    () => _parties
        .where((p) => p.hasDue && p.type == type)
        .fold(Money.zero, (s, p) => s + p.balance),
  );

  @override
  Future<Party?> byId(int id) async =>
      _parties.where((p) => p.id == id).firstOrNull;

  @override
  Stream<Party?> watch(int id) =>
      _watch(() => _parties.where((p) => p.id == id).firstOrNull);

  @override
  Future<Party> save(Party party, {Money openingDue = Money.zero}) async {
    final phone = (party.phone?.trim().isEmpty ?? true)
        ? null
        : party.phone!.trim();
    final clash = _parties
        .where((p) => phone != null && p.phone == phone && p.id != party.id)
        .firstOrNull;
    if (clash != null) throw DuplicatePhoneException(clash.name);
    final existing = _parties.where((p) => p.id == party.id).firstOrNull;
    final saved = party.copyWith(
      id: party.id ?? _parties.length + 1,
      name: party.name.trim(),
      phone: phone,
      balance: existing?.balance ?? Money.zero,
    );
    _parties
      ..removeWhere((p) => p.id == saved.id)
      ..add(saved);
    if (existing == null && !openingDue.isZero) {
      post(saved.id!, openingDue, EntryType.opening);
    } else {
      _changes.add(null);
    }
    return (await byId(saved.id!))!;
  }

  @override
  Future<void> delete(int id) async {
    final p = (await byId(id))!;
    if (!p.balance.isZero) throw PartyHasBalanceException(p.balance);
    _parties.removeWhere((x) => x.id == id);
    _changes.add(null);
  }

  @override
  Stream<List<PartyEntry>> watchEntries(int partyId) =>
      _watch(() => entries.where((e) => e.partyId == partyId).toList());

  @override
  Future<List<PartyEntry>> entriesBetween(
    int partyId,
    DateTime from,
    DateTime to,
  ) async =>
      entries.where((e) => e.partyId == partyId).toList().reversed.toList();

  @override
  Future<void> receivePayment(
    int partyId,
    Money amount, {
    PaymentMode mode = PaymentMode.cash,
    String? note,
  }) async => post(partyId, -amount, EntryType.payment, mode: mode, note: note);
}

class FakeCustomerActions implements CustomerActions {
  final reminded = <Party>[];
  final statements = <Party>[];

  @override
  Future<void> remind(BuildContext context, Party party) async =>
      reminded.add(party);

  @override
  Future<void> shareStatement(BuildContext context, Party party) async =>
      statements.add(party);
}

class FakeContactPicker implements ContactPicker {
  PickedContact? next;

  @override
  Future<PickedContact?> pick() async => next;
}

class FakePurchases implements PurchaseRepository {
  FakePurchases({required this.items, required this.parties});

  final FakeItems items;
  final FakeParties parties;
  DateTime Function() clock = () => DateTime(2026, 11, 12, 11);
  final _purchases = <Purchase>[];
  final _changes = StreamController<void>.broadcast();

  List<Purchase> get all => List.unmodifiable(_purchases);

  @override
  Future<Purchase> create(PurchaseDraft draft) async {
    if (draft.paymentMode == PaymentMode.credit && draft.partyId == null) {
      throw const SupplierRequiredException();
    }
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
        : await parties.byId(draft.partyId!);
    final due = draft.paymentMode == PaymentMode.credit
        ? totals.grandTotal - draft.paidNow
        : Money.zero;
    final p = Purchase(
      id: _purchases.length + 1,
      partyId: draft.partyId,
      supplierName: supplier?.name,
      supplierGstin: supplier?.gstin,
      supplierInvoiceNo: (draft.supplierInvoiceNo?.trim().isEmpty ?? true)
          ? null
          : draft.supplierInvoiceNo!.trim(),
      purchasedAt: draft.purchasedAt ?? clock(),
      lines: [
        for (var i = 0; i < draft.lines.length; i++)
          PurchaseLine(
            itemId: draft.lines[i].itemId,
            name: draft.lines[i].name,
            unit: draft.lines[i].unit,
            hsn: draft.lines[i].hsn,
            quantity: draft.lines[i].quantity,
            unitCost: draft.lines[i].unitCost,
            costIncludesTax: draft.lines[i].costIncludesTax,
            taxRate: draft.lines[i].taxRate,
            taxable: totals.lines[i].taxable,
            tax: totals.lines[i].tax,
            total: totals.lines[i].total,
            batchNo: draft.lines[i].batchNo,
            expiry: draft.lines[i].expiry,
          ),
      ],
      taxable: totals.taxable,
      tax: totals.tax,
      total: totals.grandTotal,
      due: due.isPositive ? due : Money.zero,
      paymentMode: draft.paymentMode,
    );
    _purchases.add(p);
    for (final l in draft.lines) {
      final item = l.itemId == null ? null : await items.byId(l.itemId!);
      if (item != null) items.setStock(item.id!, item.stock + l.quantity);
    }
    if (p.due.isPositive) {
      parties.post(p.partyId!, p.due, EntryType.purchase);
    }
    _changes.add(null);
    return p;
  }

  @override
  Future<Purchase?> byId(int id) async =>
      _purchases.where((p) => p.id == id).firstOrNull;

  @override
  Stream<List<Purchase>> watchBetween(DateTime from, DateTime to) async* {
    List<Purchase> current() => [
      for (final p in _purchases.reversed)
        if (!p.purchasedAt.isBefore(from) && p.purchasedAt.isBefore(to)) p,
    ];
    yield current();
    yield* _changes.stream.map((_) => current());
  }

  @override
  Future<void> cancel(int id) async {
    final i = _purchases.indexWhere((p) => p.id == id);
    final p = _purchases[i];
    _purchases[i] = Purchase(
      id: p.id,
      partyId: p.partyId,
      supplierName: p.supplierName,
      supplierGstin: p.supplierGstin,
      supplierInvoiceNo: p.supplierInvoiceNo,
      purchasedAt: p.purchasedAt,
      lines: p.lines,
      taxable: p.taxable,
      tax: p.tax,
      total: p.total,
      due: p.due,
      paymentMode: p.paymentMode,
      isCancelled: true,
    );
    for (final l in p.lines) {
      final item = l.itemId == null ? null : await items.byId(l.itemId!);
      if (item != null) items.setStock(item.id!, item.stock - l.quantity);
    }
    if (p.due.isPositive) parties.post(p.partyId!, -p.due, EntryType.cancel);
    _changes.add(null);
  }
}

class FakeReturns implements ReturnsRepository {
  FakeReturns(this.bills);

  final FakeBills bills;
  final notes = <CreditNote>[];

  @override
  Future<CreditNote> returnItems(
    int billId,
    List<ReturnLine> lines, {
    PaymentMode refundMode = PaymentMode.cash,
    String? reason,
  }) async {
    final bill = (await bills.byId(billId))!;
    Money part(Money m, Quantity q, Quantity of) =>
        Money.paise(divRound(m.paise * q.milli, of.milli));
    final out = <CreditNoteLine>[];
    for (final r in lines) {
      final l = bill.lines.firstWhere((x) => x.id == r.billLineId);
      if (r.quantity > l.returnable) throw ReturnTooLargeException(l.name);
      out.add(
        CreditNoteLine(
          billLineId: r.billLineId,
          name: l.name,
          unit: l.unit,
          hsn: l.hsn,
          quantity: r.quantity,
          taxRate: l.taxRate,
          taxable: part(l.taxable, r.quantity, l.quantity),
          tax: part(l.tax, r.quantity, l.quantity),
          total: part(l.total, r.quantity, l.quantity),
        ),
      );
    }
    final note = CreditNote(
      id: notes.length + 1,
      noteNo: 'CN/26-27/${(notes.length + 1).toString().padLeft(4, '0')}',
      billId: billId,
      invoiceNo: bill.invoiceNo,
      issuedAt: bills.clock(),
      lines: out,
      taxable: out.fold(Money.zero, (s, l) => s + l.taxable),
      tax: out.fold(Money.zero, (s, l) => s + l.tax),
      total: out.fold(Money.zero, (s, l) => s + l.total),
      refundMode: refundMode,
      reason: (reason?.trim().isEmpty ?? true) ? null : reason!.trim(),
    );
    notes.add(note);
    return note;
  }

  @override
  Future<List<CreditNote>> forBill(int billId) async => [
    for (final n in notes)
      if (n.billId == billId) n,
  ];

  @override
  Future<List<CreditNote>> between(DateTime from, DateTime to) async => [
    for (final n in notes)
      if (!n.issuedAt.isBefore(from) && n.issuedAt.isBefore(to)) n,
  ];
}

class FakeExpenses implements ExpenseRepository {
  final _expenses = <Expense>[];
  final _changes = StreamController<void>.broadcast();

  List<Expense> get all => List.unmodifiable(_expenses);

  @override
  Future<Expense> add(Expense e) async {
    final saved = Expense(
      id: _expenses.length + 1,
      spentAt: e.spentAt,
      category: e.category.trim(),
      amount: e.amount,
      paymentMode: e.paymentMode,
      note: (e.note?.trim().isEmpty ?? true) ? null : e.note!.trim(),
    );
    _expenses.add(saved);
    _changes.add(null);
    return saved;
  }

  @override
  Future<void> delete(int id) async {
    _expenses.removeWhere((e) => e.id == id);
    _changes.add(null);
  }

  @override
  Stream<List<Expense>> watchBetween(DateTime from, DateTime to) async* {
    List<Expense> current() => [
      for (final e in _expenses.reversed)
        if (!e.spentAt.isBefore(from) && e.spentAt.isBefore(to)) e,
    ];
    yield current();
    yield* _changes.stream.map((_) => current());
  }
}

/// Everything wired with fakes, plus handles to inspect them.
class TestHarness {
  TestHarness({
    ShopProfile? shop,
    AppSettingsData settings = const AppSettingsData(),
  }) : shopProfiles = FakeShopProfiles(shop),
       settings = FakeSettings(settings) {
    bills = FakeBills(this.settings, items: items, parties: parties);
    inventory = FakeInventory(items);
    printer = PrinterService(transport, this.settings);
    purchases = FakePurchases(items: items, parties: parties);
    returns = FakeReturns(bills);
  }

  final FakeShopProfiles shopProfiles;
  final FakeSettings settings;
  final items = FakeItems();
  late final FakeBills bills;
  late final FakeInventory inventory;
  final alerts = FakeStockAlerts();
  final parties = FakeParties();
  final customerActions = FakeCustomerActions();
  final contacts = FakeContactPicker();
  final actions = FakeBillActions();
  final transport = FakePrinterTransport();
  late final PrinterService printer;
  late final FakePurchases purchases;
  late final FakeReturns returns;
  final expenses = FakeExpenses();

  AppServices get services => AppServices(
    shopProfiles: shopProfiles,
    items: items,
    bills: bills,
    settings: settings,
    billActions: actions,
    printer: printer,
    inventory: inventory,
    stockAlerts: alerts,
    parties: parties,
    customerActions: customerActions,
    contactPicker: contacts,
    purchases: purchases,
    returns: returns,
    expenses: expenses,
  );

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ShopApp(services: services, flavor: Flavor.prod));
    await tester.pumpAndSettle();
  }
}

const testShop = ShopProfile(
  name: 'Sharma Kirana',
  stateCode: '27',
  city: 'Pune',
  phone: '9876543210',
  gstin: '27AAPFU0939F1ZV',
);
