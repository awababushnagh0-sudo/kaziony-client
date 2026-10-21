import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

void main() {
  // On a store's page "Stores" is selected, and it's the way back to the
  // list.
  testWidgets('the selected menu item still opens its page', (tester) async {
    tester.view
      ..physicalSize = const Size(1400, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var taps = 0;
    await tester.pumpWidget(
      SApp(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => SShell(
                title: 'Admin',
                items: [
                  NavItemSpec(
                    label: 'Stores',
                    icon: SIcons.store,
                    selected: true,
                    onTap: () => taps++,
                  ),
                ],
                body: const SizedBox(),
              ),
            ),
          ],
        ),
        locale: const Locale('en'),
        density: StellarDensity.compact,
        onGenerateTitle: (_) => 'test',
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stores'));
    expect(taps, 1);
  });
}
