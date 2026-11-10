import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import '../input/s_select_input.dart';
import 's_segment_track_material.dart';
import 's_segmented_material.dart';

/// One choice in an [SSegmented]: its [icon], and the [tooltip] that names
/// it for screen readers.
class SSegment<T> {
  const SSegment({
    required this.value,
    required this.icon,
    required this.tooltip,
  });

  final T value;
  final SIcons icon;
  final String tooltip;
}

/// A segmented button: a few icons side by side in one outlined pill, the
/// chosen one filled in the brand's green: how a list is shown (cards or
/// rows).
abstract interface class SSegmented<T> implements Widget {
  /// [selected] is one of the [segments]' values; [onChanged] gets the one
  /// tapped.
  const factory SSegmented({
    required List<SSegment<T>> segments,
    required T selected,
    required ValueChanged<T> onChanged,
    Key? key,
  }) = SSegmentedMaterial<T>;

  /// Two or three words side by side, as wide as it's given, the chosen one
  /// raised on a gray track: which part of a list shows (current or
  /// archived products). [selected] is one of the [options]' values.
  const factory SSegmented.labels({
    required List<SelectOption<T>> options,
    required T selected,
    required ValueChanged<T> onChanged,
    Key? key,
  }) = SSegmentedLabelsMaterial<T>;
}
