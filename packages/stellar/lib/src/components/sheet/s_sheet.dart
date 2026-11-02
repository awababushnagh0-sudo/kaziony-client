import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../illustration/s_illustration_renderer.dart';
import '../list_tile/s_list_tile_renderer.dart';
import 's_sheet_renderer.dart';

/// Sheets that slide up from the bottom of the screen.
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
  }) => StellarKit.of(context).sheet.choose(
    context,
    ChoiceSheetSpec(
      title: title,
      options: options,
      selected: selected,
      subtitle: subtitle,
      illustration: illustration,
    ),
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
  }) => StellarKit.of(context).sheet.actions(
    context,
    ActionSheetSpec(title: title, actions: actions, subtitle: subtitle),
  );

  /// Shows what [builder] makes under a [title], from the bottom of the
  /// screen (how many pieces to reserve). Completes with what the content
  /// closes the sheet with (`Navigator.pop`), or null.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    String? subtitle,
  }) => StellarKit.of(context).sheet.content<T>(
    context,
    ContentSheetSpec(title: title, subtitle: subtitle, builder: builder),
  );
}
