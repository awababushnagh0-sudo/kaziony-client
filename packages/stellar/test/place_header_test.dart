import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

Widget app(Widget page) => SApp(
  routerConfig: GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => SScaffold(body: page),
      ),
    ],
  ),
  locale: const Locale('en'),
  onGenerateTitle: (_) => 'test',
);

void main() {
  testWidgets('the pill opens the places, the button at its end its page', (
    tester,
  ) async {
    final tapped = <String>[];
    await tester.pumpWidget(
      app(
        SPlaceHeader(
          place: 'Home',
          detail: 'Offers within 10 km',
          onTap: () => tapped.add('place'),
          trailing: SButton.onBand(
            icon: SIcons.notifications,
            tooltip: 'Notifications',
            onPressed: () => tapped.add('bell'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.tap(find.byTooltip('Notifications'));

    expect(tapped, ['place', 'bell']);
  });

  testWidgets('the button is round and as tall as the pill', (tester) async {
    await tester.pumpWidget(
      app(
        SPlaceHeader(
          place: 'Home',
          detail: 'Offers within 10 km',
          onTap: () {},
          trailing: SButton.onBand(
            icon: SIcons.notifications,
            tooltip: 'Notifications',
            onPressed: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final pill = tester.getSize(find.bySubtype<SPlaceHeader>());
    final button = tester.getSize(find.bySubtype<SButton>());
    expect(button.height, pill.height);
    expect(button.width, button.height);
  });
}
