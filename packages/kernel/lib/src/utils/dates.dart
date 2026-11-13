import 'package:intl/intl.dart';

import '../time/libya_time.dart';
import '../time/server_clock.dart';

/// A day the way people write it, in their language: "Oct 19, 2026" or
/// "19 أكتوبر 2026". In Libya time.
String formatDate(DateTime date, {required String languageCode}) =>
    _western(DateFormat.yMMMd(languageCode)).format(libyaClock(date));

/// A day with its weekday, for a page about that day: "Tuesday, October 28"
/// or "الثلاثاء، 28 أكتوبر". In Libya time.
String formatDay(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMMEEEEd(languageCode)).format(libyaClock(date));

/// A weekday by its name, for a day in the coming week: "Thursday" or
/// "الخميس". In Libya time.
String formatWeekday(DateTime date, {required String languageCode}) =>
    _western(DateFormat.EEEE(languageCode)).format(libyaClock(date));

/// A day of the year without its weekday: "Nov 9" or "9 نوفمبر". In Libya
/// time.
String formatDayMonth(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMd(languageCode)).format(libyaClock(date));

/// A day in a few words, for under a time: "Sat, Oct 31" or
/// "السبت، 31 أكتوبر". In Libya time.
String formatShortDay(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMEd(languageCode)).format(libyaClock(date));

/// A day and time the way people write it, in their language:
/// "Tue, Oct 28 11:00 PM" or "الثلاثاء، 28 أكتوبر 11:00 م". In Libya
/// time.
String formatDateTime(DateTime date, {required String languageCode}) =>
    _western(DateFormat.MMMEd(languageCode).add_jm()).format(libyaClock(date));

/// A time the way people write it, in their language: "11:00 PM" or
/// "11:00 م". In Libya time.
String formatTime(DateTime date, {required String languageCode}) =>
    _western(DateFormat.jm(languageCode)).format(libyaClock(date));

/// [formatTime] in two parts, to set them apart: "3:12" and "PM".
({String clock, String period}) formatTimeParts(
  DateTime date, {
  required String languageCode,
}) {
  final local = libyaClock(date);
  return (
    clock: _western(DateFormat('h:mm', languageCode)).format(local),
    period: DateFormat('a', languageCode).format(local),
  );
}

/// Just the time when [date] falls today ([now] in tests), otherwise its
/// day and time: for what's due within hours, like a reservation.
String formatWhen(
  DateTime date, {
  required String languageCode,
  DateTime? now,
}) {
  return isSameDay(date, now ?? ServerClock.now())
      ? formatTime(date, languageCode: languageCode)
      : formatDateTime(date, languageCode: languageCode);
}

/// Whether [a] and [b] fall on the same day in Libya.
bool isSameDay(DateTime a, DateTime b) {
  final x = libyaClock(a);
  final y = libyaClock(b);
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

/// Libya writes 0-9, as the app's prices and counts do, not Arabic's own
/// digits (٠-٩) that Flutter's Arabic dates would use.
DateFormat _western(DateFormat format) => format..useNativeDigits = false;
