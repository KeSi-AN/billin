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

  @override
  String get actionSales => 'Sales';

  @override
  String get actionSettings => 'Settings';

  @override
  String get homeToday => 'Today';

  @override
  String homeTodaySummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bills',
      one: '1 bill',
      zero: 'No bills yet',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get done => 'Done';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get retry => 'Retry';

  @override
  String get errAmountInvalid => 'Enter an amount like 120 or 49.50';

  @override
  String get errAmountRequired => 'Enter a price';

  @override
  String get errQuantityInvalid => 'Enter a quantity like 2 or 0.5';

  @override
  String get errRequired => 'Required';

  @override
  String get itemsTitle => 'Items';

  @override
  String get itemsSearchHint => 'Search name or barcode';

  @override
  String get itemsEmpty =>
      'No items yet. Add the things you sell to bill them faster.';

  @override
  String itemsNoMatch(String query) {
    return 'No items match \"$query\"';
  }

  @override
  String get itemAdd => 'Add item';

  @override
  String get itemNew => 'New item';

  @override
  String get itemEdit => 'Edit item';

  @override
  String get itemSaved => 'Item saved';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String itemDeleteConfirm(String name) {
    return 'Delete \"$name\"? Past bills keep their copy.';
  }

  @override
  String get fieldItemName => 'Item name';

  @override
  String get fieldBarcode => 'Barcode';

  @override
  String get fieldSalePrice => 'Selling price';

  @override
  String get fieldMrp => 'MRP';

  @override
  String get fieldUnit => 'Unit';

  @override
  String get fieldGstRate => 'GST rate';

  @override
  String get fieldPriceIncludesTax => 'Price includes GST';

  @override
  String get priceIncludesTaxHelp =>
      'On for MRP-style prices. Off to add GST on top.';

  @override
  String get fieldHsn => 'HSN / SAC code';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String errDuplicateBarcode(String name) {
    return 'Barcode already used by \"$name\"';
  }

  @override
  String get errMrpBelowPrice => 'MRP can\'t be lower than the selling price';

  @override
  String get scanTitle => 'Scan a barcode';

  @override
  String get scanHint => 'Point the camera at a barcode';

  @override
  String get scanNoPermission =>
      'Camera permission is needed to scan. You can also type the barcode.';

  @override
  String get scanTorch => 'Torch';

  @override
  String get billingTitle => 'New bill';

  @override
  String get billingSearchHint => 'Scan, or type item name / barcode';

  @override
  String get billingEmpty => 'Scan a barcode or search to add items';

  @override
  String get billingScannerTip =>
      'Bluetooth scanner? Just scan, it types here.';

  @override
  String billingNotFound(String code) {
    return 'No item with barcode $code';
  }

  @override
  String get billingCreateItem => 'Create item';

  @override
  String get billingQuickItem => 'Quick item';

  @override
  String get billingQuickItemName => 'Name (optional)';

  @override
  String get billingQuickItemDefaultName => 'Item';

  @override
  String billingCheckout(String amount) {
    return 'Checkout · $amount';
  }

  @override
  String billingItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get billingClearConfirm => 'Clear this bill?';

  @override
  String get billingClear => 'Clear bill';

  @override
  String get billingDiscardTitle => 'Discard this bill?';

  @override
  String get billingDiscard => 'Discard';

  @override
  String get lineEditTitle => 'Edit line';

  @override
  String get fieldQuantity => 'Quantity';

  @override
  String fieldUnitPrice(String unit) {
    return 'Price per $unit';
  }

  @override
  String get fieldDiscount => 'Discount (₹)';

  @override
  String get fieldDiscountPercent => 'Discount %';

  @override
  String get lineRemove => 'Remove';

  @override
  String lineDiscountTag(String amount) {
    return '−$amount off';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutItemsTotal => 'Items total';

  @override
  String get checkoutBillDiscount => 'Bill discount';

  @override
  String get checkoutTaxable => 'Taxable value';

  @override
  String get checkoutCgst => 'CGST';

  @override
  String get checkoutSgst => 'SGST';

  @override
  String get checkoutGst => 'GST';

  @override
  String get checkoutRoundOff => 'Round off';

  @override
  String get checkoutGrandTotal => 'Total';

  @override
  String get checkoutPayment => 'Payment';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentUpi => 'UPI';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentCredit => 'Credit';

  @override
  String get checkoutCustomer => 'Customer (optional)';

  @override
  String get fieldCustomerName => 'Customer name';

  @override
  String get fieldCustomerPhone => 'Customer mobile';

  @override
  String get checkoutSave => 'Save bill';

  @override
  String get checkoutSaveFailed => 'Couldn\'t save the bill. Please try again.';

  @override
  String get checkoutCreditNeedsCustomer =>
      'Add the customer\'s name for a credit sale';

  @override
  String get checkoutCashReceived => 'Cash received';

  @override
  String checkoutChange(String amount) {
    return 'Return $amount';
  }

  @override
  String get billSaved => 'Bill saved';

  @override
  String get billNewBill => 'New bill';

  @override
  String get billPrint => 'Print';

  @override
  String get billShare => 'Share PDF';

  @override
  String get billCancel => 'Cancel bill';

  @override
  String billCancelTitle(String invoice) {
    return 'Cancel $invoice?';
  }

  @override
  String get billCancelBody =>
      'The bill stays in your records marked as cancelled. Its number is not reused.';

  @override
  String get billCancelReason => 'Reason (optional)';

  @override
  String get billCancelled => 'Cancelled';

  @override
  String billCancelledOn(String date) {
    return 'Cancelled $date';
  }

  @override
  String get billCustomer => 'Customer';

  @override
  String billPaidBy(String mode) {
    return 'Paid by $mode';
  }

  @override
  String billQtyAtPrice(String qty, String unit, String price) {
    return '$qty $unit × $price';
  }

  @override
  String get billTaxSummary => 'GST summary';

  @override
  String billTaxRow(String rate, String taxable) {
    return 'GST $rate on $taxable';
  }

  @override
  String billYouSaved(String amount) {
    return 'Saved $amount in discounts';
  }

  @override
  String get salesTitle => 'Sales';

  @override
  String get salesToday => 'Today';

  @override
  String get salesEmpty => 'No bills on this day';

  @override
  String get salesTotal => 'Total sales';

  @override
  String salesBills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bills',
      one: '1 bill',
    );
    return '$_temp0';
  }

  @override
  String get salesPreviousDay => 'Previous day';

  @override
  String get salesNextDay => 'Next day';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsShop => 'Shop profile';

  @override
  String get settingsBilling => 'Billing';

  @override
  String get settingsBillingSubtitle => 'Invoice number, round-off, UPI';

  @override
  String get settingsPrinter => 'Printer';

  @override
  String get settingsPrinterNone => 'No printer set up';

  @override
  String get billingSettingsTitle => 'Billing settings';

  @override
  String get fieldInvoicePrefix => 'Invoice prefix';

  @override
  String invoicePrefixHelp(String example) {
    return 'Up to 4 letters/numbers. Next bill: $example';
  }

  @override
  String get errInvoicePrefix => 'Use up to 4 capital letters or numbers';

  @override
  String get fieldRoundToRupee => 'Round bill total to the nearest rupee';

  @override
  String get fieldUpiId => 'UPI ID';

  @override
  String get upiIdHelp =>
      'Shows a pay-by-UPI QR on bills, e.g. shopname@okaxis';

  @override
  String get errUpiId => 'Enter a UPI ID like name@bank';

  @override
  String get fieldReceiptFooter => 'Bill footer message';

  @override
  String get receiptFooterHint => 'Thank you! Visit again.';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get printing => 'Printing…';

  @override
  String get printed => 'Printed';

  @override
  String get printErrNotConfigured => 'No printer set up yet';

  @override
  String get printErrPermission =>
      'Allow \"Nearby devices\" so the app can reach your printer';

  @override
  String get printErrBluetoothOff => 'Turn on Bluetooth to print';

  @override
  String get printErrUnsupported => 'This phone doesn\'t have Bluetooth';

  @override
  String get printErrFailed =>
      'Couldn\'t reach the printer. Is it on and nearby?';

  @override
  String get setUpPrinter => 'Set up';

  @override
  String get printerSettingsTitle => 'Printer';

  @override
  String get printerPaired => 'Paired Bluetooth devices';

  @override
  String get printerNoneFound =>
      'No paired devices. Pair your printer in Bluetooth settings first (PIN is usually 0000 or 1234).';

  @override
  String get printerPairNew => 'Pair a new printer';

  @override
  String get printerPaperWidth => 'Paper width';

  @override
  String get printerTestPrint => 'Test print';

  @override
  String get printerLikely => 'Looks like a printer';

  @override
  String get printerAllowAccess => 'Allow access';

  @override
  String get printerTurnOnBluetooth => 'Open Bluetooth settings';

  @override
  String get sharePreparing => 'Preparing PDF…';

  @override
  String shareText(String invoice, String shop, String amount) {
    return 'Invoice $invoice from $shop: $amount';
  }

  @override
  String get shareFailed => 'Couldn\'t create the PDF. Please try again.';
}
