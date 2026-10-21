import 'package:flutter/widgets.dart';

import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';

/// A dialog with a title bar, a scrolling [body] and a footer with Cancel
/// and [primaryLabel]. Open it with [showAppDialog].
class AppDialog extends StatelessWidget {
  const AppDialog({
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

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return StellarKit.of(context).overlay.dialog(
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

/// Opens a dialog (usually an [AppDialog]) and returns what it pops with.
Future<T?> showAppDialog<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool dismissible = true,
}) =>
    StellarKit.of(context).overlay
        .show<T>(context, builder, dismissible: dismissible);

/// Asks the user to confirm an action. Returns true if they did.
Future<bool> appConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) => StellarKit.of(context).overlay.confirm(
  context,
  ConfirmSpec(
    title: title,
    message: message,
    confirmLabel: confirmLabel,
    cancelLabel: StellarLocalizations.of(context).cancel,
    destructive: destructive,
  ),
);

/// A button with a menu of [entries]; null entries draw a divider.
/// [builder] draws the button and gets the function that opens the menu.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({
    required this.entries,
    required this.builder,
    this.alignEnd = true,
    this.width = 184,
    super.key,
  });

  final List<MenuEntry?> entries;
  final Widget Function(BuildContext context, VoidCallback toggle) builder;
  final bool alignEnd;
  final double width;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).overlay.menu(
    context,
    entries: entries,
    builder: builder,
    alignEnd: alignEnd,
    width: width,
  );
}
