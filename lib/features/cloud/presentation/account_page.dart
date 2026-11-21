import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/cloud/domain/cloud.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Sign in with Google, then create the shop in the cloud or join this
/// phone to one. The app works the same without signing in.
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final CloudService _cloud = context.read<CloudService>();
  StreamSubscription<CloudUser?>? _sub;
  CloudUser? _user;
  CloudLink? _link;
  List<CloudShop>? _shops;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _user = _cloud.currentUser;
    _sub = _cloud.watchUser().listen((u) {
      if (!mounted) return;
      setState(() => _user = u);
      unawaited(_refresh());
    });
    unawaited(_refresh());
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  Future<void> _refresh() async {
    final link = await _cloud.link();
    List<CloudShop>? shops;
    String? error;
    if (_user != null && link == null) {
      try {
        shops = await _cloud.myShops();
      } on Object catch (e) {
        error = '$e';
      }
    }
    if (!mounted) return;
    setState(() {
      _link = link;
      _shops = shops;
      _error = error;
    });
  }

  Future<void> _run(Future<void> Function() work) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await work();
    } on Object catch (e) {
      if (mounted) showSnack(context, l10n.cloudFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    await _refresh();
  }

  String get _localShopName => switch (context.read<ShopProfileCubit>().state) {
    ShopProfileReady(:final profile) => profile.name,
    _ => '',
  };

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l10n.cloudSignOutTitle,
      body: l10n.cloudSignOutBody,
      confirmLabel: l10n.cloudSignOut,
    );
    if (ok) await _run(_cloud.signOut);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final user = _user;
    final link = _link;

    Widget body;
    if (!_cloud.available) {
      body = Text(l10n.cloudNotInBuild);
    } else if (user == null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.cloudWhy),
          const SizedBox(height: 24),
          FilledButton.icon(
            key: const Key('googleSignInButton'),
            onPressed: _busy ? null : () => _run(_cloud.signInWithGoogle),
            icon: const Icon(Icons.login),
            label: Text(l10n.cloudSignInGoogle),
          ),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(user.name ?? user.email ?? ''),
            subtitle: user.name == null ? null : Text(user.email ?? ''),
          ),
          const Divider(height: 24),
          if (link != null) ...[
            ListTile(
              key: const Key('linkedShop'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.storefront_outlined),
              title: Text(link.shopName),
              subtitle: Text(l10n.cloudPhoneSeries(link.series)),
            ),
            const SizedBox(height: 8),
            Text(l10n.cloudSyncSoon, style: text.bodySmall),
          ] else if (_error != null)
            Text(l10n.cloudFailed(_error!))
          else if (_shops == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            Text(
              _shops!.isEmpty ? l10n.cloudNoShopYet : l10n.cloudPickShop,
              style: text.titleSmall,
            ),
            const SizedBox(height: 8),
            for (final s in _shops!)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.storefront_outlined),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(s.name, style: text.titleMedium),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _busy
                            ? null
                            : () => _run(() => _cloud.linkPhone(s)),
                        child: Text(l10n.cloudUseHere),
                      ),
                    ],
                  ),
                ),
              ),
            if (_shops!.isEmpty)
              FilledButton(
                key: const Key('createCloudShopButton'),
                onPressed: _busy || _localShopName.isEmpty
                    ? null
                    : () => _run(() async {
                        final shop = await _cloud.createShop(_localShopName);
                        await _cloud.linkPhone(shop);
                      }),
                child: Text(l10n.cloudCreateShop(_localShopName)),
              ),
          ],
          const SizedBox(height: 32),
          OutlinedButton.icon(
            key: const Key('signOutButton'),
            onPressed: _busy ? null : _signOut,
            icon: const Icon(Icons.logout),
            label: Text(l10n.cloudSignOut),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cloudTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          body,
          if (_busy) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
