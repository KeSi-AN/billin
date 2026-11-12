import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shop_app/features/inventory/domain/stock_alerts.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Low-stock alerts as Android notifications.
///
/// Notification permission (Android 13+) is asked the first time an alert
/// is due, not at app start, so the request makes sense to the shopkeeper.
class NotificationStockAlerts implements StockAlerts {
  NotificationStockAlerts({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  bool _permissionAsked = false;

  static const _channelId = 'low_stock';
  static const _summaryId = 1;

  AppLocalizations get _l10n => lookupAppLocalizations(const Locale('en'));

  Future<void> _init() async {
    if (_ready) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  @override
  Future<void> lowStock(List<Item> items) async {
    if (items.isEmpty) return;
    try {
      await _init();
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (!_permissionAsked) {
        _permissionAsked = true;
        await android?.requestNotificationsPermission();
      }
      final l10n = _l10n;
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l10n.lowStockChannel,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      if (items.length == 1) {
        final item = items.single;
        await _plugin.show(
          // One notification per item, replaced if it fires again.
          id: 1000 + (item.id ?? 0),
          title: l10n.lowStockNotifTitle(item.name),
          body: l10n.lowStockNotifBody(item.stock.format(), item.unit),
          notificationDetails: details,
        );
      } else {
        await _plugin.show(
          id: _summaryId,
          title: l10n.lowStockNotifMany(items.length),
          body: items
              .map((i) => '${i.name}: ${i.stock.format()} ${i.unit}')
              .join(', '),
          notificationDetails: details,
        );
      }
    } on Object {
      // Alerts are a convenience: never let them break a sale.
    }
  }
}
