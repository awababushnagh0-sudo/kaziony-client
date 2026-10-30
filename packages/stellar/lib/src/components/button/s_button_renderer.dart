import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

enum ButtonVariant {
  primary,
  secondary,
  text,
  danger,

  /// Gray on the surface: the quieter one of two side by side.
  soft,

  /// Light red with red words: a for-good action that isn't the page's
  /// main one.
  dangerSoft,

  /// Red words and icon on the surface, from the start like a page's row:
  /// leaving (logging out), at the foot of a page.
  dangerSecondary,
}

@immutable
class ButtonSpec {
  const ButtonSpec({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.loading = false,
    this.expand = false,
    this.icon,
    this.smallIcon = false,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  /// Shows a spinner and ignores taps, so a form can't be sent twice.
  final bool loading;

  /// Fill the available width.
  final bool expand;

  /// Drawn after the label, on the same side for every button (the left in
  /// Arabic), as ERPNext does.
  final SIcons? icon;

  /// A smaller icon: a menu button's chevron.
  final bool smallIcon;
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
