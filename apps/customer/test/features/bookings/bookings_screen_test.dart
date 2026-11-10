import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/bookings_screen.dart';
import 'package:customer/features/bookings/presentation/bookings_view_model.dart';
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
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Time ran out'), findsOneWidget);

    await tester.tap(find.text('Show pickup code'));
    await tester.pumpAndSettle();
    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('picked up meanwhile, it moves to the past ones', (tester) async {
    await open(tester);
    expect(find.text('Now'), findsOneWidget);

    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await tester.pump(BookingsViewModel.checkEvery);
    await tester.pumpAndSettle();

    expect(find.text('Now'), findsNothing);
    expect(find.text('Picked up'), findsOneWidget);
  });

  testWidgets('a past booking shows its store and how many, and opens', (
    tester,
  ) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);

    expect(find.text('Now'), findsNothing);
    // With its area: a brand's places share its name.
    expect(find.text('Sweet shop · Andalus'), findsOneWidget);
    expect(find.text('×2'), findsOneWidget);
    expect(find.text('Kunafa box'), findsOneWidget);
    expect(find.textContaining('30'), findsOneWidget);
    await tester.tap(find.text('Picked up'));
    await tester.pumpAndSettle();
    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('past ones go under the day they happened', (tester) async {
    bookings.bookings = [
      booking(id: 'k1', status: BookingStatus.cancelled),
      booking(id: 'k2', status: BookingStatus.cancelled),
      booking(
        id: 'k3',
        status: BookingStatus.pickedUp,
        ago: const Duration(days: 1),
      ),
    ];
    await open(tester);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
  });

  testWidgets('after a missed pickup, a calm word over the list', (
    tester,
  ) async {
    bookings.bookings = [booking(status: BookingStatus.expired)];
    bookings.standingNow = BookingStanding(
      strikes: 1,
      strikesBeforePause: 3,
      nextPauseDays: 3,
      activeReservations: 0,
      maxActiveReservations: 3,
      strikeFadesAt: now.add(const Duration(days: 30)),
    );
    await open(tester);

    expect(find.text('You missed a pickup'), findsOneWidget);
    expect(
      find.text(
        '2 more before booking pauses for 3 days. It stops counting on Dec 2.',
      ),
      findsOneWidget,
    );
    expect(find.text('Time ran out'), findsOneWidget);
  });

  testWidgets('while booking is paused, until when', (tester) async {
    bookings.bookings = [booking(status: BookingStatus.expired)];
    bookings.standingNow = BookingStanding(
      strikes: 0,
      strikesBeforePause: 3,
      nextPauseDays: 7,
      activeReservations: 0,
      maxActiveReservations: 3,
      pausedUntil: now.add(const Duration(days: 2, hours: 3)),
    );
    await open(tester);

    expect(
      find.textContaining(RegExp('^Booking paused until Wed, Nov 4 3:00.PM\$')),
      findsOneWidget,
    );
    expect(
      find.text('After missed pickups. It opens again by itself then.'),
      findsOneWidget,
    );
    expect(find.textContaining('You missed'), findsNothing);
  });

  testWidgets('the word sits over the bookings to pick up now', (tester) async {
    bookings.standingNow = const BookingStanding(
      strikes: 2,
      strikesBeforePause: 3,
      nextPauseDays: 3,
      activeReservations: 1,
      maxActiveReservations: 3,
    );
    await open(tester);

    expect(find.text('You missed 2 pickups'), findsOneWidget);
    expect(
      find.text('1 more before booking pauses for 3 days.'),
      findsOneWidget,
    );
    expect(find.text('Now'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('You missed 2 pickups')).dy,
      lessThan(tester.getTopLeft(find.text('Now')).dy),
    );
  });

  testWidgets('with nothing to warn of, no word', (tester) async {
    bookings.bookings = [booking(status: BookingStatus.expired)];
    await open(tester);

    expect(find.textContaining('You missed'), findsNothing);
    expect(find.textContaining('paused'), findsNothing);
    expect(find.text('Time ran out'), findsOneWidget);
  });

  testWidgets('pulled down, where the customer stands is loaded again', (
    tester,
  ) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);
    expect(bookings.standingLoads, 1);

    bookings.standingNow = const BookingStanding(
      strikes: 1,
      strikesBeforePause: 3,
      nextPauseDays: 3,
      activeReservations: 0,
      maxActiveReservations: 3,
    );
    await tester.fling(find.text('Picked up'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(bookings.standingLoads, 2);
    expect(find.text('You missed a pickup'), findsOneWidget);
  });

  testWidgets('with none yet, it leads to the offers', (tester) async {
    bookings.bookings = [];
    await open(tester);

    await tester.tap(find.text('Browse offers'));
    await tester.pumpAndSettle();

    expect(find.text('home page'), findsOneWidget);
  });
}
