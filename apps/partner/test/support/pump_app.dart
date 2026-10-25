import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/l10n/generated/partner_localizations.dart';
import 'package:stellar/stellar.dart';

/// Opens [initial] in the partner app's look, in English, with [routes]
/// and kernel's test fakes plus [overrides].
Future<void> pumpPartnerPages(
  WidgetTester tester, {
  required String initial,
  required List<RouteBase> routes,
  List<Override> overrides = const [],
  SettingsStore? settings,
}) async {
  await tester.pumpWidget(
    AppScope(
      overrides: [
        ...testOverrides(settings: settings),
        ...overrides,
      ],
      child: SApp(
        routerConfig: GoRouter(initialLocation: initial, routes: routes),
        locale: const Locale('en'),
        onGenerateTitle: (_) => 'test',
        localizationsDelegates: const [PartnerLocalizations.delegate],
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// A page that only shows [label], standing in for one a test leaves to.
GoRoute stubPage(String path, String label) =>
    GoRoute(path: path, builder: (_, _) => SText(label));
