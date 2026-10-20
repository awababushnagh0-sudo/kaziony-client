import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Material theme built from the stellar tokens.
ThemeData buildMaterialTheme(StellarColors c) {
  final scheme = ColorScheme.fromSeed(seedColor: c.primary).copyWith(
    primary: c.primary,
    onPrimary: c.onPrimary,
    surface: c.surface,
    onSurface: c.text,
    error: c.danger,
    onError: c.onDanger,
    outline: c.border,
  );
  final rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Radii.md),
  );
  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.background,
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md + 2,
      ),
      border: inputBorder(c.border),
      enabledBorder: inputBorder(c.border),
      focusedBorder: inputBorder(c.primary, 1.5),
      errorBorder: inputBorder(c.danger),
      focusedErrorBorder: inputBorder(c.danger, 1.5),
      labelStyle: TextStyle(color: c.textMuted),
      hintStyle: TextStyle(color: c.textMuted.withValues(alpha: 0.7)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: rounded,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: rounded,
        side: BorderSide(color: c.border),
        foregroundColor: c.text,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: c.primary),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
        side: BorderSide(color: c.border),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: rounded,
    ),
    dividerTheme: DividerThemeData(color: c.border, space: 1),
  );
}
