import 'package:flutter/widgets.dart';

import 's_calendar_material.dart';

/// A run of days, [first] to [last] both included, each at its midnight.
typedef DayRange = ({DateTime first, DateTime last});

/// The phone's calendar, over the page.
abstract final class SCalendar {
  /// Lets the user pick a run of days between [firstDate] and [lastDate]
  /// (a holiday, Ramadan), starting from [initial] when given. [title]
  /// says what they're for. Completes with them, or null when closed.
  static Future<DayRange?> pickDays(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
    DayRange? initial,
    String? title,
  }) => SCalendarMaterial.pickDays(
    context,
    firstDate: firstDate,
    lastDate: lastDate,
    initial: initial,
    title: title,
  );
}
