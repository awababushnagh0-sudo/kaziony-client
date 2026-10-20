final _arabicDigits = RegExp('[٠-٩]');

/// Normalizes a Libyan mobile number to E.164 (+2189XXXXXXXX), like the
/// backend does. Accepts 0912345678, +218 91 234 5678, Arabic digits, ...
/// Returns null if it isn't a valid Libyan mobile number.
String? normalizeLibyanPhone(String input) {
  final digits = input
      .replaceAllMapped(
        _arabicDigits,
        (m) => String.fromCharCode(m[0]!.codeUnitAt(0) - 0x0660 + 0x30),
      )
      .replaceAll(RegExp(r'[\s\-().]'), '')
      .replaceFirst(RegExp(r'^\+'), '')
      .replaceFirst(RegExp('^00'), '');

  final String national;
  if (RegExp(r'^2189\d{8}$').hasMatch(digits)) {
    national = digits.substring(3);
  } else if (RegExp(r'^09\d{8}$').hasMatch(digits)) {
    national = digits.substring(1);
  } else if (RegExp(r'^9\d{8}$').hasMatch(digits)) {
    national = digits;
  } else {
    return null;
  }
  return '+218$national';
}

/// 0912345678 for display, from +218912345678.
String formatLibyanPhone(String e164) =>
    e164.startsWith('+218') ? '0${e164.substring(4)}' : e164;
