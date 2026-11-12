import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/features/shop_profile/data/drift_shop_profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDateFormatting();

  final db = AppDatabase();
  final shopProfiles = DriftShopProfileRepository(
    db,
    storageDir: getApplicationSupportDirectory,
  );

  runApp(ShopApp(shopProfileRepository: shopProfiles));
}
