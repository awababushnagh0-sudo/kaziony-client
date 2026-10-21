import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

enum ButtonVariant { primary, secondary, text, danger }

@immutable
class ButtonSpec {
  const ButtonSpec({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.loading = false,
    this.expand = false,
    this.icon,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  /// Shows a spinner and ignores taps, so a form can't be sent twice.
  final bool loading;

  /// Fill the available width.
  final bool expand;
  final SIcons? icon;
}

@immutable
class IconButtonSpec {
  const IconButtonSpec({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final SIcons icon;

  /// Also what screen readers say.
  final String tooltip;
  final VoidCallback? onPressed;
}

/// Draws every kind of button: with a label ([ButtonVariant]) or just an
/// icon.
abstract interface class ButtonRenderer {
  Widget render(BuildContext context, ButtonSpec spec);
  Widget icon(BuildContext context, IconButtonSpec spec);
}
