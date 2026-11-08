import 'package:flutter/widgets.dart';

import 's_timeline_material.dart';

/// One stop on an [STimeline].
@immutable
class TimelineEntry {
  const TimelineEntry({
    required this.time,
    required this.title,
    required this.onTap,
    this.period,
    this.subtitle,
    this.trailing,
    this.hot = false,
  });

  /// Already written for people ("3:12").
  final String time;

  /// Smaller, under [time] ("PM").
  final String? period;
  final String title;
  final String? subtitle;

  /// At the row's end (an `STag`).
  final Widget? trailing;

  /// Due soon: the time and the dot turn orange.
  final bool hot;
  final VoidCallback onTap;
}

/// What's coming, in order, like a day in a calendar: each stop's time at
/// the start, a line with a dot joining them, then its words. It runs to the
/// page's edges and keeps the page's sides inside.
abstract interface class STimeline implements Widget {
  const factory STimeline(List<TimelineEntry> entries, {Key? key}) =
      STimelineMaterial;
}
