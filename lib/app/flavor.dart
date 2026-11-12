import 'package:flutter/services.dart' show appFlavor;

/// Which build this is. Set by `flutter run/build --flavor dev|prod`.
enum Flavor {
  dev,
  prod;

  static Flavor get current => appFlavor == 'prod' ? Flavor.prod : Flavor.dev;

  bool get isDev => this == Flavor.dev;
}
