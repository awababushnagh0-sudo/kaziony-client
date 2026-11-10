import 'package:flutter/services.dart';

/// Arabic digits from an Arabic keyboard, as the Western ones the apps
/// keep and the server reads.
String _western(String text) => text.replaceAllMapped(
  RegExp('[٠-٩]'),
  (match) => '${match[0]!.codeUnitAt(0) - 0x0660}',
);

/// Keeps [value] when it's already clean, so the cursor stays where it was;
/// otherwise puts the cleaned [text] in with the cursor at its end.
TextEditingValue _cleaned(TextEditingValue value, String text) =>
    text == value.text
    ? value
    : TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );

/// An amount of money as it's typed: digits and one decimal point, with 3
/// decimals at most (dinars and dirhams). Arabic digits and the Arabic
/// decimal sign become Western ones.
final moneyFormatter = TextInputFormatter.withFunction((oldValue, value) {
  final typed = _western(value.text)
      .replaceAll(RegExp('[٫,]'), '.')
      .replaceAll(RegExp('[^0-9.]'), '');
  final point = typed.indexOf('.');
  if (point < 0) {
    return typed.length > _wholeDigits ? oldValue : _cleaned(value, typed);
  }
  final whole = typed.substring(0, point);
  final decimals = typed.substring(point + 1).replaceAll('.', '');
  if (whole.length > _wholeDigits) return oldValue;
  return _cleaned(
    value,
    '$whole.${decimals.length > 3 ? decimals.substring(0, 3) : decimals}',
  );
});

/// [moneyFormatter] that also turns away what would reach [limit] (an
/// amount, "8.000"; none while it's null), telling [onRefused].
TextInputFormatter moneyUnder(
  String? Function() limit, {
  required VoidCallback onRefused,
}) => TextInputFormatter.withFunction((oldValue, value) {
  final typed = moneyFormatter.formatEditUpdate(oldValue, value);
  final most = limit();
  final under = most == null ? null : _dirhams(most);
  final amount = _dirhams(typed.text);
  if (under != null && amount != null && amount >= under) {
    onRefused();
    return oldValue;
  }
  return typed;
});

/// An amount ("7.5") in dirhams (7500), to compare two exactly; null when
/// it isn't one.
int? _dirhams(String amount) {
  final match = RegExp(r'^(\d+)(?:\.(\d{0,3}))?$').firstMatch(amount);
  if (match == null) return null;
  final decimals = (match[2] ?? '').padRight(3, '0');
  return int.parse(match[1]!) * 1000 + int.parse(decimals);
}

/// A whole number as it's typed: digits only, Arabic ones as Western.
final wholeNumberFormatter = TextInputFormatter.withFunction((oldValue, value) {
  final typed = _western(value.text).replaceAll(RegExp('[^0-9]'), '');
  return typed.length > _wholeDigits ? oldValue : _cleaned(value, typed);
});

/// Room for 99,999: more than any price or count the apps take.
const _wholeDigits = 5;
