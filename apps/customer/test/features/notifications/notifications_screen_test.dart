import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/notifications/domain/app_notification.dart';
import 'package:customer/features/notifications/presentation/notifications_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeNotificationsRepository notifications;

  setUp(() => notifications = FakeNotificationsRepository());

  Future<void> open(WidgetTester tester, {bool signedIn = true}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.notifications,
        routes: [
          GoRoute(
            path: Routes.notifications,
            builder: (_, _) => const NotificationsScreen(),
          ),
          stubPage(Routes.signIn, 'sign-in page'),
        ],
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(notifications),
          if (signedIn)
            sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );

  testWidgets('signed out, it opens the sign-in page', (tester) async {
    await open(tester, signedIn: false);

    expect(find.text('Sign in to get notifications'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in page'), findsOneWidget);
  });

  testWidgets('with none yet, it says so and looks again on refresh', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('No notifications yet'), findsOneWidget);
    expect(notifications.loads, 1);
    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();

    expect(notifications.loads, 2);
  });

  testWidgets('lists them, the newest first', (tester) async {
    notifications.result = Ok([
      AppNotification(
        id: 'n1',
        title: 'Your booking ends soon',
        body: 'Pick up your cake before 6 PM.',
        sentAt: DateTime.now(),
      ),
    ]);
    await open(tester);

    expect(find.text('Your booking ends soon'), findsOneWidget);
    expect(find.text('Pick up your cake before 6 PM.'), findsOneWidget);
  });

  testWidgets('when they fail to load, tries again', (tester) async {
    notifications.result = const Err(NoConnectionFailure());
    await open(tester);

    expect(find.text('Try again'), findsOneWidget);
    notifications.result = const Ok([]);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('No notifications yet'), findsOneWidget);
  });
}
