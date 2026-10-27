import 'package:intl/intl.dart';

/// A day the way people write it, in their language: "Oct 19, 2026" or
/// "19 أكتوبر 2026". Shown in the device's time zone.
String formatDate(DateTime date, {required String languageCode}) =>
    _western(DateFormat.yMMMd(languageCode)).format(date.toLocal());

/// A day and time the way people write it, in their language:
/// "Tue, Oct 28 11:00 PM" or "الثلاثاء، 28 أكتوبر 11:00 م". Shown in the
/// device's time zone.
String formatDateTime(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMEd(languageCode).add_jm()).format(date.toLocal());

/// A time the way people write it, in their language: "11:00 PM" or
/// "11:00 م". Shown in the device's time zone.
String formatTime(DateTime date, {required String languageCode}) =>
    _western(DateFormat.jm(languageCode)).format(date.toLocal());

/// Just the time when [date] falls today ([now] in tests), otherwise its
/// day and time: for what's due within hours, like a reservation.
String formatWhen(
  DateTime date, {
  required String languageCode,
  DateTime? now,
}) {
  final local = date.toLocal();
  final today = (now ?? DateTime.now()).toLocal();
  final sameDay =
      local.year == today.year &&
      local.month == today.month &&
      local.day == today.day;
  return sameDay
      ? formatTime(date, languageCode: languageCode)
      : formatDateTime(date, languageCode: languageCode);
}

/// Libya writes 0-9, as the app's prices and counts do, not Arabic's own
/// digits (٠-٩) that Flutter's Arabic dates would use.
DateFormat _western(DateFormat format) => format..useNativeDigits = false;
