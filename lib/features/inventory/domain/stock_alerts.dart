import 'package:shop_app/features/items/domain/item.dart';

/// Tells the shopkeeper when items run low. An interface so billing doesn't
/// depend on the notification plugin and tests can record alerts.
abstract interface class StockAlerts {
  /// [items] just crossed their low-stock level with the last sale.
  Future<void> lowStock(List<Item> items);
}
