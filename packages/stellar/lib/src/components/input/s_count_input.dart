import 'package:flutter/widgets.dart';

import 's_count_material.dart';

/// How big an [SCountInput] is.
enum CountSize {
  /// A setting among others (per customer).
  regular,

  /// The form's main count, large in the middle (an offer's pieces).
  large,
}

/// A whole number from [min] to [max], bound to the control [controlName]
/// (a `String`) of the enclosing SForm: typed in the middle, or stepped
/// with the round minus and plus around it. For counts that move a little
/// (one more piece) but can jump (50 pieces).
abstract interface class SCountInput implements Widget {
  /// [label] names the number for screen readers; the page shows its own
  /// title above.
  const factory SCountInput({
    required String controlName,
    required String label,
    required int min,
    required int max,
    CountSize size,
    Key? key,
  }) = SCountInputMaterial;
}
