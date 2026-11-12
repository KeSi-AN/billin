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

  /// No description provided for @actionSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get actionSales;

  /// No description provided for @actionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get actionSettings;

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// No description provided for @homeTodaySummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No bills yet} =1{1 bill} other{{count} bills}}'**
  String homeTodaySummary(int count);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount like 120 or 49.50'**
  String get errAmountInvalid;

  /// No description provided for @errAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a price'**
  String get errAmountRequired;

  /// No description provided for @errQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity like 2 or 0.5'**
  String get errQuantityInvalid;

  /// No description provided for @errRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get errRequired;

  /// No description provided for @itemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsTitle;

  /// No description provided for @itemsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or barcode'**
  String get itemsSearchHint;

  /// No description provided for @itemsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Add the things you sell to bill them faster.'**
  String get itemsEmpty;

  /// No description provided for @itemsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No items match \"{query}\"'**
  String itemsNoMatch(String query);

  /// No description provided for @itemAdd.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itemAdd;

  /// No description provided for @itemNew.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get itemNew;

  /// No description provided for @itemEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get itemEdit;

  /// No description provided for @itemSaved.
  ///
  /// In en, this message translates to:
  /// **'Item saved'**
  String get itemSaved;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @itemDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Past bills keep their copy.'**
  String itemDeleteConfirm(String name);

  /// No description provided for @fieldItemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get fieldItemName;

  /// No description provided for @fieldBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get fieldBarcode;

  /// No description provided for @fieldSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price'**
  String get fieldSalePrice;

  /// No description provided for @fieldMrp.
  ///
  /// In en, this message translates to:
  /// **'MRP'**
  String get fieldMrp;

  /// No description provided for @fieldUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get fieldUnit;

  /// No description provided for @fieldGstRate.
  ///
  /// In en, this message translates to:
  /// **'GST rate'**
  String get fieldGstRate;

  /// No description provided for @fieldPriceIncludesTax.
  ///
  /// In en, this message translates to:
  /// **'Price includes GST'**
  String get fieldPriceIncludesTax;

  /// No description provided for @priceIncludesTaxHelp.
  ///
  /// In en, this message translates to:
  /// **'On for MRP-style prices. Off to add GST on top.'**
  String get priceIncludesTaxHelp;

  /// No description provided for @fieldHsn.
  ///
  /// In en, this message translates to:
  /// **'HSN / SAC code'**
  String get fieldHsn;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @errDuplicateBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode already used by \"{name}\"'**
  String errDuplicateBarcode(String name);

  /// No description provided for @errMrpBelowPrice.
  ///
  /// In en, this message translates to:
  /// **'MRP can\'t be lower than the selling price'**
  String get errMrpBelowPrice;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a barcode'**
  String get scanTitle;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a barcode'**
  String get scanHint;

  /// No description provided for @scanNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is needed to scan. You can also type the barcode.'**
  String get scanNoPermission;

  /// No description provided for @scanTorch.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get scanTorch;

  /// No description provided for @billingTitle.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get billingTitle;

  /// No description provided for @billingSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Scan, or type item name / barcode'**
  String get billingSearchHint;

  /// No description provided for @billingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Scan a barcode or search to add items'**
  String get billingEmpty;

  /// No description provided for @billingScannerTip.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth scanner? Just scan, it types here.'**
  String get billingScannerTip;

  /// No description provided for @billingNotFound.
  ///
  /// In en, this message translates to:
  /// **'No item with barcode {code}'**
  String billingNotFound(String code);

  /// No description provided for @billingCreateItem.
  ///
  /// In en, this message translates to:
  /// **'Create item'**
  String get billingCreateItem;

  /// No description provided for @billingQuickItem.
  ///
  /// In en, this message translates to:
  /// **'Quick item'**
  String get billingQuickItem;

  /// No description provided for @billingQuickItemName.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get billingQuickItemName;

  /// No description provided for @billingQuickItemDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get billingQuickItemDefaultName;

  /// No description provided for @billingCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout · {amount}'**
  String billingCheckout(String amount);

  /// No description provided for @billingItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String billingItemsCount(int count);

  /// No description provided for @billingClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear this bill?'**
  String get billingClearConfirm;

  /// No description provided for @billingClear.
  ///
  /// In en, this message translates to:
  /// **'Clear bill'**
  String get billingClear;

  /// No description provided for @billingDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this bill?'**
  String get billingDiscardTitle;

  /// No description provided for @billingDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get billingDiscard;

  /// No description provided for @lineEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit line'**
  String get lineEditTitle;

  /// No description provided for @fieldQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get fieldQuantity;

  /// No description provided for @fieldUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit}'**
  String fieldUnitPrice(String unit);

  /// No description provided for @fieldDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount (₹)'**
  String get fieldDiscount;

  /// No description provided for @fieldDiscountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get fieldDiscountPercent;

  /// No description provided for @lineRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get lineRemove;

  /// No description provided for @lineDiscountTag.
  ///
  /// In en, this message translates to:
  /// **'−{amount} off'**
  String lineDiscountTag(String amount);

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutItemsTotal.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get checkoutItemsTotal;

  /// No description provided for @checkoutBillDiscount.
  ///
  /// In en, this message translates to:
  /// **'Bill discount'**
  String get checkoutBillDiscount;

  /// No description provided for @checkoutTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable value'**
  String get checkoutTaxable;

  /// No description provided for @checkoutCgst.
  ///
  /// In en, this message translates to:
  /// **'CGST'**
  String get checkoutCgst;

  /// No description provided for @checkoutSgst.
  ///
  /// In en, this message translates to:
  /// **'SGST'**
  String get checkoutSgst;

  /// No description provided for @checkoutGst.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get checkoutGst;

  /// No description provided for @checkoutRoundOff.
  ///
  /// In en, this message translates to:
  /// **'Round off'**
  String get checkoutRoundOff;

  /// No description provided for @checkoutGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get checkoutGrandTotal;

  /// No description provided for @checkoutPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutPayment;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentUpi;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get paymentCredit;

  /// No description provided for @checkoutCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer (optional)'**
  String get checkoutCustomer;

  /// No description provided for @fieldCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get fieldCustomerName;

  /// No description provided for @fieldCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer mobile'**
  String get fieldCustomerPhone;

  /// No description provided for @checkoutSave.
  ///
  /// In en, this message translates to:
  /// **'Save bill'**
  String get checkoutSave;

  /// No description provided for @checkoutSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the bill. Please try again.'**
  String get checkoutSaveFailed;

  /// No description provided for @checkoutCreditNeedsCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add the customer\'s name for a credit sale'**
  String get checkoutCreditNeedsCustomer;

  /// No description provided for @checkoutCashReceived.
  ///
  /// In en, this message translates to:
  /// **'Cash received'**
  String get checkoutCashReceived;

  /// No description provided for @checkoutChange.
  ///
  /// In en, this message translates to:
  /// **'Return {amount}'**
  String checkoutChange(String amount);

  /// No description provided for @billSaved.
  ///
  /// In en, this message translates to:
  /// **'Bill saved'**
  String get billSaved;

  /// No description provided for @billNewBill.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get billNewBill;

  /// No description provided for @billPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get billPrint;

  /// No description provided for @billShare.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get billShare;

  /// No description provided for @billCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel bill'**
  String get billCancel;

  /// No description provided for @billCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel {invoice}?'**
  String billCancelTitle(String invoice);

  /// No description provided for @billCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The bill stays in your records marked as cancelled. Its number is not reused.'**
  String get billCancelBody;

  /// No description provided for @billCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get billCancelReason;

  /// No description provided for @billCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get billCancelled;

  /// No description provided for @billCancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {date}'**
  String billCancelledOn(String date);

  /// No description provided for @billCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get billCustomer;

  /// No description provided for @billPaidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by {mode}'**
  String billPaidBy(String mode);

  /// No description provided for @billQtyAtPrice.
  ///
  /// In en, this message translates to:
  /// **'{qty} {unit} × {price}'**
  String billQtyAtPrice(String qty, String unit, String price);

  /// No description provided for @billTaxSummary.
  ///
  /// In en, this message translates to:
  /// **'GST summary'**
  String get billTaxSummary;

  /// No description provided for @billTaxRow.
  ///
  /// In en, this message translates to:
  /// **'GST {rate} on {taxable}'**
  String billTaxRow(String rate, String taxable);

  /// No description provided for @billYouSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {amount} in discounts'**
  String billYouSaved(String amount);

  /// No description provided for @salesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesTitle;

  /// No description provided for @salesToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get salesToday;

  /// No description provided for @salesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bills on this day'**
  String get salesEmpty;

  /// No description provided for @salesTotal.
  ///
  /// In en, this message translates to:
  /// **'Total sales'**
  String get salesTotal;

  /// No description provided for @salesBills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bill} other{{count} bills}}'**
  String salesBills(int count);

  /// No description provided for @salesPreviousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get salesPreviousDay;

  /// No description provided for @salesNextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get salesNextDay;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsShop.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get settingsShop;

  /// No description provided for @settingsBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get settingsBilling;

  /// No description provided for @settingsBillingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice number, round-off, UPI'**
  String get settingsBillingSubtitle;

  /// No description provided for @settingsPrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get settingsPrinter;

  /// No description provided for @settingsPrinterNone.
  ///
  /// In en, this message translates to:
  /// **'No printer set up'**
  String get settingsPrinterNone;

  /// No description provided for @billingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing settings'**
  String get billingSettingsTitle;

  /// No description provided for @fieldInvoicePrefix.
  ///
  /// In en, this message translates to:
  /// **'Invoice prefix'**
  String get fieldInvoicePrefix;

  /// No description provided for @invoicePrefixHelp.
  ///
  /// In en, this message translates to:
  /// **'Up to 4 letters/numbers. Next bill: {example}'**
  String invoicePrefixHelp(String example);

  /// No description provided for @errInvoicePrefix.
  ///
  /// In en, this message translates to:
  /// **'Use up to 4 capital letters or numbers'**
  String get errInvoicePrefix;

  /// No description provided for @fieldRoundToRupee.
  ///
  /// In en, this message translates to:
  /// **'Round bill total to the nearest rupee'**
  String get fieldRoundToRupee;

  /// No description provided for @fieldUpiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get fieldUpiId;

  /// No description provided for @upiIdHelp.
  ///
  /// In en, this message translates to:
  /// **'Shows a pay-by-UPI QR on bills, e.g. shopname@okaxis'**
  String get upiIdHelp;

  /// No description provided for @errUpiId.
  ///
  /// In en, this message translates to:
  /// **'Enter a UPI ID like name@bank'**
  String get errUpiId;

  /// No description provided for @fieldReceiptFooter.
  ///
  /// In en, this message translates to:
  /// **'Bill footer message'**
  String get fieldReceiptFooter;

  /// No description provided for @receiptFooterHint.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Visit again.'**
  String get receiptFooterHint;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @printing.
  ///
  /// In en, this message translates to:
  /// **'Printing…'**
  String get printing;

  /// No description provided for @printed.
  ///
  /// In en, this message translates to:
  /// **'Printed'**
  String get printed;

  /// No description provided for @printErrNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'No printer set up yet'**
  String get printErrNotConfigured;

  /// No description provided for @printErrPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Nearby devices\" so the app can reach your printer'**
  String get printErrPermission;

  /// No description provided for @printErrBluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on Bluetooth to print'**
  String get printErrBluetoothOff;

  /// No description provided for @printErrUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This phone doesn\'t have Bluetooth'**
  String get printErrUnsupported;

  /// No description provided for @printErrFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the printer. Is it on and nearby?'**
  String get printErrFailed;

  /// No description provided for @setUpPrinter.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get setUpPrinter;

  /// No description provided for @printerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get printerSettingsTitle;

  /// No description provided for @printerPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired Bluetooth devices'**
  String get printerPaired;

  /// No description provided for @printerNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No paired devices. Pair your printer in Bluetooth settings first (PIN is usually 0000 or 1234).'**
  String get printerNoneFound;

  /// No description provided for @printerPairNew.
  ///
  /// In en, this message translates to:
  /// **'Pair a new printer'**
  String get printerPairNew;

  /// No description provided for @printerPaperWidth.
  ///
  /// In en, this message translates to:
  /// **'Paper width'**
  String get printerPaperWidth;

  /// No description provided for @printerTestPrint.
  ///
  /// In en, this message translates to:
  /// **'Test print'**
  String get printerTestPrint;

  /// No description provided for @printerLikely.
  ///
  /// In en, this message translates to:
  /// **'Looks like a printer'**
  String get printerLikely;

  /// No description provided for @printerAllowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get printerAllowAccess;

  /// No description provided for @printerTurnOnBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Open Bluetooth settings'**
  String get printerTurnOnBluetooth;

  /// No description provided for @sharePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing PDF…'**
  String get sharePreparing;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Invoice {invoice} from {shop}: {amount}'**
  String shareText(String invoice, String shop, String amount);

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the PDF. Please try again.'**
  String get shareFailed;

  /// No description provided for @actionStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get actionStock;

  /// No description provided for @homeStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All good} =1{1 needs attention} other{{count} need attention}}'**
  String homeStockAlerts(int count);

  /// No description provided for @sectionStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get sectionStock;

  /// No description provided for @fieldTrackStock.
  ///
  /// In en, this message translates to:
  /// **'Track stock'**
  String get fieldTrackStock;

  /// No description provided for @trackStockHelp.
  ///
  /// In en, this message translates to:
  /// **'Count stock as you sell, and get low-stock alerts. Off means unlimited.'**
  String get trackStockHelp;

  /// No description provided for @fieldOpeningStock.
  ///
  /// In en, this message translates to:
  /// **'Opening stock'**
  String get fieldOpeningStock;

  /// No description provided for @fieldLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock alert at'**
  String get fieldLowStock;

  /// No description provided for @lowStockHelp.
  ///
  /// In en, this message translates to:
  /// **'Alert when stock falls to this level'**
  String get lowStockHelp;

  /// No description provided for @fieldTracksBatches.
  ///
  /// In en, this message translates to:
  /// **'Batches & expiry'**
  String get fieldTracksBatches;

  /// No description provided for @tracksBatchesHelp.
  ///
  /// In en, this message translates to:
  /// **'For medicines and food: stock is kept per batch and the earliest expiry sells first.'**
  String get tracksBatchesHelp;

  /// No description provided for @fieldBatchNo.
  ///
  /// In en, this message translates to:
  /// **'Batch no.'**
  String get fieldBatchNo;

  /// No description provided for @fieldExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get fieldExpiry;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get pickDate;

  /// No description provided for @sectionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get sectionCategory;

  /// No description provided for @categoryNone.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get categoryNone;

  /// No description provided for @categoryPick.
  ///
  /// In en, this message translates to:
  /// **'Choose category'**
  String get categoryPick;

  /// No description provided for @categoryNew.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryNew;

  /// No description provided for @subcategoryNew.
  ///
  /// In en, this message translates to:
  /// **'New subcategory in {parent}'**
  String subcategoryNew(String parent);

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get categoryAll;

  /// No description provided for @sectionSecondUnit.
  ///
  /// In en, this message translates to:
  /// **'Second unit (optional)'**
  String get sectionSecondUnit;

  /// No description provided for @secondUnitHelp.
  ///
  /// In en, this message translates to:
  /// **'Sell in a bigger pack too, e.g. a box of 12 pcs.'**
  String get secondUnitHelp;

  /// No description provided for @fieldAltUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get fieldAltUnit;

  /// No description provided for @fieldAltUnitFactor.
  ///
  /// In en, this message translates to:
  /// **'Contains ({unit})'**
  String fieldAltUnitFactor(String unit);

  /// No description provided for @fieldAltUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit}'**
  String fieldAltUnitPrice(String unit);

  /// No description provided for @errAltUnitIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Fill in the unit, how many it contains, and its price'**
  String get errAltUnitIncomplete;

  /// No description provided for @errAltUnitSame.
  ///
  /// In en, this message translates to:
  /// **'Pick a different unit from the main one'**
  String get errAltUnitSame;

  /// No description provided for @itemPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get itemPhoto;

  /// No description provided for @itemPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get itemPhotoAdd;

  /// No description provided for @itemPhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get itemPhotoRemove;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {qty} {unit}'**
  String stockLabel(String qty, String unit);

  /// No description provided for @stockOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get stockOut;

  /// No description provided for @stockLowTag.
  ///
  /// In en, this message translates to:
  /// **'Low: {qty} {unit}'**
  String stockLowTag(String qty, String unit);

  /// No description provided for @stockNotTracked.
  ///
  /// In en, this message translates to:
  /// **'Stock not tracked'**
  String get stockNotTracked;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterLow.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get filterLow;

  /// No description provided for @filterOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get filterOut;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortBy;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortStock.
  ///
  /// In en, this message translates to:
  /// **'Stock: low first'**
  String get sortStock;

  /// No description provided for @sortPrice.
  ///
  /// In en, this message translates to:
  /// **'Price: high first'**
  String get sortPrice;

  /// No description provided for @itemStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock · {name}'**
  String itemStockTitle(String name);

  /// No description provided for @stockAdd.
  ///
  /// In en, this message translates to:
  /// **'Add stock'**
  String get stockAdd;

  /// No description provided for @stockAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get stockAdjust;

  /// No description provided for @stockAdjustTitle.
  ///
  /// In en, this message translates to:
  /// **'Set stock to counted quantity'**
  String get stockAdjustTitle;

  /// No description provided for @stockAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add stock'**
  String get stockAddTitle;

  /// No description provided for @stockAddQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity received ({unit})'**
  String stockAddQty(String unit);

  /// No description provided for @stockCounted.
  ///
  /// In en, this message translates to:
  /// **'Counted quantity ({unit})'**
  String stockCounted(String unit);

  /// No description provided for @stockNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get stockNote;

  /// No description provided for @stockNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. supplier, damaged, recount'**
  String get stockNoteHint;

  /// No description provided for @stockSaved.
  ///
  /// In en, this message translates to:
  /// **'Stock updated'**
  String get stockSaved;

  /// No description provided for @stockBatches.
  ///
  /// In en, this message translates to:
  /// **'Batches'**
  String get stockBatches;

  /// No description provided for @stockHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get stockHistory;

  /// No description provided for @stockNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No stock changes yet'**
  String get stockNoHistory;

  /// No description provided for @stockLowLevel.
  ///
  /// In en, this message translates to:
  /// **'Low-stock alert at {qty}'**
  String stockLowLevel(String qty);

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String expiresOn(String date);

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired {date}'**
  String expiredOn(String date);

  /// No description provided for @noExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get noExpiry;

  /// No description provided for @movementOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening stock'**
  String get movementOpening;

  /// No description provided for @movementStockIn.
  ///
  /// In en, this message translates to:
  /// **'Stock in'**
  String get movementStockIn;

  /// No description provided for @movementSale.
  ///
  /// In en, this message translates to:
  /// **'Sold · {invoice}'**
  String movementSale(String invoice);

  /// No description provided for @movementCancel.
  ///
  /// In en, this message translates to:
  /// **'Bill cancelled · {invoice}'**
  String movementCancel(String invoice);

  /// No description provided for @movementAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjusted'**
  String get movementAdjust;

  /// No description provided for @balanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance {qty}'**
  String balanceAfter(String qty);

  /// No description provided for @stockOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock alerts'**
  String get stockOverviewTitle;

  /// No description provided for @tabLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get tabLowStock;

  /// No description provided for @tabExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get tabExpiring;

  /// No description provided for @tabExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get tabExpired;

  /// No description provided for @emptyLowStock.
  ///
  /// In en, this message translates to:
  /// **'No items are low on stock'**
  String get emptyLowStock;

  /// No description provided for @emptyExpiring.
  ///
  /// In en, this message translates to:
  /// **'Nothing expires in the next 30 days'**
  String get emptyExpiring;

  /// No description provided for @emptyExpired.
  ///
  /// In en, this message translates to:
  /// **'No expired stock'**
  String get emptyExpired;

  /// No description provided for @batchLine.
  ///
  /// In en, this message translates to:
  /// **'Batch {batch} · {qty} {unit}'**
  String batchLine(String batch, String qty, String unit);

  /// No description provided for @onlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {qty} {unit} in stock'**
  String onlyLeft(String qty, String unit);

  /// No description provided for @lineUnit.
  ///
  /// In en, this message translates to:
  /// **'Sell in'**
  String get lineUnit;

  /// No description provided for @lowStockNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock: {name}'**
  String lowStockNotifTitle(String name);

  /// No description provided for @lowStockNotifBody.
  ///
  /// In en, this message translates to:
  /// **'{qty} {unit} left. Time to reorder.'**
  String lowStockNotifBody(String qty, String unit);

  /// No description provided for @lowStockNotifMany.
  ///
  /// In en, this message translates to:
  /// **'{count} items are low on stock'**
  String lowStockNotifMany(int count);

  /// No description provided for @lowStockChannel.
  ///
  /// In en, this message translates to:
  /// **'Low stock alerts'**
  String get lowStockChannel;

  /// No description provided for @importExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import / export'**
  String get importExportTitle;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import items'**
  String get importTitle;

  /// No description provided for @importSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From an Excel (.xlsx) or CSV file. New items are added, matching ones updated.'**
  String get importSubtitle;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export items'**
  String get exportTitle;

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All items as an Excel file: edit it and import it back.'**
  String get exportSubtitle;

  /// No description provided for @templateTitle.
  ///
  /// In en, this message translates to:
  /// **'Download template'**
  String get templateTitle;

  /// No description provided for @templateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'An Excel file with the right columns and two example rows.'**
  String get templateSubtitle;

  /// No description provided for @importReading.
  ///
  /// In en, this message translates to:
  /// **'Reading file…'**
  String get importReading;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read this file: {reason}'**
  String importFailed(String reason);

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'{creates} new · {updates} updated · {errors} with problems'**
  String importSummary(int creates, int updates, int errors);

  /// No description provided for @importUnknownColumns.
  ///
  /// In en, this message translates to:
  /// **'Ignored columns: {columns}'**
  String importUnknownColumns(String columns);

  /// No description provided for @importErrorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rows that won\'t be imported'**
  String get importErrorsTitle;

  /// No description provided for @importRow.
  ///
  /// In en, this message translates to:
  /// **'Row {row}'**
  String importRow(int row);

  /// No description provided for @importStockNote.
  ///
  /// In en, this message translates to:
  /// **'Stock is only set for new items. Change stock of existing items with Adjust.'**
  String get importStockNote;

  /// No description provided for @importGo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 item} other{Import {count} items}}'**
  String importGo(int count);

  /// No description provided for @importNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing to import'**
  String get importNothing;

  /// No description provided for @importProgress.
  ///
  /// In en, this message translates to:
  /// **'Importing {done} of {total}…'**
  String importProgress(int done, int total);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Done: {created} added, {updated} updated'**
  String importDone(int created, int updated);

  /// No description provided for @importDoneFailed.
  ///
  /// In en, this message translates to:
  /// **'{count} couldn\'t be saved'**
  String importDoneFailed(int count);

  /// No description provided for @importViewItems.
  ///
  /// In en, this message translates to:
  /// **'View items'**
  String get importViewItems;

  /// No description provided for @importChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get importChooseFile;

  /// No description provided for @exportShareText.
  ///
  /// In en, this message translates to:
  /// **'Items from {shop}'**
  String exportShareText(String shop);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the file. Please try again.'**
  String get exportFailed;

  /// No description provided for @labelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Print labels'**
  String get labelsTitle;

  /// No description provided for @labelsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose items and how many labels of each.'**
  String get labelsHint;

  /// No description provided for @labelsPrint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Print labels} =1{Print 1 label} other{Print {count} labels}}'**
  String labelsPrint(int count);

  /// No description provided for @labelsNoBarcode.
  ///
  /// In en, this message translates to:
  /// **'No barcode'**
  String get labelsNoBarcode;

  /// No description provided for @labelsCreateBarcode.
  ///
  /// In en, this message translates to:
  /// **'Create barcode'**
  String get labelsCreateBarcode;

  /// No description provided for @labelsBarcodeCreated.
  ///
  /// In en, this message translates to:
  /// **'Barcode {code} saved for {name}'**
  String labelsBarcodeCreated(String code, String name);

  /// No description provided for @labelsShowPrice.
  ///
  /// In en, this message translates to:
  /// **'Show price'**
  String get labelsShowPrice;

  /// No description provided for @labelsShowShop.
  ///
  /// In en, this message translates to:
  /// **'Show shop name'**
  String get labelsShowShop;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @customersTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get customersTotalDue;

  /// No description provided for @customersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or mobile'**
  String get customersSearchHint;

  /// No description provided for @customersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customers yet. Add the people you sell to on credit.'**
  String get customersEmpty;

  /// No description provided for @customersNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No customers match'**
  String get customersNoMatch;

  /// No description provided for @filterWithDues.
  ///
  /// In en, this message translates to:
  /// **'With dues'**
  String get filterWithDues;

  /// No description provided for @sortDue.
  ///
  /// In en, this message translates to:
  /// **'Due: highest first'**
  String get sortDue;

  /// No description provided for @sortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently active'**
  String get sortRecent;

  /// No description provided for @customerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get customerAdd;

  /// No description provided for @customerNew.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get customerNew;

  /// No description provided for @customerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get customerEdit;

  /// No description provided for @customerSaved.
  ///
  /// In en, this message translates to:
  /// **'Customer saved'**
  String get customerSaved;

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer removed'**
  String get customerDeleted;

  /// No description provided for @customerDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\"? Their past bills stay.'**
  String customerDeleteConfirm(String name);

  /// No description provided for @customerHasBalance.
  ///
  /// In en, this message translates to:
  /// **'Settle {amount} before removing this customer'**
  String customerHasBalance(String amount);

  /// No description provided for @errDuplicatePhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number already used by \"{name}\"'**
  String errDuplicatePhone(String name);

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldOpeningDue.
  ///
  /// In en, this message translates to:
  /// **'Already owes (opening due)'**
  String get fieldOpeningDue;

  /// No description provided for @openingDueHelp.
  ///
  /// In en, this message translates to:
  /// **'Money they owed before you started using the app'**
  String get openingDueHelp;

  /// No description provided for @pickFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Pick from contacts'**
  String get pickFromContacts;

  /// No description provided for @balanceDue.
  ///
  /// In en, this message translates to:
  /// **'Due {amount}'**
  String balanceDue(String amount);

  /// No description provided for @balanceAdvance.
  ///
  /// In en, this message translates to:
  /// **'Advance {amount}'**
  String balanceAdvance(String amount);

  /// No description provided for @balanceSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get balanceSettled;

  /// No description provided for @receivePayment.
  ///
  /// In en, this message translates to:
  /// **'Receive payment'**
  String get receivePayment;

  /// No description provided for @receivePaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment from {name}'**
  String receivePaymentTitle(String name);

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get paymentAmount;

  /// No description provided for @payFull.
  ///
  /// In en, this message translates to:
  /// **'Full {amount}'**
  String payFull(String amount);

  /// No description provided for @paymentSaved.
  ///
  /// In en, this message translates to:
  /// **'Payment of {amount} recorded'**
  String paymentSaved(String amount);

  /// No description provided for @errPaymentZero.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount above zero'**
  String get errPaymentZero;

  /// No description provided for @remindWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remindWhatsApp;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @ledgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Khata'**
  String get ledgerTitle;

  /// No description provided for @ledgerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get ledgerEmpty;

  /// No description provided for @entryOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening due'**
  String get entryOpening;

  /// No description provided for @entrySale.
  ///
  /// In en, this message translates to:
  /// **'Bill {invoice}'**
  String entrySale(String invoice);

  /// No description provided for @entryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get entryPayment;

  /// No description provided for @entryPaidAtBilling.
  ///
  /// In en, this message translates to:
  /// **'Paid at billing · {invoice}'**
  String entryPaidAtBilling(String invoice);

  /// No description provided for @entryCancel.
  ///
  /// In en, this message translates to:
  /// **'Bill cancelled · {invoice}'**
  String entryCancel(String invoice);

  /// No description provided for @entryAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get entryAdjust;

  /// No description provided for @checkoutPickCustomer.
  ///
  /// In en, this message translates to:
  /// **'Choose customer'**
  String get checkoutPickCustomer;

  /// No description provided for @checkoutChangeCustomer.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get checkoutChangeCustomer;

  /// No description provided for @checkoutCustomerNeeded.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer for a credit sale'**
  String get checkoutCustomerNeeded;

  /// No description provided for @checkoutPaidNow.
  ///
  /// In en, this message translates to:
  /// **'Paid now'**
  String get checkoutPaidNow;

  /// No description provided for @checkoutPaidNowHelp.
  ///
  /// In en, this message translates to:
  /// **'The rest is added to their dues'**
  String get checkoutPaidNowHelp;

  /// No description provided for @checkoutDueAfter.
  ///
  /// In en, this message translates to:
  /// **'{amount} will be added to dues'**
  String checkoutDueAfter(String amount);

  /// No description provided for @customerCurrentDue.
  ///
  /// In en, this message translates to:
  /// **'Currently owes {amount}'**
  String customerCurrentDue(String amount);

  /// No description provided for @customerPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerPickerTitle;

  /// No description provided for @customerPickerNew.
  ///
  /// In en, this message translates to:
  /// **'New customer \"{name}\"'**
  String customerPickerNew(String name);

  /// No description provided for @billPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billPaid;

  /// No description provided for @billDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get billDue;

  /// No description provided for @salesDueTag.
  ///
  /// In en, this message translates to:
  /// **'Due {amount}'**
  String salesDueTag(String amount);

  /// No description provided for @homeCustomersDue.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String homeCustomersDue(String amount);

  /// No description provided for @homeCustomersNone.
  ///
  /// In en, this message translates to:
  /// **'No dues'**
  String get homeCustomersNone;

  /// No description provided for @whatsAppMissing.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open WhatsApp'**
  String get whatsAppMissing;

  /// No description provided for @statementShareText.
  ///
  /// In en, this message translates to:
  /// **'Account statement for {name} from {shop}'**
  String statementShareText(String name, String shop);

  /// No description provided for @movementPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get movementPurchase;

  /// No description provided for @movementReturn.
  ///
  /// In en, this message translates to:
  /// **'Returned · {invoice}'**
  String movementReturn(String invoice);

  /// No description provided for @entryPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get entryPurchase;

  /// No description provided for @entryReturn.
  ///
  /// In en, this message translates to:
  /// **'Goods returned · {invoice}'**
  String entryReturn(String invoice);

  /// No description provided for @checkoutIgst.
  ///
  /// In en, this message translates to:
  /// **'IGST'**
  String get checkoutIgst;

  /// No description provided for @billBuyerGstin.
  ///
  /// In en, this message translates to:
  /// **'Buyer GSTIN: {gstin}'**
  String billBuyerGstin(String gstin);

  /// No description provided for @billPlaceOfSupply.
  ///
  /// In en, this message translates to:
  /// **'Place of supply: {state}'**
  String billPlaceOfSupply(String state);

  /// No description provided for @billProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit {amount}'**
  String billProfit(String amount);

  /// No description provided for @billProfitPartial.
  ///
  /// In en, this message translates to:
  /// **'Profit {amount} (items with a cost price)'**
  String billProfitPartial(String amount);

  /// No description provided for @fieldStateOptional.
  ///
  /// In en, this message translates to:
  /// **'State (for GST)'**
  String get fieldStateOptional;

  /// No description provided for @stateFromGstinHelp.
  ///
  /// In en, this message translates to:
  /// **'Filled from the GSTIN'**
  String get stateFromGstinHelp;

  /// No description provided for @actionPurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get actionPurchases;

  /// No description provided for @actionExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get actionExpenses;

  /// No description provided for @suppliersTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliersTitle;

  /// No description provided for @supplierAdd.
  ///
  /// In en, this message translates to:
  /// **'Add supplier'**
  String get supplierAdd;

  /// No description provided for @supplierNew.
  ///
  /// In en, this message translates to:
  /// **'New supplier'**
  String get supplierNew;

  /// No description provided for @supplierEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit supplier'**
  String get supplierEdit;

  /// No description provided for @suppliersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet. Add the wholesalers you buy from.'**
  String get suppliersEmpty;

  /// No description provided for @suppliersTotalOwed.
  ///
  /// In en, this message translates to:
  /// **'You owe in total'**
  String get suppliersTotalOwed;

  /// No description provided for @balanceYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {amount}'**
  String balanceYouOwe(String amount);

  /// No description provided for @balanceTheyOwe.
  ///
  /// In en, this message translates to:
  /// **'Advance {amount}'**
  String balanceTheyOwe(String amount);

  /// No description provided for @paySupplier.
  ///
  /// In en, this message translates to:
  /// **'Pay supplier'**
  String get paySupplier;

  /// No description provided for @paySupplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment to {name}'**
  String paySupplierTitle(String name);

  /// No description provided for @paymentMade.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get paymentMade;

  /// No description provided for @supplierPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplierPickerTitle;

  /// No description provided for @pickSupplier.
  ///
  /// In en, this message translates to:
  /// **'Choose supplier'**
  String get pickSupplier;

  /// No description provided for @supplierNeeded.
  ///
  /// In en, this message translates to:
  /// **'Choose a supplier to buy on credit'**
  String get supplierNeeded;

  /// No description provided for @purchasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchasesTitle;

  /// No description provided for @purchasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No purchases this month'**
  String get purchasesEmpty;

  /// No description provided for @purchasesMonthTotal.
  ///
  /// In en, this message translates to:
  /// **'Purchases this month'**
  String get purchasesMonthTotal;

  /// No description provided for @purchaseNew.
  ///
  /// In en, this message translates to:
  /// **'New purchase'**
  String get purchaseNew;

  /// No description provided for @purchaseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add purchase'**
  String get purchaseAdd;

  /// No description provided for @fieldSupplierInvoice.
  ///
  /// In en, this message translates to:
  /// **'Supplier bill no.'**
  String get fieldSupplierInvoice;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Bill date'**
  String get purchaseDate;

  /// No description provided for @purchaseAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get purchaseAddItem;

  /// No description provided for @purchaseNoLines.
  ///
  /// In en, this message translates to:
  /// **'Add the items on the supplier\'s bill'**
  String get purchaseNoLines;

  /// No description provided for @fieldUnitCost.
  ///
  /// In en, this message translates to:
  /// **'Cost per {unit}'**
  String fieldUnitCost(String unit);

  /// No description provided for @fieldCostIncludesTax.
  ///
  /// In en, this message translates to:
  /// **'Cost includes GST'**
  String get fieldCostIncludesTax;

  /// No description provided for @purchaseLineTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String purchaseLineTitle(String name);

  /// No description provided for @purchaseSave.
  ///
  /// In en, this message translates to:
  /// **'Save purchase · {amount}'**
  String purchaseSave(String amount);

  /// No description provided for @purchaseSaved.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved; stock updated'**
  String get purchaseSaved;

  /// No description provided for @purchasePaidNow.
  ///
  /// In en, this message translates to:
  /// **'Paid now'**
  String get purchasePaidNow;

  /// No description provided for @purchaseDueAfter.
  ///
  /// In en, this message translates to:
  /// **'{amount} will be owed to the supplier'**
  String purchaseDueAfter(String amount);

  /// No description provided for @purchaseCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel purchase'**
  String get purchaseCancel;

  /// No description provided for @purchaseCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Stock from this purchase is taken back out, and anything owed to the supplier is reversed.'**
  String get purchaseCancelBody;

  /// No description provided for @purchaseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get purchaseCancelled;

  /// No description provided for @purchaseItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String purchaseItems(int count);

  /// No description provided for @purchaseTaxable.
  ///
  /// In en, this message translates to:
  /// **'Before GST'**
  String get purchaseTaxable;

  /// No description provided for @purchaseGst.
  ///
  /// In en, this message translates to:
  /// **'GST (input credit)'**
  String get purchaseGst;

  /// No description provided for @purchaseTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get purchaseTotal;

  /// No description provided for @purchaseItemPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Search item or scan barcode'**
  String get purchaseItemPickerHint;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get expensesEmpty;

  /// No description provided for @expensesMonthTotal.
  ///
  /// In en, this message translates to:
  /// **'Expenses this month'**
  String get expensesMonthTotal;

  /// No description provided for @expenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseAdd;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'What for'**
  String get expenseCategory;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @expenseDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDate;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved'**
  String get expenseSaved;

  /// No description provided for @expenseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Expense removed'**
  String get expenseDeleted;

  /// No description provided for @expenseDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this {amount} expense?'**
  String expenseDeleteConfirm(String amount);

  /// No description provided for @billReturn.
  ///
  /// In en, this message translates to:
  /// **'Return items'**
  String get billReturn;

  /// No description provided for @returnTitle.
  ///
  /// In en, this message translates to:
  /// **'Return items · {invoice}'**
  String returnTitle(String invoice);

  /// No description provided for @returnLeft.
  ///
  /// In en, this message translates to:
  /// **'{qty} {unit} can be returned'**
  String returnLeft(String qty, String unit);

  /// No description provided for @returnNothingLeft.
  ///
  /// In en, this message translates to:
  /// **'Everything on this bill has been returned'**
  String get returnNothingLeft;

  /// No description provided for @returnRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund by'**
  String get returnRefund;

  /// No description provided for @returnOffDues.
  ///
  /// In en, this message translates to:
  /// **'Taken off {name}\'s dues'**
  String returnOffDues(String name);

  /// No description provided for @returnReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get returnReason;

  /// No description provided for @returnSave.
  ///
  /// In en, this message translates to:
  /// **'Issue credit note · {amount}'**
  String returnSave(String amount);

  /// No description provided for @returnSaved.
  ///
  /// In en, this message translates to:
  /// **'Credit note {note} issued'**
  String returnSaved(String note);

  /// No description provided for @returnChooseQty.
  ///
  /// In en, this message translates to:
  /// **'Choose how many of each item came back'**
  String get returnChooseQty;

  /// No description provided for @billCreditNotes.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get billCreditNotes;

  /// No description provided for @creditNoteLine.
  ///
  /// In en, this message translates to:
  /// **'{note} · {amount}'**
  String creditNoteLine(String note, String amount);

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get reportsSales;

  /// No description provided for @reportsReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get reportsReturns;

  /// No description provided for @reportsNetSales.
  ///
  /// In en, this message translates to:
  /// **'Net sales'**
  String get reportsNetSales;

  /// No description provided for @reportsPurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get reportsPurchases;

  /// No description provided for @reportsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportsExpenses;

  /// No description provided for @reportsGrossProfit.
  ///
  /// In en, this message translates to:
  /// **'Gross profit'**
  String get reportsGrossProfit;

  /// No description provided for @reportsGrossProfitPartial.
  ///
  /// In en, this message translates to:
  /// **'Gross profit (items with cost)'**
  String get reportsGrossProfitPartial;

  /// No description provided for @reportsNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net profit'**
  String get reportsNetProfit;

  /// No description provided for @reportsGstTitle.
  ///
  /// In en, this message translates to:
  /// **'GST for the month'**
  String get reportsGstTitle;

  /// No description provided for @reportsOutputTax.
  ///
  /// In en, this message translates to:
  /// **'GST on sales (after returns)'**
  String get reportsOutputTax;

  /// No description provided for @reportsInputTax.
  ///
  /// In en, this message translates to:
  /// **'Input tax credit'**
  String get reportsInputTax;

  /// No description provided for @reportsGstPayable.
  ///
  /// In en, this message translates to:
  /// **'GST payable'**
  String get reportsGstPayable;

  /// No description provided for @reportsGstCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit carried forward'**
  String get reportsGstCredit;

  /// No description provided for @reportsBills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No bills} =1{1 bill} other{{count} bills}}'**
  String reportsBills(int count);

  /// No description provided for @reportsExport.
  ///
  /// In en, this message translates to:
  /// **'Export GST report (Excel)'**
  String get reportsExport;

  /// No description provided for @reportsExportHelp.
  ///
  /// In en, this message translates to:
  /// **'GSTR-1 style sheets (B2B, B2CS, HSN, credit notes, documents) plus purchases and a summary, for your CA.'**
  String get reportsExportHelp;

  /// No description provided for @reportsShareText.
  ///
  /// In en, this message translates to:
  /// **'GST report {month} · {shop}'**
  String reportsShareText(String month, String shop);

  /// No description provided for @reportsPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get reportsPreviousMonth;

  /// No description provided for @reportsNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get reportsNextMonth;

  /// No description provided for @reportsNotes.
  ///
  /// In en, this message translates to:
  /// **'Check before filing'**
  String get reportsNotes;
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
