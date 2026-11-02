import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/booking_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeBookingsRepository bookings;

  setUp(() => bookings = FakeBookingsRepository());

  Future<void> open(WidgetTester tester) => pumpCustomerPages(
    tester,
    initial: Routes.booking('k1'),
    routes: [
      GoRoute(
        path: Routes.bookingPattern,
        builder: (_, state) =>
            BookingScreen(bookingId: state.pathParameters['bookingId']!),
      ),
    ],
    overrides: [
      bookingsRepositoryProvider.overrideWithValue(bookings),
      secondClockProvider.overrideWith((ref) => Stream.value(now)),
      sessionProvider.overrideWith(() => SignedInSession(customer())),
    ],
  );

  testWidgets('shows the code and the time left to pick up', (tester) async {
    await open(tester);

    expect(find.text('A2GU GPJ7'), findsOneWidget);
    expect(find.text('42:05 left to pick up'), findsOneWidget);
    expect(find.text('Waiting for pickup'), findsOneWidget);
  });

  testWidgets('cancels after asking', (tester) async {
    await open(tester);

    await tester.ensureVisible(find.text('Cancel reservation'));
    await tester.tap(find.text('Cancel reservation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(bookings.cancels, 0);

    await tester.tap(find.text('Cancel reservation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel reservation').last);
    await tester.pumpAndSettle();

    expect(bookings.cancels, 1);
    expect(find.text('Reservation cancelled'), findsOneWidget);
    expect(find.text('A2GU GPJ7'), findsNothing);
  });

  testWidgets('once over, it hides the code', (tester) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);

    expect(find.text('A2GU GPJ7'), findsNothing);
    expect(find.text('Cancel reservation'), findsNothing);
  });
}
