/// Prices come from the backend as strings with 3 decimals ("4.000").
/// Shows them the way Libyans write prices: "4 د.ل", "4.500 د.ل",
/// or "4 LD" in English. Trailing zero dirhams are dropped.
String formatPrice(String amount, {required String languageCode}) {
  final value = double.tryParse(amount);
  final number = value == null
      ? amount
      : value == value.truncateToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '');
  return languageCode == 'ar' ? '$number د.ل' : '$number LD';
}
