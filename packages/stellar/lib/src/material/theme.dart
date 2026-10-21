import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Material theme built from the stellar tokens, in the style of ERPNext.
/// [density] only changes sizes: phones get bigger text and touch targets.
ThemeData buildMaterialTheme(
  StellarColors c, {
  StellarDensity density = StellarDensity.comfortable,
}) {
  final compact = density == StellarDensity.compact;
  final size = density.fontSize;
  final radius = BorderRadius.circular(Radii.md);
  final rounded = RoundedRectangleBorder(borderRadius: radius);
  final controlSize = Size(0, density.controlHeight);
  final buttonText = TextStyle(
    fontFamily: stellarFont,
    fontSize: size,
    fontWeight: FontWeight.w500,
  );
  final base = ThemeData(useMaterial3: true, fontFamily: stellarFont);

  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );

  return base.copyWith(
    // Sizes come from [density]; don't let desktop browsers shrink them.
    visualDensity: VisualDensity.standard,
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    dividerColor: c.border,
    colorScheme: ColorScheme.fromSeed(seedColor: c.primary).copyWith(
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondaryContainer: c.primarySoft,
      onSecondaryContainer: c.text,
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.textMuted,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surface,
      surfaceContainerHighest: c.primarySoft,
      error: c.danger,
      onError: c.onDanger,
      outline: c.border,
      outlineVariant: c.border,
    ),
    textTheme: base.textTheme
        .apply(bodyColor: c.text, displayColor: c.text)
        .copyWith(
          // Text typed into fields: medium weight, so values stand out from
          // their labels as in ERPNext.
          bodyLarge: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w500,
            color: c.text,
          ),
          bodyMedium: TextStyle(fontSize: size, color: c.text, height: 1.5),
          bodySmall: TextStyle(fontSize: size - 1, color: c.textSubtle),
          headlineMedium: TextStyle(
            fontSize: compact ? 26 : 28,
            fontWeight: FontWeight.w700,
            color: c.text,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: c.text,
          ),
          titleMedium: TextStyle(
            fontSize: compact ? 15 : 17,
            fontWeight: FontWeight.w600,
            color: c.text,
          ),
          labelLarge: TextStyle(fontSize: size, fontWeight: FontWeight.w500),
        )
        // Last, so the styles replaced above get the font too.
        .apply(fontFamily: stellarFont),
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      // Phones center the title; the dashboard's page header is a row with
      // the title at the start and the actions at the end, as in ERPNext.
      centerTitle: !compact,
      toolbarHeight: compact ? 64 : null,
      titleSpacing: compact ? Space.xl : null,
      titleTextStyle: TextStyle(
        fontFamily: stellarFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: c.text,
      ),
      shape: compact ? Border(bottom: BorderSide(color: c.border)) : null,
    ),
    dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
    // Labels sit above the field (see the text input renderer), so the
    // field itself is a plain gray box with a border only when focused.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.fieldFill,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: compact ? 10 : 14,
      ),
      hintStyle: TextStyle(color: c.textSubtle, fontSize: size),
      border: inputBorder(Colors.transparent),
      enabledBorder: inputBorder(Colors.transparent),
      focusedBorder: inputBorder(c.textSubtle),
      errorBorder: inputBorder(c.danger),
      focusedErrorBorder: inputBorder(c.danger, 1.5),
      errorStyle: TextStyle(color: c.danger, fontSize: 12),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.text,
      selectionColor: c.text.withValues(alpha: 0.15),
      selectionHandleColor: c.text,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        minimumSize: controlSize,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: rounded,
        textStyle: buttonText,
      ),
    ),
    // "Secondary": a soft gray button, no outline.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.text,
        backgroundColor: c.primarySoft,
        side: BorderSide.none,
        minimumSize: controlSize,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: rounded,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.text,
        minimumSize: controlSize,
        shape: rounded,
        textStyle: buttonText,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: c.textMuted, shape: rounded),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? c.text : null,
      ),
      checkColor: WidgetStatePropertyAll(c.surface),
      side: BorderSide(color: c.textSubtle, width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: c.border),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: c.textMuted,
      textColor: c.text,
      shape: rounded,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.border),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: c.surfaceMuted,
      shape: const RoundedRectangleBorder(),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.primary,
      contentTextStyle: TextStyle(fontFamily: stellarFont, color: c.onPrimary),
      shape: rounded,
      width: compact ? 420 : null,
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(
        fontFamily: stellarFont,
        fontSize: 12,
        color: c.onPrimary,
      ),
      decoration: BoxDecoration(color: c.primary, borderRadius: radius),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.textMuted,
      linearTrackColor: c.primarySoft,
    ),
  );
}
