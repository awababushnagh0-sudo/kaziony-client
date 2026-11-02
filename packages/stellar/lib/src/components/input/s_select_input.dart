import 'package:flutter/widgets.dart';

import 's_select_material.dart';

/// One of the values an [SSelectInput] or an SChoiceInput offers, with
/// what it says.
@immutable
class SelectOption<T> {
  const SelectOption(this.value, this.label);

  final T value;
  final String label;
}

/// A dropdown bound to the control [controlName] of the enclosing SForm.
abstract interface class SSelectInput<T> implements Widget {
  const factory SSelectInput({
    required String controlName,
    required String label,
    required List<SelectOption<T>> options,
    String? hint,
    bool required,
    Key? key,
  }) = SSelectInputMaterial<T>;
}
