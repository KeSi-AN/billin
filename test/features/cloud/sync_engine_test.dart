import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/data/drift_bill_repository.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/cloud/data/sync_engine.dart';
import 'package:shop_app/features/cloud/domain/cloud.dart';
import 'package:shop_app/features/cloud/domain/sync.dart';
import 'package:shop_app/features/customers/data/drift_party_repository.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/inventory/data/drift_inventory_repository.dart';
import 'package:shop_app/features/items/data/drift_item_repository.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

/// The cloud table in memory: latest row per (table, row id), numbered on
/// every write like the server does. Rows go through JSON, like the wire.
class FakeRemote implements SyncRemote {
  final _rows = <String, CloudRow>{};
  var _seq = 0;
  int pushes = 0;

  @override
  Future<void> push(String shopId, String deviceId, List<CloudRow> rows) async {
    pushes++;
    for (final r in rows) {
      _rows['${r.tbl}/${r.rowId}'] = CloudRow(
        tbl: r.tbl,
        rowId: r.rowId,
        data: jsonDecode(jsonEncode(r.data)) as Map<String, Object?>,
        seq: ++_seq,
      );
    }
  }

  /// The rows of one table, as the cloud holds them.
  Iterable<CloudRow> rows(String tbl) =>
      _rows.values.where((r) => r.tbl == tbl);

  @override
  Future<List<CloudRow>> pull(
    String shopId, {
    required int after,
    int limit = 500,
  }) async =>
      (_rows.values.where((r) => r.seq > after).toList()
            ..sort((a, b) => a.seq.compareTo(b.seq)))
          .take(limit)
          .toList();
}

/// One phone: its own database, repositories and sync engine.
class Phone {
  Phone(this.remote, this.series) {
    final dir = Directory.systemTemp;
    shop = DriftShopProfileRepository(db, storageDir: () async => dir);
    items = DriftItemRepository(db);
    stock = DriftInventoryRepository(db);
    parties = DriftPartyRepository(db);
    bills = DriftBillRepository(db, series: () async => series);
    sync = SyncEngine(
      db,
      remote,
      () async => CloudLink(
        shopId: 'shop-1',
        shopName: 'Sadiya Fashion',
        deviceId: 'device-$series',
        series: series,
      ),
      pageSize: 7, // small pages: exercises paging
    );
  }

  final FakeRemote remote;
  final String series;
  final db = AppDatabase(NativeDatabase.memory());
  late final DriftShopProfileRepository shop;
  late final DriftItemRepository items;
  late final DriftInventoryRepository stock;
  late final DriftPartyRepository parties;
  late final DriftBillRepository bills;
  late final SyncEngine sync;

  Future<Item> item(String name) async =>
      (await items.watchAll().first).firstWhere((i) => i.name == name);

  Future<List<Bill>> allBills() =>
      bills.billsBetween(DateTime(2000), DateTime(2100));

  Future<Party> party(String name) async =>
      (await parties.watchAll().first).firstWhere((p) => p.name == name);

