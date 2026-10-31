import 'package:flutter/widgets.dart';

import '../illustration/s_illustration_renderer.dart';
import '../list_tile/s_list_tile_renderer.dart';

@immutable
class ChoiceSheetSpec<T> {
  const ChoiceSheetSpec({
    required this.title,
    required this.options,
    required this.selected,
    this.subtitle,
    this.illustration,
  });

  final String title;
  final List<RadioOption<T>> options;

  /// The current choice, marked with a check.
  final T? selected;

  /// A line under [title] on what the choice changes.
  final String? subtitle;

  /// One of the brand's pictures above [title].
  final Illustration? illustration;
}

abstract interface class SheetRenderer {
  /// Shows the choices from the bottom of the screen. Completes with the
  /// one tapped, or null when the sheet is closed without a choice.
  Future<T?> choose<T>(BuildContext context, ChoiceSheetSpec<T> spec);
}
