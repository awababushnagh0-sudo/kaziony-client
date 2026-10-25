import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

/// The app's language decides the locale, as in the apps.
class _App extends AppView {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SApp(
    routerConfig: _router,
    locale: ref.watch(localeProvider),
    onGenerateTitle: (_) => 'test',
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) =>
          const SScaffold(actions: [SLanguageButton()], body: SizedBox()),
    ),
  ],
);

void main() {
  testWidgets('the globe opens a sheet that changes the language', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppScope(overrides: testOverrides(), child: const _App()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('اللغة'));
    await tester.pumpAndSettle();
    expect(find.text('العربية'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // The sheet closed and the app is in English now.
    expect(find.text('العربية'), findsNothing);
    expect(find.byTooltip('Language'), findsOneWidget);
  });
}
