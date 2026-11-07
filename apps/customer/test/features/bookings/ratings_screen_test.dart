import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/ratings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeBookingsRepository bookings;

  setUp(() => bookings = FakeBookingsRepository());

  Future<void> open(WidgetTester tester) => pumpCustomerPages(
    tester,
    initial: Routes.ratings,
    routes: [
      GoRoute(path: Routes.ratings, builder: (_, _) => const RatingsScreen()),
      stubPage(Routes.bookingPattern, 'booking page'),
      stubPage(Routes.bookings, 'bookings page'),
    ],
    overrides: [
      bookingsRepositoryProvider.overrideWithValue(bookings),
      sessionProvider.overrideWith(() => SignedInSession(customer())),
    ],
  );

  testWidgets('lists the rated pickups with their stars', (tester) async {
    final semantics = tester.ensureSemantics();
    bookings.bookings = [
      booking(status: BookingStatus.pickedUp, myRating: 4),
      booking(id: 'k2', status: BookingStatus.pickedUp),
    ];
    await open(tester);

    expect(find.text('Sweet shop'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('4 stars')), findsOneWidget);

    await tester.tap(find.text('Sweet shop'));
    await tester.pumpAndSettle();
    expect(find.text('booking page'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('with none yet, it leads to the bookings', (tester) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);

    expect(find.text('No ratings yet'), findsOneWidget);
    await tester.tap(find.text('My bookings'));
    await tester.pumpAndSettle();
    expect(find.text('bookings page'), findsOneWidget);
  });
}
