import 'package:flutter/widgets.dart';

import 's_countdown_material.dart';

/// The time left for something held (a booking to pick up): a small
/// [label] over the [time] in big green figures, which turn orange once
/// little is left.
abstract interface class SCountdown implements Widget {
  /// [time] comes written ("47:08"); [left] of [total] says how little
  /// is left.
  const factory SCountdown({
    required String label,
    required String time,
    required Duration left,
    required Duration total,
    Key? key,
  }) = SCountdownMaterial;

  /// Smaller, on a soft strip, for a list where the big one would be too
  /// much: a clock and the [label] over the [detail] at the start ("Left
  /// to pick up" over "Pick up before 1:53 AM"), and the [time] counting
  /// down at the end, in a pill. Green while there's time, light red once
  /// [urgent]. Without [time] (nothing to count, only a day), just the
  /// words.
  const factory SCountdown.strip({
    required String label,
    required String detail,
    String? time,
    bool urgent,
    Key? key,
  }) = SCountdownStripMaterial;
}
