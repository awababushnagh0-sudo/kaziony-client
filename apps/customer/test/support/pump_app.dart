import 'package:customer/core/l10n/generated/customer_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

/// Opens [initial] in the customer app's look, in English, with [routes]
/// and kernel's test fakes plus [overrides]. What's kept on the phone
/// goes to [settings].
Future<void> pumpCustomerPages(
  WidgetTester tester, {
  required String initial,
  required List<RouteBase> routes,
  List<Override> overrides = const [],
  LocationFinder? locationFinder,
  SettingsStore? settings,
}) async {
  await tester.pumpWidget(
    AppScope(
      overrides: [
        ...testOverrides(
          kind: AppKind.customer,
          locationFinder: locationFinder,
          settings: settings,
        ),
        ...overrides,
      ],
      child: SApp(
        routerConfig: GoRouter(initialLocation: initial, routes: routes),
        locale: const Locale('en'),
        onGenerateTitle: (_) => 'test',
        localizationsDelegates: const [CustomerLocalizations.delegate],
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// A page that only shows [label], standing in for one a test leaves to.
GoRoute stubPage(String path, String label) =>
    GoRoute(path: path, builder: (_, _) => SText(label));
