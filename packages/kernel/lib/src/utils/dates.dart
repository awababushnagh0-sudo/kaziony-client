import 'package:intl/intl.dart';

/// A day the way people write it, in their language: "Oct 19, 2026" or
/// "19 أكتوبر 2026". Shown in the device's time zone.
String formatDate(DateTime date, {required String languageCode}) =>
    _western(DateFormat.yMMMd(languageCode)).format(date.toLocal());

/// A day with its weekday, for a page about that day: "Tuesday, October 28"
/// or "الثلاثاء، 28 أكتوبر". Shown in the device's time zone.
String formatDay(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMMEEEEd(languageCode)).format(date.toLocal());

/// A day in a few words, for under a time: "Sat, Oct 31" or
/// "السبت، 31 أكتوبر". Shown in the device's time zone.
String formatShortDay(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMEd(languageCode)).format(date.toLocal());

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
  return isSameDay(date, now ?? DateTime.now())
      ? formatTime(date, languageCode: languageCode)
      : formatDateTime(date, languageCode: languageCode);
}

/// Whether [a] and [b] fall on the same day in the device's time zone.
bool isSameDay(DateTime a, DateTime b) {
  final x = a.toLocal();
  final y = b.toLocal();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

/// Libya writes 0-9, as the app's prices and counts do, not Arabic's own
/// digits (٠-٩) that Flutter's Arabic dates would use.
DateFormat _western(DateFormat format) => format..useNativeDigits = false;