  Future<Bill> sell(Item item, {int qty = 1, Party? onCredit}) => bills.create(
    BillDraft(
      lines: [
        DraftLine(
          name: item.name,
          unitPrice: item.salePrice,
          itemId: item.id,
          quantity: Quantity.whole(qty),
        ),
      ],
      paymentMode: onCredit == null ? PaymentMode.cash : PaymentMode.credit,
      partyId: onCredit?.id,
      customerName: onCredit?.name,
    ),
  );
}

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  late FakeRemote cloud;
  late Phone moto;
  late Phone redmi;

  setUp(() async {
    cloud = FakeRemote();
    moto = Phone(cloud, 'A');
    redmi = Phone(cloud, 'B');
    // The moto has been the shop's phone so far.
    await moto.shop.save(
      const ShopProfile(name: 'Sadiya Fashion', stateCode: '37'),
    );
    final saree = await moto.items.save(
      const Item(
        name: 'Shifon Saree',
        salePrice: Money.rupees(565),
        barcode: '38756',
        trackStock: true,
      ),
    );
    await moto.stock.adjustStock(saree.id!, const Quantity.whole(10));
    await moto.sell(saree, qty: 2);
  });

  tearDown(() async {
    await moto.db.close();
    await redmi.db.close();
  });

  test('a new phone gets the shop, items, stock and bills', () async {
    await moto.sync.syncNow();
    expect(moto.sync.status.value.error, isNull);
    expect(moto.sync.status.value.pending, 0);
    await redmi.sync.syncNow();
    expect(redmi.sync.status.value.error, isNull);

    expect((await redmi.shop.load())!.name, 'Sadiya Fashion');
    final saree = await redmi.item('Shifon Saree');
    expect(saree.salePrice, const Money.rupees(565));
    expect(saree.barcode, '38756');
    expect(saree.stock, const Quantity.whole(8));
    final bills = await redmi.allBills();
    expect(bills.single.invoiceNo, 'INV-A/26-27/0001');
    expect(bills.single.lines.single.itemId, saree.id);
  });

  test('both phones selling offline: stock adds up on both', () async {
    await moto.sync.syncNow();
    await redmi.sync.syncNow();
    // Offline: each sells some sarees.
    await moto.sell(await moto.item('Shifon Saree'));
    await redmi.sell(await redmi.item('Shifon Saree'), qty: 3);
    // Back online, in any order.
    await redmi.sync.syncNow();
    await moto.sync.syncNow();
    await redmi.sync.syncNow();
    expect((await moto.item('Shifon Saree')).stock, const Quantity.whole(4));
    expect((await redmi.item('Shifon Saree')).stock, const Quantity.whole(4));
    // Each phone's bills keep their own numbers; both have all three.
    final numbers = {for (final b in await moto.allBills()) b.invoiceNo};
    expect(numbers, {
      'INV-A/26-27/0001',
      'INV-A/26-27/0002',
      'INV-B/26-27/0001',
    });
    expect((await redmi.allBills()).length, 3);
  });

  test('a price change is not undone by the other phone selling', () async {
    await moto.sync.syncNow();
    await redmi.sync.syncNow();
    final onRedmi = await redmi.item('Shifon Saree');
    await redmi.items.save(
      onRedmi.copyWith(salePrice: const Money.rupees(599)),
    );
    // The moto sells (its stock total changes) before hearing of it.
    await moto.sell(await moto.item('Shifon Saree'));
    await redmi.sync.syncNow();
    await moto.sync.syncNow();
    await redmi.sync.syncNow();
    expect(
      (await moto.item('Shifon Saree')).salePrice,
      const Money.rupees(599),
    );
    expect(
      (await redmi.item('Shifon Saree')).salePrice,
      const Money.rupees(599),
    );
  });

  test('credit sales on either phone add up the customer dues', () async {
    final ravi = await moto.parties.save(const Party(name: 'Ravi'));
    await moto.sell(await moto.item('Shifon Saree'), onCredit: ravi);
    await moto.sync.syncNow();
    await redmi.sync.syncNow();
    final raviHere = await redmi.party('Ravi');
    expect(raviHere.balance, const Money.rupees(565));
    await redmi.sell(await redmi.item('Shifon Saree'), onCredit: raviHere);
    await redmi.sync.syncNow();
    await moto.sync.syncNow();
    expect((await moto.party('Ravi')).balance, const Money.rupees(1130));
    expect((await redmi.party('Ravi')).balance, const Money.rupees(1130));
  });

  test('nothing to send twice; syncing again is quiet and harmless', () async {
    await moto.sync.syncNow();
    final pushes = cloud.pushes;
    await moto.sync.syncNow();
    await moto.sync.syncNow();
    expect(cloud.pushes, pushes);
    expect((await moto.item('Shifon Saree')).stock, const Quantity.whole(8));
  });

  test(
    'sizes, their stock and the website details reach the other phone',
    () async {
      final kurti = await moto.items.save(
        const Item(
          name: 'Kurti set',
          salePrice: Money.rupees(1835),
          trackStock: true,
          colours: [ItemColour('Plum', '#6b3f6e')],
          fabric: 'Rayon',
          care: 'Hand wash',
          description: 'Straight kurti',
          showOnWebsite: true,
        ),
      );
      final sizes = {
        for (final s in await moto.items.saveSizes(kurti.id!, const [
          ItemSize(size: 'M'),
          ItemSize(
            size: 'L',
            price: Money.rupees(1935),
            barcode: '2510000000013',
          ),
        ]))
          s.size: s,
      };
      await moto.stock.addStock(
        kurti.id!,
        const Quantity.whole(3),
        opening: true,
        sizeId: sizes['M']!.id,
      );
      await moto.stock.addStock(
        kurti.id!,
        const Quantity.whole(2),
        opening: true,
        sizeId: sizes['L']!.id,
      );
      await moto.sync.syncNow();
      await redmi.sync.syncNow();

      final here = await redmi.item('Kurti set');
      expect(
        (here.fabric, here.care, here.showOnWebsite),
        ('Rayon', 'Hand wash', true),
      );
      expect(here.colours, const [ItemColour('Plum', '#6b3f6e')]);
      Future<Map<String, int>> stockOn(Phone p, int id) async => {
        for (final s in await p.items.sizesOf(id))
          s.size: s.stock.milli ~/ 1000,
      };
      expect(await stockOn(redmi, here.id!), {'M': 3, 'L': 2});

      // The Redmi sells an L; the moto hears of it.
      final lOnRedmi = (await redmi.items.sizesOf(here.id!))
          .firstWhere((s) => s.size == 'L');
      await redmi.bills.create(
        BillDraft(
          lines: [
            DraftLine(
              itemId: here.id,
              sizeId: lOnRedmi.id,
              size: 'L',
              name: 'Kurti set (L)',
              unitPrice: lOnRedmi.priceOf(here),
            ),
          ],
        ),
      );
      await redmi.sync.syncNow();
      await moto.sync.syncNow();
      expect(await stockOn(moto, kurti.id!), {'M': 3, 'L': 1});
      expect((await moto.item('Kurti set')).stock, const Quantity.whole(4));

      // What the website reads from the cloud (see the reply to it).
      final row = cloud
          .rows('items')
          .firstWhere((r) => r.data['name'] == 'Kurti set');
      expect(row.data['colours'], '[{"name":"Plum","hex":"#6b3f6e"}]');
      expect(row.data['show_on_website'], 1);
      expect(row.data['fabric'], 'Rayon');
      final size = cloud
          .rows('item_sizes')
          .firstWhere((r) => r.data['size'] == 'L');
      expect(size.data['item_id'], row.rowId);
      expect(size.data['sale_price_paise'], 193500);
      expect(size.data['barcode'], '2510000000013');
      expect(size.data['is_active'], 1);
      expect(size.data.containsKey('stock_milli'), isFalse);
      final moves = cloud
          .rows('stock_movements')
          .where((r) => r.data['size_id'] == size.rowId);
      expect(
        moves.fold<int>(0, (t, r) => t + (r.data['quantity_milli']! as int)),
        1000,
      );
    },
  );
}
