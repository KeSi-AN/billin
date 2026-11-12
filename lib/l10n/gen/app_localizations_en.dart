// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shop App';

  @override
  String get devBanner => 'DEV';

  @override
  String get loading => 'Loading…';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving…';

  @override
  String get optional => 'Optional';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get setupTitle => 'Set up your shop';

  @override
  String get setupIntro =>
      'These details are printed on every bill. You can change them later.';

  @override
  String get editShopTitle => 'Shop profile';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get saved => 'Shop profile saved';

  @override
  String get saveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get logoAdd => 'Add logo';

  @override
  String get logoChange => 'Change logo';

  @override
  String get logoRemove => 'Remove logo';

  @override
  String get logoFromGallery => 'Choose from gallery';

  @override
  String get logoFromCamera => 'Take a photo';

  @override
  String get logoFailed => 'Couldn\'t use that image. Please try another.';

  @override
  String get fieldShopName => 'Shop name';

  @override
  String get fieldPhone => 'Mobile number';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldCity => 'City / town';

  @override
  String get fieldPincode => 'PIN code';

  @override
  String get fieldState => 'State';

  @override
  String get fieldGstin => 'GSTIN';

  @override
  String get gstinHelper => 'Leave empty if you are not GST registered';

  @override
  String get gstinStateSet => 'State set from GSTIN';

  @override
  String get errNameRequired => 'Enter your shop name';

  @override
  String get errNameTooLong => 'Keep it under 100 characters';

  @override
  String get errPhoneInvalid => 'Enter a valid 10-digit mobile number';

  @override
  String get errPincodeInvalid => 'Enter a valid 6-digit PIN code';

  @override
  String get errStateRequired => 'Select your state';

  @override
  String get errGstinInvalid => 'This GSTIN isn\'t valid. Check for typos.';

  @override
  String get errGstinStateMismatch => 'This GSTIN belongs to a different state';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeEditShop => 'Edit shop profile';

  @override
  String homeGstin(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get homeNotGst => 'Not GST registered';

  @override
  String get actionNewBill => 'New bill';

  @override
  String get actionItems => 'Items';

  @override
  String get actionCustomers => 'Customers';

  @override
  String get actionReports => 'Reports';

  @override
  String homeComingSoon(String feature) {
    return '$feature arrives in a later build';
  }
}
