import 'package:flutter/widgets.dart';

import 's_colors.dart';

/// The brand's colors (كزيوني): its deep green on the main buttons, the open
/// tab and focused fields, its orange for highlights, on white with grays
/// warmed toward the brand's cream. Every app shares them; the dashboard
/// keeps ERPNext's layout and neutral rows. Change a color here and every
/// app follows.
const lightColors = StellarColors(
  brightness: Brightness.light,
  primary: Color(0xFF0C4E3B),
  onPrimary: Color(0xFFFFFFFF),
  onPrimaryMuted: Color(0xFFCFE3D8),
  accent: Color(0xFFF7731A),
  onAccent: Color(0xFFFFFFFF),
  accentSoft: Color(0xFFFFEFE3),
  accentWash: Color(0xFFFFF8F2),
  accentInk: Color(0xFF9A4A0E),
  primarySoft: Color(0xFFF3F2EE),
  primaryTint: Color(0xFFE6F2EC),
  discountFrom: Color(0xFFFF8A3D),
  discountTo: Color(0xFFDD5A0A),
  onDiscount: Color(0xFFFFFFFF),
  cream: Color(0xFFFAF4E6),
  shadow: Color(0x1418201D),
  background: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  surfaceMuted: Color(0xFFF9F8F3),
  fieldFill: Color(0xFFF3F2EE),
  border: Color(0xFFE6E4DC),
  text: Color(0xFF18201D),
  textMuted: Color(0xFF4F5753),
  textSubtle: Color(0xFF7C837F),
  success: Color(0xFF1E8A57),
  successSoft: Color(0xFFE3F5EA),
  warning: Color(0xFFB45309),
  warningSoft: Color(0xFFFFF7D3),
  danger: Color(0xFFCC2929),
  dangerSoft: Color(0xFFFFF0F0),
  onDanger: Color(0xFFFFFFFF),
  link: Color(0xFF0C7A57),
  cameraBackdrop: Color(0xFF000000),
  onCamera: Color(0xFFFFFFFF),
);

/// The same colors at night: dark grays, the brand's green and orange
/// brightened to read on them, and brighter status colors on dark badges.
const darkColors = StellarColors(
  brightness: Brightness.dark,
  primary: Color(0xFF4CC08E),
  onPrimary: Color(0xFF0A1F17),
  onPrimaryMuted: Color(0xFF1E4D3A),
  accent: Color(0xFFFF8C42),
  onAccent: Color(0xFF1F1209),
  accentSoft: Color(0xFF3A2414),
  accentWash: Color(0xFF261A11),
  accentInk: Color(0xFFFFB27A),
  primarySoft: Color(0xFF2C2C2C),
  primaryTint: Color(0xFF1D2F27),
  discountFrom: Color(0xFFFFA45E),
  discountTo: Color(0xFFF07425),
  onDiscount: Color(0xFFFFFFFF),
  cream: Color(0xFF2A2620),
  shadow: Color(0x66000000),
  background: Color(0xFF1C1C1C),
  surface: Color(0xFF1C1C1C),
  surfaceMuted: Color(0xFF171717),
  fieldFill: Color(0xFF2C2C2C),
  border: Color(0xFF343434),
  text: Color(0xFFF3F3F3),
  textMuted: Color(0xFFC7C7C7),
  textSubtle: Color(0xFF999999),
  success: Color(0xFF5FD39A),
  successSoft: Color(0xFF173326),
  warning: Color(0xFFF5B656),
  warningSoft: Color(0xFF3B2E16),
  danger: Color(0xFFFF7575),
  dangerSoft: Color(0xFF3D1F1F),
  onDanger: Color(0xFF171717),
  link: Color(0xFF52C79A),
  cameraBackdrop: Color(0xFF000000),
  onCamera: Color(0xFFFFFFFF),
);

/// The red, yellow and green dots of a Mac window, in the small window
/// pictures of the theme and language settings.
const windowDotColors = [
  Color(0xFFFF5F57),
  Color(0xFFFEBC2E),
  Color(0xFF28C840),
];
