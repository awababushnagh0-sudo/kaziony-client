import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

Widget app(Widget page, {ThemeChoice theme = ThemeChoice.light}) => SApp(
  routerConfig: GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => SScaffold(body: page),
      ),
    ],
  ),
  locale: const Locale('en'),
  density: StellarDensity.compact,
  theme: theme,
  onGenerateTitle: (_) => 'test',
);

void setWindow(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1400, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('switches between pages from the list', (tester) async {
    setWindow(tester);
    String? chosen;
    await tester.pumpWidget(
      app(
        SSettingsDialog(
          title: 'Settings',
          pages: [
            SettingsPage(
              label: 'Appearance',
              icon: SIcons.appearance,
              hint: 'How it looks',
              children: [
                SSettingsGroup(
                  title: 'Theme',
                  hint: 'Pick one',
                  child: SOptionGrid(
                    children: [
                      SOptionCard(
                        label: 'Dark',
                        preview: WindowPreview.dark,
                        selected: false,
                        onTap: () => chosen = 'dark',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SettingsPage(
              label: 'Language',
              icon: SIcons.language,
              hint: 'Which language',
              children: [],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('How it looks'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    expect(chosen, 'dark');

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('Which language'), findsOneWidget);
  });

  testWidgets('the dark theme gives components the dark colors', (
    tester,
  ) async {
    late StellarColors colors;
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) {
            colors = context.colors;
            return const SizedBox();
          },
        ),
        theme: ThemeChoice.dark,
      ),
    );
    await tester.pumpAndSettle();

    expect(colors, darkColors);
  });

  testWidgets('following the device uses its brightness', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    late StellarColors colors;
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) {
            colors = context.colors;
            return const SizedBox();
          },
        ),
        theme: ThemeChoice.system,
      ),
    );
    await tester.pumpAndSettle();

    expect(colors, darkColors);
  });
}
