import 'package:flutter/widgets.dart';

/// One end of an [TimeSpanSpec]: "Starts / 11:30 AM / Today".
@immutable
class TimePoint {
  const TimePoint({required this.label, required this.time, this.note});

  final String label;

  /// Already written for people (`formatTime`).
  final String time;

  /// Under [time]: the day.
  final String? note;
}

@immutable
class TimeSpanSpec {
  const TimeSpanSpec({
    required this.start,
    required this.end,
    required this.length,
  });

  final TimePoint start;
  final TimePoint end;
  final String? length;
}

abstract interface class TimeSpanRenderer {
  Widget render(BuildContext context, TimeSpanSpec spec);
}
