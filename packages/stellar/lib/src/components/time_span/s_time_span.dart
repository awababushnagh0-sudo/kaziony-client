import 'package:flutter/widgets.dart';

import 's_time_span_material.dart';

/// One end of an [STimeSpan]: "Starts / 11:30 AM / Today".
@immutable
class TimePoint {
  const TimePoint({required this.label, required this.time, this.note});

  final String label;

  /// Already written for people (`formatTime`).
  final String time;

  /// Under [time]: the day.
  final String? note;
}

/// When something runs, read across: the [start] in big figures, a dashed
/// line with how [length] it lasts, and the [end].
abstract interface class STimeSpan implements Widget {
  /// [length] goes over the line: "9 h 30 min".
  const factory STimeSpan({
    required TimePoint start,
    required TimePoint end,
    String? length,
    Key? key,
  }) = STimeSpanMaterial;
}
