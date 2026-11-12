/// Integer division rounded to the nearest whole number, halves away from
/// zero (the usual "commercial" rounding: 2.5 → 3, -2.5 → -3).
int divRound(int numerator, int denominator) {
  assert(denominator > 0, 'denominator must be positive');
  if (numerator >= 0) {
    return (2 * numerator + denominator) ~/ (2 * denominator);
  }
  return -((2 * -numerator + denominator) ~/ (2 * denominator));
}
