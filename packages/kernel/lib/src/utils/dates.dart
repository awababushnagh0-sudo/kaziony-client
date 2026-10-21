import 'package:intl/intl.dart';

/// A day the way people write it, in their language: "Oct 19, 2026" or
/// "١٩ أكتوبر ٢٠٢٦". Shown in the device's time zone.
String formatDate(DateTime date, {required String languageCode}) =>
    DateFormat.yMMMd(languageCode).format(date.toLocal());
