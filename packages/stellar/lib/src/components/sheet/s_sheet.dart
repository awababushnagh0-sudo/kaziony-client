import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import '../illustration/s_illustration.dart';
import '../list_tile/s_radio_group.dart';
import 's_sheet_material.dart';

/// One of the ways forward [SSheet.actions] offers.
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

/// Sheets that slide up from the bottom of the screen, each with a grabber
/// and a close button at the top.
abstract final class SSheet {
  /// Lets the user pick one of [options] (a language, a sort order).
  /// Completes with the one tapped, or null when the sheet is closed.
  ///
  /// [subtitle] says what the choice changes; [illustration] puts one of
  /// the brand's pictures above the title.
  static Future<T?> choose<T>(
    BuildContext context, {
    required String title,
    required List<RadioOption<T>> options,
    T? selected,
    String? subtitle,
    Illustration? illustration,
  }) => SSheetMaterial.choose(
    context,
    title: title,
    options: options,
    selected: selected,
    subtitle: subtitle,
    illustration: illustration,
  );

  /// Asks which way to go on ("from a product, or something new?"), each
  /// way a big row with its icon, [SheetAction.label] and
  /// [SheetAction.hint]. Completes with the one tapped, or null when the
  /// sheet is closed.
  static Future<T?> actions<T>(
    BuildContext context, {
    required String title,
    required List<SheetAction<T>> actions,
    String? subtitle,
  }) => SSheetMaterial.actions(
    context,
    title: title,
    actions: actions,
    subtitle: subtitle,
  );

  /// Shows what [builder] makes under a [title], from the bottom of the
  /// screen (how many pieces to reserve). Completes with what the content
  /// closes the sheet with (`Navigator.pop`), or null.
  ///
  /// [illustration] puts one of the brand's pictures above the title.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    String? subtitle,
    Illustration? illustration,
  }) => SSheetMaterial.show<T>(
    context,
    title: title,
    builder: builder,
    subtitle: subtitle,
    illustration: illustration,
  );
}
