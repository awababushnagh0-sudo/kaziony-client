import 'package:flutter/widgets.dart';

enum TextInputKind { text, phone, password, number, email, url, multiline }

@immutable
class TextInputSpec {
  const TextInputSpec({
    required this.controlName,
    required this.label,
    required this.validationMessages,
    this.hint,
    this.kind = TextInputKind.text,
    this.isLast = false,
    this.onSubmitted,
    this.autofillHints,
    this.maxLength,
    this.required = false,
    this.helper,
    this.autofocus = false,
  });

  /// Name of the control in the enclosing SForm.
  final String controlName;
  final String label;
  final String? hint;
  final TextInputKind kind;

  /// Error text per validation error key ("required", "minLength", ...).
  final Map<String, String Function(Object error)> validationMessages;

  /// The keyboard shows "done" instead of "next".
  final bool isLast;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;
  final int? maxLength;

  /// Marks the label with a red asterisk (the validators still decide).
  final bool required;

  /// A quiet line under the field explaining what to enter.
  final String? helper;
  final bool autofocus;
}

@immutable
class SelectOption<T> {
  const SelectOption(this.value, this.label);

  final T value;
  final String label;
}

/// A dropdown bound to a form control, labelled like a text input.
@immutable
class SelectInputSpec<T> {
  const SelectInputSpec({
    required this.controlName,
    required this.label,
    required this.options,
    required this.validationMessages,
    this.hint,
    this.required = false,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;
  final Map<String, String Function(Object error)> validationMessages;
  final String? hint;
  final bool required;
}

/// A search box that is not part of a form (above lists).
@immutable
class SearchFieldSpec {
  const SearchFieldSpec({
    required this.hint,
    required this.onChanged,
    this.initialValue = '',
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final String initialValue;
}

/// Draws every kind of input: text fields, dropdowns and search boxes.
abstract interface class InputRenderer {
  Widget text(BuildContext context, TextInputSpec spec);
  Widget select<T>(BuildContext context, SelectInputSpec<T> spec);
  Widget search(BuildContext context, SearchFieldSpec spec);
}
