import 'package:flutter/material.dart';

import '../foundation/s_tokens.dart';

/// Material theme built from the stellar tokens in one of the two looks:
/// the phone apps' (like the big consumer apps) or the dashboard's (like
/// ERPNext).
ThemeData buildMaterialTheme(
  StellarColors c, {
  StellarStyle style = StellarStyle.app,
}) {
  final compact = style == StellarStyle.dashboard;
  final text = style.text;
  final radius = BorderRadius.circular(style.radius);
  final rounded = RoundedRectangleBorder(borderRadius: radius);
  // Buttons are pills in every app, as in the big apps.
  const pill = StadiumBorder();
  final controlSize = Size(0, style.controlHeight);
  final buttonText = TextStyle(
    fontFamily: stellarFont,
    fontSize: text.body,
    fontWeight: compact ? SFontWeight.medium.value : SFontWeight.semibold.value,
  );
  final buttonPadding = EdgeInsets.symmetric(
    horizontal: compact ? 14 : Space.xl,
  );
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: stellarFont,
    brightness: c.brightness,
  );

  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );

  return base.copyWith(
    // Sizes come from [style]; don't let desktop browsers shrink them.
    visualDensity: VisualDensity.standard,
    // The dashboard behaves like a website: no ripple or press flash on
    // buttons, tabs and rows (hover still shows). Phones keep the ripple.
    splashFactory: compact ? NoSplash.splashFactory : null,
    highlightColor: compact ? Colors.transparent : null,
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    dividerColor: c.border,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: c.primary,
          brightness: c.brightness,
        ).copyWith(
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
            fontSize: text.body,
            fontWeight: SFontWeight.medium.value,
            color: c.text,
          ),
          bodyMedium: TextStyle(
            fontSize: text.body,
            color: c.text,
            height: 1.5,
          ),
          bodySmall: TextStyle(fontSize: text.small, color: c.textSubtle),
          headlineMedium: TextStyle(
            fontSize: text.display,
            fontWeight: SFontWeight.bold.value,
            color: c.text,
            height: 1.3,
          ),
          titleLarge: TextStyle(
            fontSize: text.title,
            fontWeight: compact
                ? SFontWeight.semibold.value
                : SFontWeight.bold.value,
            color: c.text,
          ),
          titleMedium: TextStyle(
            fontSize: text.subtitle,
            fontWeight: SFontWeight.semibold.value,
            color: c.text,
          ),
          labelLarge: TextStyle(
            fontSize: text.body,
            fontWeight: SFontWeight.medium.value,
          ),
        )
        // Last, so the styles replaced above get the font too.
        .apply(fontFamily: stellarFont),
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      // The title at the start: big and bold on phones, as in the big
      // apps; a row with the actions at the end on the dashboard, as in
      // ERPNext.
      centerTitle: false,
      toolbarHeight: compact ? 64 : null,
      titleSpacing: compact ? Space.xl : Space.lg,
      titleTextStyle: TextStyle(
        fontFamily: stellarFont,
        fontSize: text.title,
        fontWeight: compact
            ? SFontWeight.semibold.value
            : SFontWeight.bold.value,
        color: c.text,
      ),
      shape: compact ? Border(bottom: BorderSide(color: c.border)) : null,
    ),
    dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
    // Labels sit above the field (see the text input renderer). Phones get
    // white fields with a thin border that turns the brand color when
    // focused, as in the big apps; the dashboard gets ERPNext's gray boxes
    // with a border only when focused.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: compact ? c.fieldFill : c.surface,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Space.md,
        // About 33px tall on the dashboard, a little roomier than ERPNext;
        // 48px on phones.
        vertical: compact ? 6 : 12,
      ),
      hintStyle: TextStyle(color: c.textSubtle, fontSize: text.body),
      border: inputBorder(compact ? Colors.transparent : c.border),
      enabledBorder: inputBorder(compact ? Colors.transparent : c.border),
      focusedBorder: compact
          ? inputBorder(c.textSubtle)
          : inputBorder(c.primary, 1.5),
      errorBorder: inputBorder(c.danger),
      focusedErrorBorder: inputBorder(c.danger, 1.5),
      errorStyle: TextStyle(color: c.danger, fontSize: text.tiny),
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
        padding: buttonPadding,
        shape: pill,
        textStyle: buttonText,
      ),
    ),
    // "Secondary": a soft gray button on the dashboard; white with a thin
    // dark outline on phones, as DoorDash's.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.text,
        backgroundColor: compact ? c.primarySoft : c.surface,
        side: compact ? BorderSide.none : BorderSide(color: c.text),
        minimumSize: controlSize,
        padding: buttonPadding,
        shape: pill,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.text,
        minimumSize: controlSize,
        shape: pill,
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
        borderRadius: BorderRadius.circular(compact ? 10 : 16),
        side: BorderSide(color: c.border),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(compact ? 12 : 20),
      ),
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
    // Snack bars and tooltips are dark ink, not the brand color, so they
    // never look like a button.
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.text,
      contentTextStyle: TextStyle(fontFamily: stellarFont, color: c.background),
      shape: rounded,
      width: compact ? 420 : null,
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(
        fontFamily: stellarFont,
        fontSize: text.tiny,
        color: c.background,
      ),
      decoration: BoxDecoration(color: c.text, borderRadius: radius),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.textMuted,
      linearTrackColor: c.primarySoft,
    ),
  );
}
