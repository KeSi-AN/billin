import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';

part 'app_settings.freezed.dart';

enum PaperWidth {
  mm58(58, 32),
  mm80(80, 48);

  PaperWidth(this.mm, this.charsPerLine);

  final int mm;

  /// Characters per line in the printer's standard font (Font A).
  final int charsPerLine;

  static PaperWidth fromMm(int mm) => mm >= 80 ? mm80 : mm58;
}

@freezed
abstract class AppSettingsData with _$AppSettingsData {
  const factory AppSettingsData({
    @Default(InvoiceNumber.defaultPrefix) String invoicePrefix,
    @Default(true) bool roundToRupee,

    /// Shop's UPI ID (e.g. `shop@okaxis`). Enables a pay-by-UPI QR on bills.
    String? upiId,
    String? receiptFooter,
    String? printerAddress,
    String? printerName,
    @Default(PaperWidth.mm58) PaperWidth paperWidth,
  }) = _AppSettingsData;
}

abstract interface class SettingsRepository {
  Stream<AppSettingsData> watch();

  Future<AppSettingsData> load();

  Future<void> save(AppSettingsData settings);
}

/// Loose UPI ID check: `name@bank`.
bool isValidUpiId(String value) =>
    RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$').hasMatch(value.trim());
