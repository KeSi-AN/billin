import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/india/phone.dart';

/// Why a shop profile field is invalid. The UI maps these to messages.
enum ShopFieldError {
  nameRequired,
  nameTooLong,
  phoneInvalid,
  pincodeInvalid,
  stateRequired,
  gstinInvalid,
  gstinStateMismatch,
}

abstract final class ShopProfileValidators {
  static ShopFieldError? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return ShopFieldError.nameRequired;
    if (v.length > 100) return ShopFieldError.nameTooLong;
    return null;
  }

  /// Optional, but if given must be a valid Indian mobile number.
  static ShopFieldError? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    return IndianPhone.isValidMobile(v) ? null : ShopFieldError.phoneInvalid;
  }

  static ShopFieldError? pincode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    return isValidPincode(v) ? null : ShopFieldError.pincodeInvalid;
  }

  static ShopFieldError? state(String? code) =>
      (code == null || code.isEmpty) ? ShopFieldError.stateRequired : null;

  /// Optional. When given it must be valid and match the selected state.
  static ShopFieldError? gstin(String? value, {String? stateCode}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (Gstin.validate(v) != null) return ShopFieldError.gstinInvalid;
    if (stateCode != null && Gstin.stateCode(v) != stateCode) {
      return ShopFieldError.gstinStateMismatch;
    }
    return null;
  }
}
