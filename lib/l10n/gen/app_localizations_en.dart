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

  @override
  String get actionStock => 'Stock';

  @override
  String homeStockAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count need attention',
      one: '1 needs attention',
      zero: 'All good',
    );
    return '$_temp0';
  }

  @override
  String get sectionStock => 'Stock';

  @override
  String get fieldTrackStock => 'Track stock';

  @override
  String get trackStockHelp =>
      'Count stock as you sell, and get low-stock alerts. Off means unlimited.';

  @override
  String get fieldOpeningStock => 'Opening stock';

  @override
  String get fieldLowStock => 'Low stock alert at';

  @override
  String get lowStockHelp => 'Alert when stock falls to this level';

  @override
  String get fieldTracksBatches => 'Batches & expiry';

  @override
  String get tracksBatchesHelp =>
      'For medicines and food: stock is kept per batch and the earliest expiry sells first.';

  @override
  String get fieldBatchNo => 'Batch no.';

  @override
  String get fieldExpiry => 'Expiry date';

  @override
  String get pickDate => 'Pick date';

  @override
  String get sectionCategory => 'Category';

  @override
  String get categoryNone => 'No category';

  @override
  String get categoryPick => 'Choose category';

  @override
  String get categoryNew => 'New category';

  @override
  String subcategoryNew(String parent) {
    return 'New subcategory in $parent';
  }

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryAll => 'All categories';

  @override
  String get sectionSecondUnit => 'Second unit (optional)';

  @override
  String get secondUnitHelp =>
      'Sell in a bigger pack too, e.g. a box of 12 pcs.';

  @override
  String get fieldAltUnit => 'Unit';

  @override
  String fieldAltUnitFactor(String unit) {
    return 'Contains ($unit)';
  }

  @override
  String fieldAltUnitPrice(String unit) {
    return 'Price per $unit';
  }

  @override
  String get errAltUnitIncomplete =>
      'Fill in the unit, how many it contains, and its price';

  @override
  String get errAltUnitSame => 'Pick a different unit from the main one';

  @override
  String get itemPhoto => 'Photo';

  @override
  String get itemPhotoAdd => 'Add photo';

  @override
  String get itemPhotoRemove => 'Remove photo';

  @override
  String stockLabel(String qty, String unit) {
    return 'Stock: $qty $unit';
  }

  @override
  String get stockOut => 'Out of stock';

  @override
  String stockLowTag(String qty, String unit) {
    return 'Low: $qty $unit';
  }

  @override
  String get stockNotTracked => 'Stock not tracked';

  @override
  String get filterAll => 'All';

  @override
  String get filterLow => 'Low stock';

  @override
  String get filterOut => 'Out of stock';

  @override
  String get sortBy => 'Sort';

  @override
  String get sortName => 'Name';

  @override
  String get sortStock => 'Stock: low first';

  @override
  String get sortPrice => 'Price: high first';

  @override
  String itemStockTitle(String name) {
    return 'Stock · $name';
  }

  @override
  String get stockAdd => 'Add stock';

  @override
  String get stockAdjust => 'Adjust';

  @override
  String get stockAdjustTitle => 'Set stock to counted quantity';

  @override
  String get stockAddTitle => 'Add stock';

  @override
  String stockAddQty(String unit) {
    return 'Quantity received ($unit)';
  }

  @override
  String stockCounted(String unit) {
    return 'Counted quantity ($unit)';
  }

  @override
  String get stockNote => 'Note (optional)';

  @override
  String get stockNoteHint => 'e.g. supplier, damaged, recount';

  @override
  String get stockSaved => 'Stock updated';

  @override
  String get stockBatches => 'Batches';

  @override
  String get stockHistory => 'History';

  @override
  String get stockNoHistory => 'No stock changes yet';

  @override
  String stockLowLevel(String qty) {
    return 'Low-stock alert at $qty';
  }

  @override
  String expiresOn(String date) {
    return 'Expires $date';
  }

  @override
  String expiredOn(String date) {
    return 'Expired $date';
  }

  @override
  String get noExpiry => 'No expiry';

  @override
  String get movementOpening => 'Opening stock';

  @override
  String get movementStockIn => 'Stock in';

  @override
  String movementSale(String invoice) {
    return 'Sold · $invoice';
  }

  @override
  String movementCancel(String invoice) {
    return 'Bill cancelled · $invoice';
  }

  @override
  String get movementAdjust => 'Adjusted';

  @override
  String balanceAfter(String qty) {
    return 'Balance $qty';
  }

  @override
  String get stockOverviewTitle => 'Stock alerts';

  @override
  String get tabLowStock => 'Low stock';

  @override
  String get tabExpiring => 'Expiring soon';

  @override
  String get tabExpired => 'Expired';

  @override
  String get emptyLowStock => 'No items are low on stock';

  @override
  String get emptyExpiring => 'Nothing expires in the next 30 days';

  @override
  String get emptyExpired => 'No expired stock';

  @override
  String batchLine(String batch, String qty, String unit) {
    return 'Batch $batch · $qty $unit';
  }

  @override
  String onlyLeft(String qty, String unit) {
    return 'Only $qty $unit in stock';
  }

  @override
  String get lineUnit => 'Sell in';

  @override
  String lowStockNotifTitle(String name) {
    return 'Low stock: $name';
  }

  @override
  String lowStockNotifBody(String qty, String unit) {
    return '$qty $unit left. Time to reorder.';
  }

  @override
  String lowStockNotifMany(int count) {
    return '$count items are low on stock';
  }

  @override
  String get lowStockChannel => 'Low stock alerts';

  @override
  String get importExportTitle => 'Import / export';

  @override
  String get importTitle => 'Import items';

  @override
  String get importSubtitle =>
      'From an Excel (.xlsx) or CSV file. New items are added, matching ones updated.';

  @override
  String get exportTitle => 'Export items';

  @override
  String get exportSubtitle =>
      'All items as an Excel file: edit it and import it back.';

  @override
  String get templateTitle => 'Download template';

  @override
  String get templateSubtitle =>
      'An Excel file with the right columns and two example rows.';

  @override
  String get importReading => 'Reading file…';

  @override
  String importFailed(String reason) {
    return 'Couldn\'t read this file: $reason';
  }

  @override
  String importSummary(int creates, int updates, int errors) {
    return '$creates new · $updates updated · $errors with problems';
  }

  @override
  String importUnknownColumns(String columns) {
    return 'Ignored columns: $columns';
  }

  @override
  String get importErrorsTitle => 'Rows that won\'t be imported';

  @override
  String importRow(int row) {
    return 'Row $row';
  }

  @override
  String get importStockNote =>
      'Stock is only set for new items. Change stock of existing items with Adjust.';

  @override
  String importGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count items',
      one: 'Import 1 item',
    );
    return '$_temp0';
  }

  @override
  String get importNothing => 'Nothing to import';

  @override
  String importProgress(int done, int total) {
    return 'Importing $done of $total…';
  }

  @override
  String importDone(int created, int updated) {
    return 'Done: $created added, $updated updated';
  }

  @override
  String importDoneFailed(int count) {
    return '$count couldn\'t be saved';
  }

  @override
  String get importViewItems => 'View items';

  @override
  String get importChooseFile => 'Choose file';

  @override
  String exportShareText(String shop) {
    return 'Items from $shop';
  }

  @override
  String get exportFailed => 'Couldn\'t create the file. Please try again.';

  @override
  String get labelsTitle => 'Print labels';

  @override
  String get labelsHint => 'Choose items and how many labels of each.';

  @override
  String labelsPrint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Print $count labels',
      one: 'Print 1 label',
      zero: 'Print labels',
    );
    return '$_temp0';
  }

  @override
  String get labelsNoBarcode => 'No barcode';

  @override
  String get labelsCreateBarcode => 'Create barcode';

  @override
  String labelsBarcodeCreated(String code, String name) {
    return 'Barcode $code saved for $name';
  }

  @override
  String get labelsShowPrice => 'Show price';

  @override
  String get labelsShowShop => 'Show shop name';

  @override
  String get customersTitle => 'Customers';

  @override
  String get customersTotalDue => 'Total due';

  @override
  String get customersSearchHint => 'Search name or mobile';

  @override
  String get customersEmpty =>
      'No customers yet. Add the people you sell to on credit.';

  @override
  String get customersNoMatch => 'No customers match';

  @override
  String get filterWithDues => 'With dues';

  @override
  String get sortDue => 'Due: highest first';

  @override
  String get sortRecent => 'Recently active';

  @override
  String get customerAdd => 'Add customer';

  @override
  String get customerNew => 'New customer';

  @override
  String get customerEdit => 'Edit customer';

  @override
  String get customerSaved => 'Customer saved';

  @override
  String get customerDeleted => 'Customer removed';

  @override
  String customerDeleteConfirm(String name) {
    return 'Remove \"$name\"? Their past bills stay.';
  }

  @override
  String customerHasBalance(String amount) {
    return 'Settle $amount before removing this customer';
  }

  @override
  String errDuplicatePhone(String name) {
    return 'Mobile number already used by \"$name\"';
  }

  @override
  String get fieldName => 'Name';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldOpeningDue => 'Already owes (opening due)';

  @override
  String get openingDueHelp =>
      'Money they owed before you started using the app';

  @override
  String get pickFromContacts => 'Pick from contacts';

  @override
  String balanceDue(String amount) {
    return 'Due $amount';
  }

  @override
  String balanceAdvance(String amount) {
    return 'Advance $amount';
  }

  @override
  String get balanceSettled => 'Settled';

  @override
  String get receivePayment => 'Receive payment';

  @override
  String receivePaymentTitle(String name) {
    return 'Payment from $name';
  }

  @override
  String get paymentAmount => 'Amount received';

  @override
  String payFull(String amount) {
    return 'Full $amount';
  }

  @override
  String paymentSaved(String amount) {
    return 'Payment of $amount recorded';
  }

  @override
  String get errPaymentZero => 'Enter an amount above zero';

  @override
  String get remindWhatsApp => 'Remind';

  @override
  String get statement => 'Statement';

  @override
  String get ledgerTitle => 'Khata';

  @override
  String get ledgerEmpty => 'No entries yet';

  @override
  String get entryOpening => 'Opening due';

  @override
  String entrySale(String invoice) {
    return 'Bill $invoice';
  }

  @override
  String get entryPayment => 'Payment received';

  @override
  String entryPaidAtBilling(String invoice) {
    return 'Paid at billing · $invoice';
  }

  @override
  String entryCancel(String invoice) {
    return 'Bill cancelled · $invoice';
  }

  @override
  String get entryAdjust => 'Adjustment';

  @override
  String get checkoutPickCustomer => 'Choose customer';

  @override
  String get checkoutChangeCustomer => 'Change';

  @override
  String get checkoutCustomerNeeded => 'Choose a customer for a credit sale';

  @override
  String get checkoutPaidNow => 'Paid now';

  @override
  String get checkoutPaidNowHelp => 'The rest is added to their dues';

  @override
  String checkoutDueAfter(String amount) {
    return '$amount will be added to dues';
  }

  @override
  String customerCurrentDue(String amount) {
    return 'Currently owes $amount';
  }

  @override
  String get customerPickerTitle => 'Customer';

  @override
  String customerPickerNew(String name) {
    return 'New customer \"$name\"';
  }

  @override
  String get billPaid => 'Paid';

  @override
  String get billDue => 'Due';

  @override
  String salesDueTag(String amount) {
    return 'Due $amount';
  }

  @override
  String homeCustomersDue(String amount) {
    return '$amount due';
  }

  @override
  String get homeCustomersNone => 'No dues';

  @override
  String get whatsAppMissing => 'Couldn\'t open WhatsApp';

  @override
  String statementShareText(String name, String shop) {
    return 'Account statement for $name from $shop';
  }

  @override
  String get movementPurchase => 'Purchased';

  @override
  String movementReturn(String invoice) {
    return 'Returned · $invoice';
  }

  @override
  String get entryPurchase => 'Purchase';

  @override
  String entryReturn(String invoice) {
    return 'Goods returned · $invoice';
  }
}
