import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop App'**
  String get appTitle;

  /// No description provided for @devBanner.
  ///
  /// In en, this message translates to:
  /// **'DEV'**
  String get devBanner;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your shop'**
  String get setupTitle;

  /// No description provided for @setupIntro.
  ///
  /// In en, this message translates to:
  /// **'These details are printed on every bill. You can change them later.'**
  String get setupIntro;

  /// No description provided for @editShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get editShopTitle;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get saveAndContinue;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Shop profile saved'**
  String get saved;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get saveFailed;

  /// No description provided for @logoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add logo'**
  String get logoAdd;

  /// No description provided for @logoChange.
  ///
  /// In en, this message translates to:
  /// **'Change logo'**
  String get logoChange;

  /// No description provided for @logoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove logo'**
  String get logoRemove;

  /// No description provided for @logoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get logoFromGallery;

  /// No description provided for @logoFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get logoFromCamera;

  /// No description provided for @logoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t use that image. Please try another.'**
  String get logoFailed;

  /// No description provided for @fieldShopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get fieldShopName;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get fieldPhone;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @fieldCity.
  ///
  /// In en, this message translates to:
  /// **'City / town'**
  String get fieldCity;

  /// No description provided for @fieldPincode.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get fieldPincode;

  /// No description provided for @fieldState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get fieldState;

  /// No description provided for @fieldGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get fieldGstin;

  /// No description provided for @gstinHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if you are not GST registered'**
  String get gstinHelper;

  /// No description provided for @gstinStateSet.
  ///
  /// In en, this message translates to:
  /// **'State set from GSTIN'**
  String get gstinStateSet;

  /// No description provided for @errNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your shop name'**
  String get errNameRequired;

  /// No description provided for @errNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Keep it under 100 characters'**
  String get errNameTooLong;

  /// No description provided for @errPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get errPhoneInvalid;

  /// No description provided for @errPincodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit PIN code'**
  String get errPincodeInvalid;

  /// No description provided for @errStateRequired.
  ///
  /// In en, this message translates to:
  /// **'Select your state'**
  String get errStateRequired;

  /// No description provided for @errGstinInvalid.
  ///
  /// In en, this message translates to:
  /// **'This GSTIN isn\'t valid. Check for typos.'**
  String get errGstinInvalid;

  /// No description provided for @errGstinStateMismatch.
  ///
  /// In en, this message translates to:
  /// **'This GSTIN belongs to a different state'**
  String get errGstinStateMismatch;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeEditShop.
  ///
  /// In en, this message translates to:
  /// **'Edit shop profile'**
  String get homeEditShop;

  /// No description provided for @homeGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN: {gstin}'**
  String homeGstin(String gstin);

  /// No description provided for @homeNotGst.
  ///
  /// In en, this message translates to:
  /// **'Not GST registered'**
  String get homeNotGst;

  /// No description provided for @actionNewBill.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get actionNewBill;

  /// No description provided for @actionItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get actionItems;

  /// No description provided for @actionCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get actionCustomers;

  /// No description provided for @actionReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get actionReports;

  /// No description provided for @homeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} arrives in a later build'**
  String homeComingSoon(String feature);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
