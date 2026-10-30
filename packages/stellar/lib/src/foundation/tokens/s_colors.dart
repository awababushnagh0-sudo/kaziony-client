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
    required this.accent,
    required this.onAccent,
    required this.primarySoft,
    required this.cream,
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

  /// The brand's second color, for what should catch the eye: discount
  /// badges, highlights. Never for the main button.
  final Color accent;
  final Color onAccent;

  /// Hovered and selected rows, table headers, soft buttons.
  final Color primarySoft;

  /// The logo's background: behind the brand's pictures (the sign-in
  /// page's shop).
  final Color cream;
  final Color background;
  final Color surface;

  /// The side menu.
  final Color surfaceMuted;

  /// Text field background.
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
  };
}

/// The colors text and icons can have. Each one is a [StellarColors] token,
/// so apps can't pick a color of their own.
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
}
