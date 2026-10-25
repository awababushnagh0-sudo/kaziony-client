import 'package:flutter/widgets.dart';

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
}

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
/// One of a few values, as pills, bound to a form control.
@immutable
class ChoiceInputSpec<T> {
  const ChoiceInputSpec({
    required this.controlName,
    required this.label,
    required this.options,
    this.onChanged,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;
  final ValueChanged<T>? onChanged;
}

/// A ready-made answer for a date and time field ("Tonight").
@immutable
class DateTimePreset {
  const DateTimePreset(this.label, this.value);

  final String label;
  final DateTime value;
}

/// A day and time picked with the phone's calendar and clock, bound to a
/// form control of [DateTime].
@immutable
class DateTimeInputSpec {
  const DateTimeInputSpec({
    required this.controlName,
    required this.label,
    required this.validationMessages,
    required this.firstDate,
    required this.lastDate,
    this.presets = const [],
    this.helper,
  });

  final String controlName;
  final String label;
  final Map<String, String Function(Object error)> validationMessages;
  final DateTime firstDate;
  final DateTime lastDate;
  final List<DateTimePreset> presets;
  final String? helper;
}

abstract interface class InputRenderer {
  Widget text(BuildContext context, TextInputSpec spec);
  Widget select<T>(BuildContext context, SelectInputSpec<T> spec);
  Widget search(BuildContext context, SearchFieldSpec spec);
  Widget choice<T>(BuildContext context, ChoiceInputSpec<T> spec);
  Widget dateTime(BuildContext context, DateTimeInputSpec spec);
}
