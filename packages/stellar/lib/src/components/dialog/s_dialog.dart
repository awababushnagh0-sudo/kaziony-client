import 'package:flutter/widgets.dart';

import 's_dialog_material.dart';

/// A dialog with a title bar, a scrolling [body] and a footer with Cancel
/// and [primaryLabel]. Open it with [SDialog.show].
abstract interface class SDialog implements Widget {
  /// [primaryLabel] is the main button; no footer without it. [busy]
  /// disables the buttons and closing while the action runs.
  const factory SDialog({
    required String title,
    required Widget body,
    String? primaryLabel,
    VoidCallback? onPrimary,
    bool busy,
    bool showCancel,
    double width,
    Key? key,
  }) = SDialogMaterial;

  /// Opens a dialog (usually an [SDialog]) and returns what it pops with.
  static Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  }) => SDialogMaterial.show<T>(context, builder, dismissible: dismissible);

  /// Asks the user to confirm an action. Returns true if they did.
  /// [cancelLabel] names the way back when "Cancel" would read like the
  /// action itself ("Keep it" beside "Cancel reservation").
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) => SDialogMaterial.confirm(
    context,
    title: title,
    message: message,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
    destructive: destructive,
  );
}
