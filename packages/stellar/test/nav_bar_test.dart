import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/src/material/s_glass.dart';
import 'package:stellar/stellar.dart';

const _items = [
  NavBarItem(label: 'Home', icon: SIcons.home),
  NavBarItem(label: 'Profile', icon: SIcons.user),
];

Widget app(Widget page) => SApp(
  routerConfig: GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => page)],
  ),
  locale: const Locale('en'),
  onGenerateTitle: (_) => 'test',
);

void main() {
  testWidgets('shows the open tab and reports taps on the others', (
    tester,
  ) async {
    final tapped = <int>[];
    await tester.pumpWidget(
      app(
        SNavBar(
          items: _items,
          selected: 0,
          onSelect: tapped.add,
          body: const SText('Home page'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home page'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    expect(tapped, [1]);
  });

  testWidgets('the page goes on under the tabs, its lists ending above', (
    tester,
  ) async {
    late double room;
    await tester.pumpWidget(
      app(
        SNavBar(
          items: _items,
          selected: 0,
          onSelect: (_) {},
          body: SScaffold(
            showAppBar: false,
            padded: false,
            body: Builder(
              builder: (context) {
                room = MediaQuery.paddingOf(context).bottom;
                return const SizedBox.expand(key: Key('page'));
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    final tabs = tester.getRect(find.byType(SGlass));
    expect(tester.getRect(find.byKey(const Key('page'))).bottom, screen.height);
    expect(room, screen.height - tabs.top);
  });

  testWidgets('with the keyboard up, the page ends at the keyboard', (
    tester,
  ) async {
    const keyboard = 300.0;
    tester.view.viewInsets = FakeViewPadding(
      bottom: keyboard * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      app(
        SNavBar(
          items: _items,
          selected: 0,
          onSelect: (_) {},
          body: const SScaffold(
            showAppBar: false,
            padded: false,
            body: SizedBox.expand(key: Key('page')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(
      tester.getRect(find.byKey(const Key('page'))).bottom,
      screen.height - keyboard,
    );
  });
}
