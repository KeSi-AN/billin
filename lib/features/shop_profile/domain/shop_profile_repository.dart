import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';

abstract interface class ShopProfileRepository {
  /// Emits the current profile (or `null` before setup) and every change.
  Stream<ShopProfile?> watch();

  Future<ShopProfile?> load();

  Future<void> save(ShopProfile profile);

  /// Copies a picked image into app storage and returns its new path,
  /// so the logo survives the user deleting it from their gallery.
  Future<String> importLogo(String sourcePath);
}
