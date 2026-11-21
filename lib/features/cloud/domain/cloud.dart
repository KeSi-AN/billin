import 'package:meta/meta.dart';

/// Supabase project, from `--dart-define-from-file=config/supabase.json`.
/// Empty in tests and in builds without the file: cloud features are hidden.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
bool get cloudConfigured => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;

/// A shop in the cloud the signed-in user belongs to.
@immutable
class CloudShop {
  const CloudShop({required this.id, required this.name, required this.role});

  final String id;
  final String name;

  /// `owner` or `staff`.
  final String role;

  @override
  bool operator ==(Object other) => other is CloudShop && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// This phone's place in a cloud shop. Kept outside the database on
/// purpose: a backup restored onto another phone must not carry this
/// phone's identity.
@immutable
class CloudLink {
  const CloudLink({
    required this.shopId,
    required this.shopName,
    required this.deviceId,
    required this.series,
  });

  factory CloudLink.fromJson(Map<String, Object?> j) => CloudLink(
    shopId: j['shopId']! as String,
    shopName: j['shopName']! as String,
    deviceId: j['deviceId']! as String,
    series: j['series']! as String,
  );

  final String shopId;
  final String shopName;

  /// A random id made on this phone when it joins.
  final String deviceId;

  /// This phone's bill series letter: A, B, C…
  final String series;

  Map<String, Object?> toJson() => {
    'shopId': shopId,
    'shopName': shopName,
    'deviceId': deviceId,
    'series': series,
  };
}

@immutable
class CloudUser {
  const CloudUser({required this.id, this.email, this.name});

  final String id;
  final String? email;
  final String? name;
}

/// Sign-in and joining a shop. Sync builds on this.
abstract interface class CloudService {
  /// `false` when the app was built without Supabase keys.
  bool get available;

  /// The signed-in user; emits on sign-in and sign-out.
  Stream<CloudUser?> watchUser();

  CloudUser? get currentUser;

  /// Opens Google sign-in in the browser; the result arrives on
  /// [watchUser] when the browser returns to the app.
  Future<void> signInWithGoogle();

  /// Signs out and forgets the shop link on this phone. Data on the phone
  /// stays.
  Future<void> signOut();

  /// Shops the user belongs to.
  Future<List<CloudShop>> myShops();

  /// Creates a shop owned by the user.
  Future<CloudShop> createShop(String name);

  /// Joins this phone to [shop], getting its own bill series letter.
  Future<CloudLink> linkPhone(CloudShop shop);

  /// This phone's link, if it has joined a shop.
  Future<CloudLink?> link();
}

/// The invoice-number series for this phone (`null` when not linked).
typedef SeriesOf = Future<String?> Function();
