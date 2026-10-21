import 'package:flutter/widgets.dart';

/// A dialog with a title bar and close button, a scrolling [body] and a
/// footer with Cancel and the main action, as in ERPNext.
@immutable
class DialogSpec {
  const DialogSpec({
    required this.title,
    required this.body,
    required this.closeLabel,
    this.primaryLabel,
    this.onPrimary,
    this.busy = false,
    this.cancelLabel,
    this.width = 520,
  });

  final String title;
  final Widget body;
  final String closeLabel;

  /// The main button; no footer without it.
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  /// Disables the buttons and closing while the action runs.
  final bool busy;
  final String? cancelLabel;
  final double width;
}

@immutable
class ConfirmSpec {
  const ConfirmSpec({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// A red confirm button, for actions that remove or disable something.
  final bool destructive;
}

abstract interface class DialogRenderer {
  /// Opens [builder] (usually an SDialog) over the page.
  Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  });
  Widget render(BuildContext context, DialogSpec spec);
  Future<bool> confirm(BuildContext context, ConfirmSpec spec);
}
