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
    required this.brandFrom,
    required this.brandTo,
    required this.onBrand,
    required this.cream,
    required this.shadow,
    required this.scrim,
    required this.onScrim,
    required this.onScrimBrand,
    required this.favorite,
    required this.inverseSurface,
    required this.onInverse,
    required this.onInverseMuted,
    required this.onInverseAccent,
    required this.codeInk,
    required this.codePaper,
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
    required this.cameraDim,
    required this.cameraGlass,
    required this.scanLine,
    required this.scanGlow,
    required this.bone,
    required this.boneShine,
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

  /// The brand's green as a small mark of its own (the owner's tag): a
  /// gradient from [brandFrom] to [brandTo], deep in both themes, with
  /// [onBrand] on it.
  final Color brandFrom;
  final Color brandTo;
  final Color onBrand;

  /// The logo's background: behind the brand's pictures (the sign-in
  /// page's shop).
  final Color cream;

  /// Under what floats over the page (the floating add button).
  final Color shadow;

  /// Dims a photo while something happens over it (an upload), with
  /// [onScrim] on it: dark, in both themes.
  final Color scrim;
  final Color onScrim;

  /// The brand's green light enough to read on a photo's dark shade (an
  /// offer's price): the same in both themes.
  final Color onScrimBrand;

  /// A saved favorite's heart: pink-red, as people know a favorite by, not
  /// the brand's green.
  final Color favorite;

  /// A bar floating over the page about something under way (a booking to
  /// pick up): dark in both looks, a little lighter than the dark page,
  /// with [onInverse] on it, [onInverseMuted] for quieter words and
  /// [onInverseAccent] for what's running out (the time left).
  final Color inverseSurface;
  final Color onInverse;
  final Color onInverseMuted;
  final Color onInverseAccent;

  /// A QR code's dark squares and the white around them: the same in both
  /// themes, so every scanner reads it.
  final Color codeInk;
  final Color codePaper;
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

  /// Darkens the picture around what to aim at.
  final Color cameraDim;

  /// Buttons over a camera's picture: frosted, letting it show through.
  final Color cameraGlass;

  /// The line sweeping a scanner's square, and the light around it.
  final Color scanLine;
  final Color scanGlow;

  /// The gray shapes that stand in for what's loading (SSkeleton), and
  /// the light that sweeps across them.
  final Color bone;
  final Color boneShine;

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
    SColor.onScrim => onScrim,
    SColor.onScrimBrand => onScrimBrand,
    SColor.link => link,
    SColor.surface => surface,
    SColor.surfaceMuted => surfaceMuted,
    SColor.fieldFill => fieldFill,
    SColor.primaryTint => primaryTint,
    SColor.successSoft => successSoft,
    SColor.accentSoft => accentSoft,
    SColor.accentInk => accentInk,
    SColor.cream => cream,
    SColor.favorite => favorite,
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

  /// The brand's orange deep enough for text on white: what's running out
  /// (time left to pick up).
  accentInk,
  success,
  warning,
  danger,

  /// On a [danger] background.
  onDanger,

  /// Words on a photo, over its dark shade: white in either look.
  onScrim,

  /// The brand's green on a photo, over its dark shade (an offer's price).
  onScrimBrand,
  link,

  // Behind things: panels and cards.
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

  /// The heart of what's saved to favorites.
  favorite,
}
