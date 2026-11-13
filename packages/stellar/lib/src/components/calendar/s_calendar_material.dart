import 'package:flutter/material.dart';

import 's_calendar.dart';

/// Draws [SCalendar] with Material's date range picker.
abstract final class SCalendarMaterial {
  static Future<DayRange?> pickDays(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
    DayRange? initial,
    String? title,
  }) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initial == null
          ? null
          : DateTimeRange(start: initial.first, end: initial.last),
      helpText: title,
    );
    if (picked == null) return null;
    return (
      first: DateUtils.dateOnly(picked.start),
      last: DateUtils.dateOnly(picked.end),
    );
  }
}
