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

final _easternDigits = RegExp('[٠-٩]');

/// The price typed in a field, as the backend takes it: "4.5" becomes
/// "4.500". Arabic digits and the Arabic decimal sign (٫) are accepted.
/// Null when it isn't a price above 0 with up to 3 decimals. Only text is
/// rearranged: no number math, so no rounding.
String? parsePrice(String input) {
  final text = input
      .trim()
      .replaceAllMapped(
        _easternDigits,
        (match) => '${match[0]!.codeUnitAt(0) - 0x0660}',
      )
      .replaceAll('٫', '.');
  final match = RegExp(r'^(\d{1,7})(?:\.(\d{0,3}))?$').firstMatch(text);
  if (match == null) return null;
  final whole = match[1]!.replaceFirst(RegExp('^0+(?=.)'), '');
  final dirhams = (match[2] ?? '').padRight(3, '0');
  if (whole == '0' && dirhams == '000') return null;
  return '$whole.$dirhams';
}

/// [price] ("4.500") in dirhams (4500), to compare two prices exactly.
int dirhamsOf(String price) {
  final [whole, ...rest] = price.split('.');
  final dirhams = (rest.isEmpty ? '' : rest.first).padRight(3, '0');
  return int.parse(whole) * 1000 + int.parse(dirhams.substring(0, 3));
}

/// How much cheaper [offer] is than [original], in whole percent, rounded
/// like the backend's: "8.000" → "4.000" is 50. Only for showing it while
/// the price is typed; the backend's number is the one that counts.
int discountPercent({required String original, required String offer}) {
  final full = dirhamsOf(original);
  if (full <= 0) return 0;
  return ((1 - dirhamsOf(offer) / full) * 100).round();
}
