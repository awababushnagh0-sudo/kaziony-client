import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/providers/access.dart';
import 'package:admin/core/widgets/admin_shell.dart';
import 'package:admin/core/widgets/coming_soon_screen.dart';
import 'package:admin/features/auth/domain/auth_repository.dart';
import 'package:admin/features/dashboard/domain/dashboard_stats.dart';
import 'package:admin/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeDashboardRepository stats, {bool admin = true}) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    isAdminProvider.overrideWithValue(admin),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    dashboardRepositoryProvider.overrideWithValue(stats),
  ],
  child: SApp(
    routerConfig: GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (_, state, child) =>
              AdminShell(location: state.matchedLocation, child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, _) => const DashboardScreen()),
            GoRoute(
              path: '/stores',
              builder: (_, _) => const ComingSoonScreen(title: 'Stores'),
            ),
            for (final path in ['/users', '/offers', '/categories'])
              GoRoute(
                path: path,
                builder: (_, _) => ComingSoonScreen(title: path),
              ),
          ],
        ),
      ],
    ),
    locale: const Locale('en'),
    style: StellarStyle.dashboard,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  ),
);

void setWindow(WidgetTester tester, double width) {
  tester.view
    ..physicalSize = Size(width, 800)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('wide windows show the side menu and the numbers', (
    tester,
  ) async {
    setWindow(tester, 1280);
    await tester.pumpWidget(harness(FakeDashboardRepository()));
    await tester.pumpAndSettle();

    for (final label in ['Home', 'Stores', 'Users', 'Offers', 'Categories']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text('12'), findsOneWidget);
    expect(find.text('10 active'), findsOneWidget);
    expect(find.text('34'), findsOneWidget);
    expect(find.text('80% of finished claims were picked up'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsNothing);

    // The first "Stores" is the menu item (the second is a stat card).
    await tester.tap(find.text('Stores').first);
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('narrow windows open the menu from the page bar', (tester) async {
    setWindow(tester, 600);
    await tester.pumpWidget(harness(FakeDashboardRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsNothing);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Categories'));
    await tester.pumpAndSettle();

    expect(find.text('Coming soon'), findsOneWidget);
    // Picking a page closes the menu.
    expect(find.text('Users'), findsNothing);
  });

  testWidgets('shows an error with a retry when the stats fail', (
    tester,
  ) async {
    setWindow(tester, 1280);
    final stats = FakeDashboardRepository()
      ..result = const Err(NoConnectionFailure());
    await tester.pumpWidget(harness(stats));
    await tester.pumpAndSettle();
    expect(find.text('12'), findsNothing);

    stats.result = const Ok(sampleStats);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('12'), findsOneWidget);
    expect(stats.calls, 2);
  });

  testWidgets("editors don't see the Users page in the menu", (tester) async {
    setWindow(tester, 1280);
    await tester.pumpWidget(harness(FakeDashboardRepository(), admin: false));
    await tester.pumpAndSettle();

    expect(find.text('Users'), findsNothing);
    expect(find.text('Offers'), findsWidgets);
  });
}
