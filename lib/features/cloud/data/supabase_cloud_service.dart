import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:shop_app/app/flavor.dart';
import 'package:shop_app/features/cloud/domain/cloud.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Where the browser sends the user back after Google sign-in. Must be in
/// Supabase → Authentication → URL Configuration → Redirect URLs, and match
/// the intent filter in AndroidManifest.xml (`authScheme` per flavour).
String get authRedirect =>
    '${Flavor.current.isDev ? 'shopappdev' : 'shopapp'}://login-callback';

/// Sets up the Supabase client once, if this build has keys.
Future<void> initSupabase() async {
  if (!cloudConfigured) return;
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
}

/// [CloudService] on Supabase. The shop link lives in a small JSON file
/// beside the database (not inside it; see [CloudLink]).
class SupabaseCloudService implements CloudService {
  SupabaseCloudService({required this._storageDir});

  final Future<Directory> Function() _storageDir;

  SupabaseClient get _db => Supabase.instance.client;

  @override
  bool get available => cloudConfigured;

  static CloudUser? _user(User? u) => u == null
      ? null
      : CloudUser(
          id: u.id,
          email: u.email,
          name: u.userMetadata?['full_name'] as String?,
        );

  @override
  CloudUser? get currentUser => available ? _user(_db.auth.currentUser) : null;

  @override
  Stream<CloudUser?> watchUser() async* {
    if (!available) {
      yield null;
      return;
    }
    yield currentUser;
    yield* _db.auth.onAuthStateChange.map((s) => _user(s.session?.user));
  }

  @override
  Future<void> signInWithGoogle() async {
    await _db.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: authRedirect,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  @override
  Future<void> signOut() async {
    await _db.auth.signOut();
    final f = await _linkFile();
    if (f.existsSync()) await f.delete();
  }

  @override
  Future<List<CloudShop>> myShops() async {
    final rows = await _db
        .from('shop_members')
        .select('role, shops(id, name)')
        .eq('user_id', _db.auth.currentUser!.id);
    return [
      for (final r in rows)
        CloudShop(
          id: (r['shops'] as Map)['id'] as String,
          name: (r['shops'] as Map)['name'] as String,
          role: r['role'] as String,
        ),
    ];
  }

  @override
  Future<CloudShop> createShop(String name) async {
    final row = await _db.rpc<Map<String, dynamic>>(
      'create_shop',
      params: {'p_name': name},
    );
    return CloudShop(
      id: row['id'] as String,
      name: row['name'] as String,
      role: 'owner',
    );
  }

  @override
  Future<CloudLink> linkPhone(CloudShop shop) async {
    final existing = await link();
    final deviceId = existing?.shopId == shop.id ? existing!.deviceId : _uuid();
    final series = await _db.rpc<String>(
      'link_device',
      params: {'p_shop': shop.id, 'p_device': deviceId},
    );
    final linked = CloudLink(
      shopId: shop.id,
      shopName: shop.name,
      deviceId: deviceId,
      series: series,
    );
    await (await _linkFile()).writeAsString(jsonEncode(linked.toJson()));
    return linked;
  }

  @override
  Future<CloudLink?> link() async {
    final f = await _linkFile();
    if (!f.existsSync()) return null;
    try {
      return CloudLink.fromJson(
        jsonDecode(await f.readAsString()) as Map<String, Object?>,
      );
    } on Object {
      return null;
    }
  }

  Future<File> _linkFile() async =>
      File(p.join((await _storageDir()).path, 'cloud_link.json'));

  /// Random version-4 UUID.
  static String _uuid() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
}

/// No cloud (tests, builds without keys).
class NoCloudService implements CloudService {
  const NoCloudService();

  @override
  bool get available => false;

  @override
  CloudUser? get currentUser => null;

  @override
  Stream<CloudUser?> watchUser() => Stream.value(null);

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<List<CloudShop>> myShops() async => const [];

  @override
  Future<CloudShop> createShop(String name) =>
      throw UnsupportedError('No cloud in this build');

  @override
  Future<CloudLink> linkPhone(CloudShop shop) =>
      throw UnsupportedError('No cloud in this build');

  @override
  Future<CloudLink?> link() async => null;
}
