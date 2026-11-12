import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
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
          stubPage(Routes.bookingPattern, 'booking page'),
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

  BookingCancelledNotification cancelled({bool read = false}) =>
      BookingCancelledNotification(
        id: 'n1',
        sentAt: DateTime.now(),
        read: read,
        bookingId: 'k1',
        offerTitle: 'Kunafa box',
        storeName: 'Sweet shop',
        storeArea: 'Andalus',
        reason: CancelReason.storeOff,
      );

  testWidgets('says which booking we cancelled and why, and opens it', (
    tester,
  ) async {
    notifications.result = Ok([cancelled()]);
    notifications.unread = const Ok(1);
    await open(tester);

    final title = find.text(
      'Your booking at Sweet shop · Andalus was cancelled',
    );
    expect(title, findsOneWidget);
    expect(
      find.text(
        "Kunafa box. This shop can't take bookings right now. This doesn't "
        'count against you.',
      ),
      findsOneWidget,
    );
    // Shown, so seen: the bell's count goes.
    expect(notifications.markedRead, 1);

    await tester.tap(title);
    await tester.pumpAndSettle();
    expect(find.text('booking page'), findsOneWidget);
  });

  testWidgets('marks nothing seen when all were seen already', (tester) async {
    notifications.result = Ok([cancelled(read: true)]);
    await open(tester);

    expect(notifications.markedRead, 0);
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
