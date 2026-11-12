/// A GST rate in **basis points** (1800 = 18%, 25 = 0.25%).
extension type const TaxRate(int bp) {
  static const zero = TaxRate(0);

  /// Rates offered in pickers. 5% and 18% are the main slabs since the
  /// September 2025 GST rationalisation; 40% is the new demerit rate. 12% and
  /// 28% stay available for goods still taxed at them.
  static const choices = <TaxRate>[
    TaxRate(0),
    TaxRate(500),
    TaxRate(1800),
    TaxRate(4000),
    TaxRate(1200),
    TaxRate(2800),
    TaxRate(300),
    TaxRate(25),
  ];

  bool get isZero => bp == 0;

  /// `18%`, `0.25%`, `0%`.
  String get label {
    final whole = bp ~/ 100;
    final fraction = bp % 100;
    if (fraction == 0) return '$whole%';
    final digits = fraction.toString().padLeft(2, '0').replaceFirst(
      RegExp(r'0$'),
      '',
    );
    return '$whole.$digits%';
  }

  /// Half the rate, for CGST and SGST labels: `9%`, `2.5%`.
  String get halfLabel => TaxRate(bp ~/ 2).label;
}
