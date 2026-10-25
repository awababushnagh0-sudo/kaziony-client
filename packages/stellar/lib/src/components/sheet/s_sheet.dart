import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_sheet_renderer.dart';

/// Sheets that slide up from the bottom of the screen.
abstract final class SSheet {
  /// Lets the user pick one of [options] (a language, a sort order).
  /// Completes with the one tapped, or null when the sheet is closed.
  static Future<T?> choose<T>(
    BuildContext context, {
    required String title,
    required List<SheetOption<T>> options,
    T? selected,
  }) => StellarKit.of(context).sheet.choose(
    context,
    ChoiceSheetSpec(title: title, options: options, selected: selected),
  );
}
