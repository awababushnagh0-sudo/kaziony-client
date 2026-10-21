import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import 's_dialog_renderer.dart';

/// A dialog with a title bar, a scrolling [body] and a footer with Cancel
/// and [primaryLabel]. Open it with [SDialog.show].
class SDialog extends StatelessWidget {
  const SDialog({
    required this.title,
    required this.body,
    this.primaryLabel,
    this.onPrimary,
    this.busy = false,
    this.showCancel = true,
    this.width = 520,
    super.key,
  });

  final String title;
  final Widget body;
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  /// Disables the buttons and closing while the action runs.
  final bool busy;
  final bool showCancel;
  final double width;

  /// Opens a dialog (usually an [SDialog]) and returns what it pops with.
  static Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  }) =>
      StellarKit.of(context).dialog
          .show<T>(context, builder, dismissible: dismissible);

  /// Asks the user to confirm an action. Returns true if they did.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) => StellarKit.of(context).dialog.confirm(
    context,
    ConfirmSpec(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: StellarLocalizations.of(context).cancel,
      destructive: destructive,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return StellarKit.of(context).dialog.render(
      context,
      DialogSpec(
        title: title,
        body: body,
        closeLabel: strings.close,
        cancelLabel: showCancel ? strings.cancel : null,
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        busy: busy,
        width: width,
      ),
    );
  }
}
