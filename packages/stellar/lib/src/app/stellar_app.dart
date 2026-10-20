import 'package:dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kernel/kernel.dart' show supportedLocales;

import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';
import '../material/material_kit.dart';
import '../material/theme.dart';
import '../tokens/tokens.dart';

/// The root widget of every app: theme, kit, languages (Arabic first,
/// right to left) and routing. Apps use this instead of MaterialApp.
class StellarApp extends StatelessWidget {
  const StellarApp({
    required this.routerConfig,
    required this.onGenerateTitle,
    required this.locale,
    this.localizationsDelegates = const [],
    this.kit = materialKit,
    this.colors = lightColors,
    super.key,
  });

  final RouterConfig<Object> routerConfig;
  final String Function(BuildContext context) onGenerateTitle;
  final Locale locale;

  /// The app's own translations.
  final List<LocalizationsDelegate<Object>> localizationsDelegates;
  final StellarKit kit;
  final StellarColors colors;

  @override
  Widget build(BuildContext context) => StellarScope(
    kit: kit,
    colors: colors,
    child: MaterialApp.router(
      routerConfig: routerConfig,
      onGenerateTitle: onGenerateTitle,
      // Dev and staging builds get the dev menu (bug button) on top.
      builder: (context, child) => DevMenu(child: child ?? const SizedBox()),
      debugShowCheckedModeBanner: false,
      theme: buildMaterialTheme(colors),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: [
        ...localizationsDelegates,
        StellarLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    ),
  );
}
