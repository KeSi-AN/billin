import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/features/inventory/domain/inventory.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// How far ahead "expiring soon" looks.
const expiryWindow = Duration(days: 30);

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Low stock, expiring soon and expired stock, in one place.
class StockOverviewPage extends StatelessWidget {
  const StockOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventory = context.read<InventoryRepository>();
    final today = _today();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.stockOverviewTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabLowStock),
              Tab(text: l10n.tabExpiring),
              Tab(text: l10n.tabExpired),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<Item>>(
              stream: inventory.watchLowStock(),
              builder: (context, snapshot) => _list(
                context,
                snapshot.data,
                l10n.emptyLowStock,
                (item) => ListTile(
                  title: Text(item.name),
                  subtitle: item.lowStock == null
                      ? null
                      : Text(l10n.stockLowLevel(item.lowStock!.format())),
                  trailing: Text(
                    '${item.stock.format()} ${item.unit}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => context.push(AppRoutes.itemStock(item.id!)),
                ),
              ),
            ),
            StreamBuilder<List<ExpiringBatch>>(
              stream: inventory.watchExpiring(before: today.add(expiryWindow)),
              builder: (context, snapshot) => _list(
                context,
                snapshot.data
                    ?.where((e) => !e.batch.isExpiredOn(today))
                    .toList(),
                l10n.emptyExpiring,
                (e) => _batchTile(context, e, expired: false),
              ),
            ),
            StreamBuilder<List<ExpiringBatch>>(
              stream: inventory.watchExpiring(before: today),
              builder: (context, snapshot) => _list(
                context,
                snapshot.data,
                l10n.emptyExpired,
                (e) => _batchTile(context, e, expired: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _batchTile(
    BuildContext context,
    ExpiringBatch e, {
    required bool expired,
  }) {
    final l10n = AppLocalizations.of(context);
    final date = formatDate(e.batch.expiry!);
    return ListTile(
      title: Text(e.item.name),
      subtitle: Text(
        '${l10n.batchLine(e.batch.batchNo, e.batch.quantity.format(), e.item.unit)}\n'
        '${expired ? l10n.expiredOn(date) : l10n.expiresOn(date)}',
      ),
      isThreeLine: true,
      onTap: () => context.push(AppRoutes.itemStock(e.item.id!)),
    );
  }

  Widget _list<T>(
    BuildContext context,
    List<T>? rows,
    String empty,
    Widget Function(T) tile,
  ) {
    if (rows == null) return const Center(child: CircularProgressIndicator());
    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(empty, textAlign: TextAlign.center),
        ),
      );
    }
    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) => tile(rows[i]),
    );
  }
}

/// Count of things needing attention, for the Home tile.
Stream<int> stockAlertCount(InventoryRepository inventory) async* {
  final today = _today();
  var low = 0;
  var expiring = 0;
  final lowStream = inventory.watchLowStock().map((l) => l.length);
  final expStream = inventory
      .watchExpiring(before: today.add(expiryWindow))
      .map((l) => l.length);
  // Combine the two streams by hand (no rxdart dependency).
  final controller = StreamController<int>();
  final subs = [
    lowStream.listen((v) {
      low = v;
      controller.add(low + expiring);
    }),
    expStream.listen((v) {
      expiring = v;
      controller.add(low + expiring);
    }),
  ];
  controller.onCancel = () async {
    for (final s in subs) {
      await s.cancel();
    }
  };
  yield* controller.stream;
}
