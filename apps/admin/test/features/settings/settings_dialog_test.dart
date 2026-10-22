import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/widgets/admin_shell.dart';
import 'package:admin/features/auth/domain/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

/// The dashboard as the app builds it: the theme and language come from
/// the settings, and the router outlives rebuilds.
class Harness extends AppView {
  const Harness({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SApp(
    routerConfig: router,
    locale: ref.watch(localeProvider),
    theme: ref.watch(themeChoiceProvider),
    density: StellarDensity.compact,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  );
}

GoRouter dashboard() => GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (_, state, child) =>
          AdminShell(location: state.matchedLocation, child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const SScaffold(body: SizedBox()),
        ),
      ],
    ),
  ],
);

Future<void> openSettings(WidgetTester tester) async {
  tester.view
    ..physicalSize = const Size(1400, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    AppScope(
      overrides: [
        ...testOverrides(kind: AppKind.admin),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        localeProvider.overrideWith(EnglishLocale.new),
        sessionProvider.overrideWith(() => FakeSession(user())),
      ],
      child: Harness(router: dashboard()),
    ),
  );
  await tester.pumpAndSettle();

  // The account menu, under the user's name.
  await tester.tap(find.text('Test Admin'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('switches the dashboard to the dark theme', (tester) async {
    await openSettings(tester);
    expect(find.text('Appearance'), findsWidgets);
    expect(tester.element(find.text('Dark')).colors, lightColors);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(tester.element(find.text('Dark')).colors, darkColors);
  });

  testWidgets('switches the dashboard to Arabic', (tester) async {
    await openSettings(tester);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('المظهر'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.text('المظهر').first)),
      TextDirection.rtl,
    );
  });
}
