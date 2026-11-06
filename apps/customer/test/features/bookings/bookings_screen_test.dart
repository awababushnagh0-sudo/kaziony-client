import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/bookings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeBookingsRepository bookings;

  setUp(() => bookings = FakeBookingsRepository());

  Future<void> open(WidgetTester tester, {bool signedIn = true}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.bookings,
        routes: [
          GoRoute(
            path: Routes.bookings,
            builder: (_, _) => const BookingsScreen(),
          ),
          stubPage(Routes.signIn, 'sign-in page'),
          stubPage(Routes.bookingPattern, 'pickup code page'),
          stubPage(Routes.home, 'home page'),
        ],
        overrides: [
          bookingsRepositoryProvider.overrideWithValue(bookings),
          minuteClockProvider.overrideWith((ref) => Stream.value(now)),
          secondClockProvider.overrideWith((ref) => Stream.value(now)),
          if (signedIn)
            sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );

  testWidgets('signed out, it opens the sign-in page', (tester) async {
    await open(tester, signedIn: false);

    expect(find.text('Sign in to see your bookings'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in page'), findsOneWidget);
  });

  testWidgets('the ones to pick up first, counting down, then the past', (
    tester,
  ) async {
    bookings.bookings = [
      booking(),
      booking(id: 'k2', status: BookingStatus.expired),
    ];
    await open(tester);

    expect(find.text('Now'), findsOneWidget);
    expect(find.text('42:05'), findsOneWidget);
    expect(find.text('Before'), findsOneWidget);
    expect(find.text('Time ran out'), findsOneWidget);

    await tester.tap(find.text('Show pickup code'));
    await tester.pumpAndSettle();
    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('a past booking opens its page', (tester) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);

    expect(find.text('Now'), findsNothing);
    await tester.tap(find.text('Picked up'));
    await tester.pumpAndSettle();
    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('with none yet, it leads to the offers', (tester) async {
    bookings.bookings = [];
    await open(tester);

    await tester.tap(find.text('Browse offers'));
    await tester.pumpAndSettle();

    expect(find.text('home page'), findsOneWidget);
  });
}
