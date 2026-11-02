import 'package:flutter/widgets.dart';

import 's_code_material.dart';

/// A code typed one character to a box, in capitals, left to right in
/// Arabic too (a pickup code read out by the customer). Bound to a control
/// in the enclosing SForm.
abstract interface class SCodeInput implements Widget {
  /// [controlName] names the control in the enclosing SForm. [label] is
  /// read out for the field; it's not shown.
  ///
  /// [characters] matches one character a code can have (in capitals):
  /// others can't be typed, so look-alikes like 0 and O never get in.
  /// [groupOf] puts a wider gap after every this many boxes.
  /// [onSubmitted] is the keyboard's "go".
  const factory SCodeInput({
    required String controlName,
    required String label,
    required int length,
    required RegExp characters,
    int groupOf,
    bool autofocus,
    VoidCallback? onSubmitted,
    Key? key,
  }) = SCodeInputMaterial;
}
