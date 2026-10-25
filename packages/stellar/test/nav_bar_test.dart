import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

void main() {
  testWidgets('shows the open tab and reports taps on the others', (
    tester,
  ) async {
    final tapped = <int>[];
    await tester.pumpWidget(
      SApp(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => SNavBar(
                items: const [
                  NavBarItem(label: 'Home', icon: SIcons.home),
                  NavBarItem(label: 'Profile', icon: SIcons.user),
                ],
                selected: 0,
                onSelect: tapped.add,
                body: const SText('Home page'),
              ),
            ),
          ],
        ),
        locale: const Locale('en'),
        onGenerateTitle: (_) => 'test',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home page'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    expect(tapped, [1]);
  });
}
