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

  testWidgets('lists bookings, with the code while it is good', (tester) async {
    bookings.bookings = [
      booking(),
      booking(id: 'k2', status: BookingStatus.expired),
    ];
    await open(tester);

    expect(find.textContaining('A2GU GPJ7'), findsOneWidget);
    expect(find.text('Sweet shop · Time ran out'), findsOneWidget);

    await tester.tap(find.textContaining('A2GU GPJ7'));
    await tester.pumpAndSettle();
    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('a pickup not rated yet asks for a rating', (tester) async {
    bookings.bookings = [
      booking(status: BookingStatus.pickedUp, canRate: true),
      booking(id: 'k2', status: BookingStatus.pickedUp, myRating: 4),
    ];
    await open(tester);

    expect(find.text('Rate'), findsOneWidget);
  });

  testWidgets('with none yet, it leads to the offers', (tester) async {
    bookings.bookings = [];
    await open(tester);

    await tester.tap(find.text('Browse offers'));
    await tester.pumpAndSettle();

    expect(find.text('home page'), findsOneWidget);
  });
}
