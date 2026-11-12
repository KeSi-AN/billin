import 'dart:io';

import 'package:material_ui/material_ui.dart';

/// Round shop logo, falling back to the shop's initial.
class ShopLogo extends StatelessWidget {
  const ShopLogo({
    required this.name,
    this.path,
    this.radius = 32,
    super.key,
  });

  final String? path;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final file = path == null ? null : File(path!);
    final hasImage = file != null && file.existsSync();
    final initial = name.trim().isEmpty ? '' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      backgroundImage: hasImage ? FileImage(file) : null,
      child: hasImage
          ? null
          : (initial.isEmpty
                ? Icon(Icons.storefront, size: radius)
                : Text(initial, style: TextStyle(fontSize: radius * 0.8))),
    );
  }
}
