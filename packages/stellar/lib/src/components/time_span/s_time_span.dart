import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_time_span_renderer.dart';

/// When something runs, read across: the [start] in big figures, a dashed
/// line with how [length] it lasts, and the [end].
class STimeSpan extends StatelessWidget {
  const STimeSpan({
    required this.start,
    required this.end,
    this.length,
    super.key,
  });

  final TimePoint start;
  final TimePoint end;

  /// Over the line: "9 h 30 min".
  final String? length;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).timeSpan
      .render(context, TimeSpanSpec(start: start, end: end, length: length));
}
