import 'package:dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kernel/kernel.dart' show ThemeChoice, supportedLocales;

import '../foundation/s_kit.dart';
import '../foundation/s_tokens.dart';
import '../l10n/generated/stellar_localizations.dart';
import '../material/s_material_kit.dart';
import '../material/s_material_theme.dart';

/// The root widget of every app: theme, kit, languages (Arabic first,
/// right to left) and routing. Apps use this instead of MaterialApp.
class SApp extends StatelessWidget {
  const SApp({
    required this.routerConfig,
    required this.onGenerateTitle,
    required this.locale,
    this.localizationsDelegates = const [],
    this.kit = materialKit,
    this.colors = lightColors,
    this.theme = ThemeChoice.light,
    this.density = StellarDensity.comfortable,
    super.key,
  });

  final RouterConfig<Object> routerConfig;
  final String Function(BuildContext context) onGenerateTitle;
  final Locale locale;

  /// The app's own translations.
  final List<LocalizationsDelegate<Object>> localizationsDelegates;
  final StellarKit kit;
  final StellarColors colors;

  /// Light, dark, or following the device.
  final ThemeChoice theme;

  /// [StellarDensity.compact] for the web dashboard.
  final StellarDensity density;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: routerConfig,
    onGenerateTitle: onGenerateTitle,
    // Below MaterialApp, so "follow the device" can see whether the
    // device is dark. Dev and staging builds get the dev menu on top.
    builder: (context, child) => StellarScope(
      kit: kit,
      colors: Theme.of(context).brightness == Brightness.dark
          ? darkColors
          : colors,
      child: DevMenu(child: child ?? const SizedBox()),
    ),
    debugShowCheckedModeBanner: false,
    theme: buildMaterialTheme(colors, density: density),
    darkTheme: buildMaterialTheme(darkColors, density: density),
    themeMode: switch (theme) {
      ThemeChoice.system => ThemeMode.system,
      ThemeChoice.light => ThemeMode.light,
      ThemeChoice.dark => ThemeMode.dark,
    },
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: [
      ...localizationsDelegates,
      StellarLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  );
}
