import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/welcome/presentation/welcome_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../support/pump_app.dart';

void main() {
  Future<void> open(WidgetTester tester) => pumpCustomerPages(
    tester,
    initial: Routes.welcome,
    routes: [
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      stubPage(Routes.welcomeLocation, 'location page'),
    ],
  );

  testWidgets('goes through the pages, then asks where', (tester) async {
    await open(tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Why Kaziony?'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('location page'), findsOneWidget);
  });

  testWidgets('skipping goes straight to where', (tester) async {
    await open(tester);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('location page'), findsOneWidget);
  });
}
