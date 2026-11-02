import 'package:flutter/widgets.dart';

import 's_input_material.dart';

/// What a text input holds, which picks its keyboard, direction and the
/// characters it lets in.
enum TextInputKind {
  text,
  phone,
  password,
  number,

  /// LD with up to 3 decimals ("4.500"); check it with
  /// `SValidators.price` and read it with kernel's `parsePrice`.
  price,
  email,
  url,
  multiline,

  /// A code read off a screen or paper (a reservation code): capital
  /// letters and digits, left to right, without the keyboard's suggestions.
  code,
}

/// A text field bound to the control [controlName] of the enclosing
/// SForm. Common validation errors get translated messages
/// automatically; pass [validationMessages] for custom ones.
abstract interface class STextInput implements Widget {
  /// [isLast] makes the keyboard show "done" instead of "next".
  /// [required] shows a red asterisk by the label; add
  /// `Validators.required` too. [helper] is a quiet line under the field
  /// explaining what to enter.
  const factory STextInput({
    required String controlName,
    required String label,
    String? hint,
    TextInputKind kind,
    bool isLast,
    VoidCallback? onSubmitted,
    Iterable<String>? autofillHints,
    int? maxLength,
    Map<String, String Function(Object error)> validationMessages,
    bool required,
    String? helper,
    bool autofocus,
    Key? key,
  }) = STextInputMaterial;
}
