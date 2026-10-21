import 'package:flutter/widgets.dart';

/// Brand colors. Components never hard-code colors; they read these.
@immutable
class StellarColors {
  const StellarColors({
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
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
  });

  final Color primary;
  final Color onPrimary;

  /// Hovered and selected rows, table headers, soft buttons.
  final Color primarySoft;
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
}

/// ERPNext / Frappe UI colors: neutral grays, near-black primary buttons,
/// filled gray fields and soft status badges. A brand color can replace
/// [StellarColors.primary] later without touching any screen.
const lightColors = StellarColors(
  primary: Color(0xFF171717),
  onPrimary: Color(0xFFFFFFFF),
  primarySoft: Color(0xFFF3F3F3),
  background: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  surfaceMuted: Color(0xFFF8F8F8),
  fieldFill: Color(0xFFF3F3F3),
  border: Color(0xFFE5E5E5),
  text: Color(0xFF171717),
  textMuted: Color(0xFF525252),
  textSubtle: Color(0xFF7C7C7C),
  success: Color(0xFF278F5E),
  successSoft: Color(0xFFE4FAEB),
  warning: Color(0xFFB45309),
  warningSoft: Color(0xFFFFF7D3),
  danger: Color(0xFFCC2929),
  dangerSoft: Color(0xFFFFF0F0),
  onDanger: Color(0xFFFFFFFF),
  link: Color(0xFF0289F7),
);

/// The font of every app: IBM Plex Sans Arabic, bundled in stellar.
const stellarFont = 'packages/stellar/IBMPlexSansArabic';

/// Spacing scale. Use these for gaps and padding instead of raw numbers.
abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class Radii {
  static const sm = 6.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const pill = 999.0;
}

/// How tight controls are. Phones use [comfortable] (big touch targets);
/// the web dashboard uses [compact] (mouse, more on screen).
enum StellarDensity {
  comfortable(controlHeight: 48, fontSize: 16),
  compact(controlHeight: 36, fontSize: 14);

  const StellarDensity({required this.controlHeight, required this.fontSize});

  final double controlHeight;

  /// Body and control text size.
  final double fontSize;
}

/// A fixed gap in a [Row] or [Column]: `Gap(Space.md)`.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(dimension: size);
}
