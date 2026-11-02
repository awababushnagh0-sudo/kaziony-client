import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
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

/// One of the ways forward an [ActionSheetSpec] offers.
@immutable
class SheetAction<T> {
  const SheetAction({
    required this.value,
    required this.icon,
    required this.label,
    this.hint,
  });

  final T value;
  final SIcons icon;
  final String label;

  /// What it leads to, under [label].
  final String? hint;
}

@immutable
class ActionSheetSpec<T> {
  const ActionSheetSpec({
    required this.title,
    required this.actions,
    this.subtitle,
  });

  final String title;
  final List<SheetAction<T>> actions;

  /// A line under [title].
  final String? subtitle;
}

/// A sheet with its own content under a title (a form of a few fields).
@immutable
class ContentSheetSpec {
  const ContentSheetSpec({
    required this.title,
    required this.builder,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  /// Built in the sheet's context, so it can close the sheet.
  final WidgetBuilder builder;
}

abstract interface class SheetRenderer {
  /// Shows the choices from the bottom of the screen. Completes with the
  /// one tapped, or null when the sheet is closed without a choice.
  Future<T?> choose<T>(BuildContext context, ChoiceSheetSpec<T> spec);

  /// Shows the ways forward from the bottom of the screen, as big rows.
  /// Completes with the one tapped, or null when the sheet is closed.
  Future<T?> actions<T>(BuildContext context, ActionSheetSpec<T> spec);

  /// Shows [ContentSheetSpec.builder]'s content from the bottom of the
  /// screen. Completes with what it closes the sheet with.
  Future<T?> content<T>(BuildContext context, ContentSheetSpec spec);
}
