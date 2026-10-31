import 'package:flutter/widgets.dart';

import 's_palette.dart';

/// The color slots every look fills ([lightColors], [darkColors]).
/// Components never hard-code colors; they read these.
@immutable
class StellarColors {
  const StellarColors({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.onPrimaryMuted,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.accentWash,
    required this.accentInk,
    required this.primarySoft,
    required this.primaryTint,
    required this.discountFrom,
    required this.discountTo,
    required this.onDiscount,
    required this.cream,
    required this.shadow,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.fieldFill,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.onDanger,
    required this.link,
    required this.cameraBackdrop,
    required this.onCamera,
  });

  /// Whether these are light colors (dark text) or dark ones.
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;

  /// Quieter text on a [primary] background (labels on the amount to
  /// collect).
  final Color onPrimaryMuted;

  /// The brand's second color, for what should catch the eye: discount
  /// badges, highlights. Never for the main button.
  final Color accent;
  final Color onAccent;

  /// A soft orange behind orange text ([accentInk]): what's running out.
  final Color accentSoft;

  /// Fainter still: a card about what's left, with [accentSoft] inside it.
  final Color accentWash;
  final Color accentInk;

  /// Hovered and selected rows, table headers, soft buttons.
  final Color primarySoft;

  /// A soft green behind the brand's green: the track of how much of an
  /// offer is left.
  final Color primaryTint;

  /// An offer's discount, its own color: a gradient from [discountFrom] to
  /// [discountTo], with [onDiscount] on it.
  final Color discountFrom;
  final Color discountTo;
  final Color onDiscount;

  /// The logo's background: behind the brand's pictures (the sign-in
  /// page's shop).
  final Color cream;

  /// Under what floats over the page (the floating add button).
  final Color shadow;
  final Color background;

  /// Cards, sheets and dialogs. The same as [background]: a card's border
  /// sets it apart, not its color.
  final Color surface;

  /// The side menu.
  final Color surfaceMuted;

  /// A quiet gray: behind text fields on the dashboard, the search field,
  /// and the panel that groups a store's numbers.
  final Color fieldFill;
  final Color border;
  final Color text;

  /// Secondary text (table cells, descriptions).
  final Color textMuted;

  /// The quietest text: hints, column titles, captions.
  final Color textSubtle;

  /// Each status color has a soft background for badges.
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color onDanger;
  final Color link;

  /// Behind and around a camera's picture, in both looks.
  final Color cameraBackdrop;

  /// Text and marks over a camera's picture.
  final Color onCamera;

  /// The token behind [color].
  Color resolve(SColor color) => switch (color) {
    SColor.text => text,
    SColor.textMuted => textMuted,
    SColor.textSubtle => textSubtle,
    SColor.primary => primary,
    SColor.onPrimary => onPrimary,
    SColor.accent => accent,
    SColor.onAccent => onAccent,
    SColor.success => success,
    SColor.warning => warning,
    SColor.danger => danger,
    SColor.onDanger => onDanger,
    SColor.link => link,
    SColor.surface => surface,
    SColor.surfaceMuted => surfaceMuted,
    SColor.fieldFill => fieldFill,
    SColor.primaryTint => primaryTint,
    SColor.successSoft => successSoft,
    SColor.accentSoft => accentSoft,
    SColor.cream => cream,
  };
}

/// The colors text, icons and panels can have. Each one is a
/// [StellarColors] token, so apps can't pick a color of their own.
enum SColor {
  text,

  /// Secondary text (descriptions, table cells).
  textMuted,

  /// The quietest text: hints, captions.
  textSubtle,
  primary,

  /// On a [primary] background.
  onPrimary,

  /// The brand's second color (discounts, highlights).
  accent,

  /// On an [accent] background.
  onAccent,
  success,
  warning,
  danger,

  /// On a [danger] background.
  onDanger,
  link,

  // Behind things: panels and cards (SStatGrid).
  surface,
  surfaceMuted,

  /// A quiet gray.
  fieldFill,

  /// A soft green.
  primaryTint,
  successSoft,
  accentSoft,

  /// The brand's cream.
  cream,
}
