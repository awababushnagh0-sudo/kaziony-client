import 'package:dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kernel/kernel.dart' show ThemeChoice, supportedLocales;

import '../foundation/s_scope.dart';
import '../foundation/s_tokens.dart';
import '../l10n/generated/stellar_localizations.dart';
import '../material/s_glass.dart';
import '../material/s_material_theme.dart';

/// The root widget of every app: theme, languages (Arabic first,
/// right to left) and routing. Apps use this instead of MaterialApp.
class SApp extends StatefulWidget {
  const SApp({
    required this.routerConfig,
    required this.onGenerateTitle,
    required this.locale,
    this.localizationsDelegates = const [],
    this.style = StellarStyle.app,
    this.colors = lightColors,
    this.theme = ThemeChoice.light,
    this.failureWording,
    super.key,
  });

  final RouterConfig<Object> routerConfig;
  final String Function(BuildContext context) onGenerateTitle;
  final Locale locale;

  /// The app's own translations.
  final List<LocalizationsDelegate<Object>> localizationsDelegates;

  /// [StellarStyle.dashboard] for the web dashboard.
  final StellarStyle style;

  final StellarColors colors;

  /// Light, dark, or following the device.
  final ThemeChoice theme;

  /// The app's words for the failures it can meet on any screen, which
  /// every `failureMessage` uses first.
  final FailureWording? failureWording;

  @override
  State<SApp> createState() => _SAppState();
}

class _SAppState extends State<SApp> {
  @override
  void initState() {
    super.initState();
    // The phone apps' tabs float on glass: its shader loads while the app
    // opens, ready for their first frame.
    if (widget.style == StellarStyle.app) SGlass.preload();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final colors = widget.colors;
    return MaterialApp.router(
      routerConfig: widget.routerConfig,
      onGenerateTitle: widget.onGenerateTitle,
      // Below MaterialApp, so "follow the device" can see whether the
      // device is dark. Dev and staging builds get the dev menu on top.
      builder: (context, child) => StellarScope(
        style: style,
        colors: Theme.of(context).brightness == Brightness.dark
            ? darkColors
            : colors,
        failureWording: widget.failureWording,
        child: DevMenu(child: child ?? const SizedBox()),
      ),
      debugShowCheckedModeBanner: false,
      theme: buildMaterialTheme(colors, style: style),
      darkTheme: buildMaterialTheme(darkColors, style: style),
      themeMode: switch (widget.theme) {
        ThemeChoice.system => ThemeMode.system,
        ThemeChoice.light => ThemeMode.light,
        ThemeChoice.dark => ThemeMode.dark,
      },
      locale: widget.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: [
        ...widget.localizationsDelegates,
        StellarLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
