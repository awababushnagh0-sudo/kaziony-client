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
    expect(find.text('Sweet shop'), findsOneWidget);
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

  testWidgets('with none yet, it leads to the offers', (tester) async {
    bookings.bookings = [];
    await open(tester);

    await tester.tap(find.text('Browse offers'));
    await tester.pumpAndSettle();

    expect(find.text('home page'), findsOneWidget);
  });
}
