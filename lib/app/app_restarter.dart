import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/app.dart';

/// Builds the app's services and can rebuild them from scratch: after a
/// restore replaces the database, everything (repositories, cubits,
/// router) starts again on the new data.
class AppRestarter extends StatefulWidget {
  const AppRestarter({required this.create, super.key});

  final Future<AppServices> Function() create;

  /// Restarts the app if it runs under an [AppRestarter]; returns whether
  /// it did.
  static bool restart(BuildContext context) {
    final state = context.findAncestorStateOfType<_AppRestarterState>();
    state?._restart();
    return state != null;
  }

  @override
  State<AppRestarter> createState() => _AppRestarterState();
}

class _AppRestarterState extends State<AppRestarter> {
  AppServices? _services;
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    final services = await widget.create();
    if (!mounted) return;
    setState(() {
      _services = services;
      _generation++;
    });
  }

  void _restart() {
    setState(() => _services = null);
    unawaited(_start());
  }

  @override
  Widget build(BuildContext context) {
    final services = _services;
    if (services == null) {
      return const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return ShopApp(key: ValueKey(_generation), services: services);
  }
}
