/// An Indian state or union territory with its GST state code.
///
/// The code is the first two digits of a GSTIN and decides CGST+SGST
/// (same state) vs IGST (different state) on invoices.
class IndianState {
  const IndianState(this.code, this.name);

  final String code;
  final String name;
}

/// GST state codes, sorted by name for pickers.
///
/// Code 25 (Daman and Diu) merged into 26 in 2020 and code 28 (old Andhra
/// Pradesh) is no longer issued, so neither is offered.
const indianStates = <IndianState>[
  IndianState('35', 'Andaman and Nicobar Islands'),
  IndianState('37', 'Andhra Pradesh'),
  IndianState('12', 'Arunachal Pradesh'),
  IndianState('18', 'Assam'),
  IndianState('10', 'Bihar'),
  IndianState('04', 'Chandigarh'),
  IndianState('22', 'Chhattisgarh'),
  IndianState('26', 'Dadra and Nagar Haveli and Daman and Diu'),
  IndianState('07', 'Delhi'),
  IndianState('30', 'Goa'),
  IndianState('24', 'Gujarat'),
  IndianState('06', 'Haryana'),
  IndianState('02', 'Himachal Pradesh'),
  IndianState('01', 'Jammu and Kashmir'),
  IndianState('20', 'Jharkhand'),
  IndianState('29', 'Karnataka'),
  IndianState('32', 'Kerala'),
  IndianState('38', 'Ladakh'),
  IndianState('31', 'Lakshadweep'),
  IndianState('23', 'Madhya Pradesh'),
  IndianState('27', 'Maharashtra'),
  IndianState('14', 'Manipur'),
  IndianState('17', 'Meghalaya'),
  IndianState('15', 'Mizoram'),
  IndianState('13', 'Nagaland'),
  IndianState('21', 'Odisha'),
  IndianState('34', 'Puducherry'),
  IndianState('03', 'Punjab'),
  IndianState('08', 'Rajasthan'),
  IndianState('11', 'Sikkim'),
  IndianState('33', 'Tamil Nadu'),
  IndianState('36', 'Telangana'),
  IndianState('16', 'Tripura'),
  IndianState('09', 'Uttar Pradesh'),
  IndianState('05', 'Uttarakhand'),
  IndianState('19', 'West Bengal'),
];

IndianState? stateByCode(String? code) {
  for (final state in indianStates) {
    if (state.code == code) return state;
  }
  return null;
}
