import 'package:flutter/widgets.dart';

/// One choice in a [ChoiceSheetSpec].
@immutable
class SheetOption<T> {
  const SheetOption({required this.value, required this.label});

  final T value;
  final String label;
}

@immutable
class ChoiceSheetSpec<T> {
  const ChoiceSheetSpec({
    required this.title,
    required this.options,
    required this.selected,
  });

  final String title;
  final List<SheetOption<T>> options;

  /// The current choice, marked with a check.
  final T? selected;
}

abstract interface class SheetRenderer {
  /// Shows the choices from the bottom of the screen. Completes with the
  /// one tapped, or null when the sheet is closed without a choice.
  Future<T?> choose<T>(BuildContext context, ChoiceSheetSpec<T> spec);
}
