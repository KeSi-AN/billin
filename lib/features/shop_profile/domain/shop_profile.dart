import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_profile.freezed.dart';

/// The shop's own details, printed on every bill.
@freezed
abstract class ShopProfile with _$ShopProfile {
  const factory ShopProfile({
    required String name,

    /// GST state code, e.g. `27` for Maharashtra.
    required String stateCode,
    String? phone,
    String? addressLine,
    String? city,
    String? pincode,
    String? gstin,
    String? logoPath,
  }) = _ShopProfile;
}
