import 'package:flutter/widgets.dart';

import 's_input_material.dart';
import 's_select_input.dart';

/// One of a few values (limited or unlimited), as pills, bound to the
/// control [controlName] of the enclosing SForm.
abstract interface class SChoiceInput<T> implements Widget {
  /// [onChanged] is for screens that show other fields depending on the
  /// choice.
  const factory SChoiceInput({
    required String controlName,
    required String label,
    required List<SelectOption<T>> options,
    ValueChanged<T>? onChanged,
    Key? key,
  }) = SChoiceInputMaterial<T>;
}
