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
}
