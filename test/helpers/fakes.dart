import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/app/flavor.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/billing/presentation/bill_actions.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/data/printer_transport.dart';
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
  Stream<List<Item>> watchAll({String query = ''}) async* {
    List<Item> current() =>
        _sorted(query.isEmpty ? _items : _items.where((i) => _match(i, query)));
    yield current();
    yield* _changes.stream.map((_) => current());
  }

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
    final saved = item.copyWith(id: item.id ?? _nextId++, barcode: barcode);
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
  FakeBills(this._settings, {this.clock = _now});

  static DateTime _now() => DateTime(2026, 11, 12, 10, 30);

  final FakeSettings _settings;
  DateTime Function() clock;
  final _bills = <Bill>[];
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
    final now = clock();
    final bill = Bill(
      id: _bills.length + 1,
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
          ),
      ],
    );
    _bills.add(bill);
    _changes.add(null);
    return bill;
  }

  @override
  Future<Bill?> byId(int id) async =>
      _bills.where((b) => b.id == id).firstOrNull;

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
    );
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

/// Everything wired with fakes, plus handles to inspect them.
class TestHarness {
  TestHarness({
    ShopProfile? shop,
    AppSettingsData settings = const AppSettingsData(),
  }) : shopProfiles = FakeShopProfiles(shop),
       settings = FakeSettings(settings) {
    bills = FakeBills(this.settings);
    printer = PrinterService(transport, this.settings);
  }

  final FakeShopProfiles shopProfiles;
  final FakeSettings settings;
  final items = FakeItems();
  late final FakeBills bills;
  final actions = FakeBillActions();
  final transport = FakePrinterTransport();
  late final PrinterService printer;

  AppServices get services => AppServices(
    shopProfiles: shopProfiles,
    items: items,
    bills: bills,
    settings: settings,
    billActions: actions,
    printer: printer,
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
