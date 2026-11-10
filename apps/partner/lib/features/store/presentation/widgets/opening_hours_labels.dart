import 'package:kernel/kernel.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';

/// [day]'s name in the app's language: "Saturday" or "السبت".
String weekdayName(BuildContext context, Weekday day) => formatWeekday(
  // January 3, 2026 was a Saturday: the days from it run as [Weekday] does.
  DateTime(2026, 1, 3 + day.index),
  languageCode: Localizations.localeOf(context).languageCode,
);

/// [minutes] after midnight as a time in the app's language: "8:30 AM" or
/// "8:30 ص".
String clockLabel(BuildContext context, int minutes) => formatTime(
  DateTime(2026, 1, 1, minutes ~/ 60, minutes % 60),
  languageCode: Localizations.localeOf(context).languageCode,
);

/// What a day's [shifts] say: "9:00 AM – 10:00 PM" (with a comma between
/// shifts), "Closed", or "Not set" when the day isn't set (null).
String dayHoursLabel(BuildContext context, List<OpeningShift>? shifts) {
  final s = PartnerLocalizations.of(context);
  return switch (shifts) {
    null => s.notSet,
    [] => s.closedAllDay,
    _ => [
      for (final shift in shifts)
        s.shiftHours(
          clockLabel(context, shift.opens),
          clockLabel(context, shift.closes),
        ),
    ].join(s.listSeparator),
  };
}
