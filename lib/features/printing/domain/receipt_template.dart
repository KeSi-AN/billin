import 'dart:convert';

import 'package:meta/meta.dart';

/// When to print the pay-by-UPI QR (it always carries the amount to pay).
enum QrMode {
  /// Never.
  off,

  /// Bills paid by UPI, and credit bills (for the amount still due).
  upiAndCredit,

  /// Every bill, so the customer can choose to pay by UPI at the counter.
  always,
}

/// What goes on a printed bill. Edited in Settings → Bill template; stored
/// as JSON so new options never need a database change.
@immutable
class ReceiptTemplate {
  const ReceiptTemplate({
    this.showLogo = true,
    this.logoWidthPercent = 60,
    this.showShopName = true,
    this.showPhone = true,
    this.showAddress = true,
    this.addressLabel = 'Address: ',
    this.showGstin = true,
    this.headerNote = '',
    this.showBillNo = true,
    this.showCustomer = true,
    this.showRate = true,
    this.showTotalQty = true,
    this.showGstSummary = true,
    this.bigTotal = false,
    this.qrMode = QrMode.upiAndCredit,
    this.qrCaption = 'SCAN TO PAY',
    this.footer = 'Thank you for shopping with us!\nVisit again',
  });

  factory ReceiptTemplate.fromJson(String? json) {
    if (json == null || json.isEmpty) return const ReceiptTemplate();
    try {
      final m = jsonDecode(json) as Map<String, Object?>;
      const d = ReceiptTemplate();
      bool b(String k, bool fallback) =>
          m[k] is bool ? m[k]! as bool : fallback;
      String s(String k, String fallback) =>
          m[k] is String ? m[k]! as String : fallback;
      return ReceiptTemplate(
        showLogo: b('showLogo', d.showLogo),
        logoWidthPercent:
            (m['logoWidthPercent'] as num?)?.toInt().clamp(20, 100) ??
            d.logoWidthPercent,
        showShopName: b('showShopName', d.showShopName),
        showPhone: b('showPhone', d.showPhone),
        showAddress: b('showAddress', d.showAddress),
        addressLabel: s('addressLabel', d.addressLabel),
        showGstin: b('showGstin', d.showGstin),
        headerNote: s('headerNote', d.headerNote),
        showBillNo: b('showBillNo', d.showBillNo),
        showCustomer: b('showCustomer', d.showCustomer),
        showRate: b('showRate', d.showRate),
        showTotalQty: b('showTotalQty', d.showTotalQty),
        showGstSummary: b('showGstSummary', d.showGstSummary),
        bigTotal: b('bigTotal', d.bigTotal),
        qrMode: QrMode.values.asNameMap()[m['qrMode']] ?? d.qrMode,
        qrCaption: s('qrCaption', d.qrCaption),
        footer: s('footer', d.footer),
      );
    } on Object {
      return const ReceiptTemplate();
    }
  }

  final bool showLogo;

  /// Logo width as a share of the paper width.
  final int logoWidthPercent;
  final bool showShopName;
  final bool showPhone;
  final bool showAddress;

  /// Printed before the address (`Address: `); may be empty.
  final String addressLabel;

  /// The shop's GSTIN (printed only when the shop has one).
  final bool showGstin;

  /// Extra line(s) under the address, e.g. "No exchange without bill".
  final String headerNote;
  final bool showBillNo;
  final bool showCustomer;

  /// The RATE column; off leaves ITEM, QTY and AMOUNT.
  final bool showRate;
  final bool showTotalQty;

  /// Taxable value and CGST/SGST (or IGST) per rate, for GST bills.
  final bool showGstSummary;

  /// TOTAL in double size.
  final bool bigTotal;
  final QrMode qrMode;
  final String qrCaption;
  final String footer;

  String toJson() => jsonEncode({
    'showLogo': showLogo,
    'logoWidthPercent': logoWidthPercent,
    'showShopName': showShopName,
    'showPhone': showPhone,
    'showAddress': showAddress,
    'addressLabel': addressLabel,
    'showGstin': showGstin,
    'headerNote': headerNote,
    'showBillNo': showBillNo,
    'showCustomer': showCustomer,
    'showRate': showRate,
    'showTotalQty': showTotalQty,
    'showGstSummary': showGstSummary,
    'bigTotal': bigTotal,
    'qrMode': qrMode.name,
    'qrCaption': qrCaption,
    'footer': footer,
  });

  ReceiptTemplate copyWith({
    bool? showLogo,
    int? logoWidthPercent,
    bool? showShopName,
    bool? showPhone,
    bool? showAddress,
    String? addressLabel,
    bool? showGstin,
    String? headerNote,
    bool? showBillNo,
    bool? showCustomer,
    bool? showRate,
    bool? showTotalQty,
    bool? showGstSummary,
    bool? bigTotal,
    QrMode? qrMode,
    String? qrCaption,
    String? footer,
  }) => ReceiptTemplate(
    showLogo: showLogo ?? this.showLogo,
    logoWidthPercent: logoWidthPercent ?? this.logoWidthPercent,
    showShopName: showShopName ?? this.showShopName,
    showPhone: showPhone ?? this.showPhone,
    showAddress: showAddress ?? this.showAddress,
    addressLabel: addressLabel ?? this.addressLabel,
    showGstin: showGstin ?? this.showGstin,
    headerNote: headerNote ?? this.headerNote,
    showBillNo: showBillNo ?? this.showBillNo,
    showCustomer: showCustomer ?? this.showCustomer,
    showRate: showRate ?? this.showRate,
    showTotalQty: showTotalQty ?? this.showTotalQty,
    showGstSummary: showGstSummary ?? this.showGstSummary,
    bigTotal: bigTotal ?? this.bigTotal,
    qrMode: qrMode ?? this.qrMode,
    qrCaption: qrCaption ?? this.qrCaption,
    footer: footer ?? this.footer,
  );

  @override
  bool operator ==(Object other) =>
      other is ReceiptTemplate && other.toJson() == toJson();

  @override
  int get hashCode => toJson().hashCode;
}
