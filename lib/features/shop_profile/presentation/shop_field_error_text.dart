import 'package:shop_app/features/shop_profile/domain/shop_profile_validators.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

extension ShopFieldErrorText on ShopFieldError {
  String message(AppLocalizations l10n) => switch (this) {
    ShopFieldError.nameRequired => l10n.errNameRequired,
    ShopFieldError.nameTooLong => l10n.errNameTooLong,
    ShopFieldError.phoneInvalid => l10n.errPhoneInvalid,
    ShopFieldError.pincodeInvalid => l10n.errPincodeInvalid,
    ShopFieldError.stateRequired => l10n.errStateRequired,
    ShopFieldError.gstinInvalid => l10n.errGstinInvalid,
    ShopFieldError.gstinStateMismatch => l10n.errGstinStateMismatch,
  };
}
