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
    required this.border,
    required this.text,
    required this.textMuted,
    required this.success,
    required this.warning,
    required this.danger,
    required this.onDanger,
  });

  final Color primary;
  final Color onPrimary;

  /// Tinted backgrounds (selected chips, highlights).
  final Color primarySoft;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color success;
  final Color warning;
  final Color danger;
  final Color onDanger;
}

/// Warm caramel, for sweets shops and cafés.
const lightColors = StellarColors(
  primary: Color(0xFFB85C1E),
  onPrimary: Color(0xFFFFFFFF),
  primarySoft: Color(0xFFF8E9DD),
  background: Color(0xFFFAF7F4),
  surface: Color(0xFFFFFFFF),
  surfaceMuted: Color(0xFFF2EDE8),
  border: Color(0xFFE4DCD4),
  text: Color(0xFF2B211B),
  textMuted: Color(0xFF7A6D63),
  success: Color(0xFF2E7D4F),
  warning: Color(0xFFB7791F),
  danger: Color(0xFFC0392B),
  onDanger: Color(0xFFFFFFFF),
);

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
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const pill = 999.0;
}

/// A fixed gap in a [Row] or [Column]: `Gap(Space.md)`.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(dimension: size);
}
