import 'package:flutter/widgets.dart';

import 's_bar_chart_material.dart';

/// One bar of an [SBarChart].
@immutable
class ChartBar {
  const ChartBar({required this.value, this.alert = 0, this.label});

  /// Its height, against the tallest bar of the chart.
  final double value;

  /// The part of [value] that went wrong (errors), red at the bar's foot.
  final double alert;

  /// What the bar stands for ("10:42 · 120 requests"), shown on hover.
  final String? label;
}

/// Bars side by side over time (requests per minute), the tallest one
/// reaching the top, from the start side to the end side.
abstract interface class SBarChart implements Widget {
  /// [summary] describes the whole chart for screen readers, which skip
  /// the bars. [startLabel] and [endLabel] sit under the first and the
  /// last bar ("60 min ago", "Now").
  const factory SBarChart({
    required List<ChartBar> bars,
    required String summary,
    String? startLabel,
    String? endLabel,
    Key? key,
  }) = SBarChartMaterial;
}
