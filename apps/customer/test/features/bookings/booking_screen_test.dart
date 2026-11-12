import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/booking_screen.dart';
import 'package:customer/features/bookings/presentation/booking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeBookingsRepository bookings;
  late FakeLinkOpener links;

  setUp(() {
    bookings = FakeBookingsRepository();
    links = FakeLinkOpener();
  });

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
      linkOpenerProvider.overrideWithValue(links),
      secondClockProvider.overrideWith((ref) => Stream.value(now)),
      sessionProvider.overrideWith(() => SignedInSession(customer())),
    ],
  );

  testWidgets('a booking to pick up is a pass with its code and time left', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Your booking is ready'), findsOneWidget);
    expect(find.text('Waiting for pickup'), findsOneWidget);
    expect(find.text('Left to pick up'), findsOneWidget);
    expect(find.text('42:05'), findsOneWidget);
    expect(find.text('A2GU GPJ7'), findsOneWidget);
    // Tapped, the code is copied.
    expect(
      tester.getSemantics(find.text('A2GU GPJ7')),
      isSemantics(isButton: true, hint: 'Copy the code'),
    );
    // Two pieces: one code takes both, paid for together.
    expect(find.textContaining('One code for both pieces'), findsOneWidget);
    expect(find.text('Pay cash at pickup'), findsOneWidget);
    expect(find.textContaining('2 × '), findsOneWidget);
    // Where, beside what to pay: the store's place, the way there, its
    // hours today and its phone.
    expect(find.text('Andalus'), findsOneWidget);
    expect(find.text('Jaraba Street · 1.2 km'), findsOneWidget);
    expect(find.text('Directions'), findsOneWidget);
    expect(
      find.textContaining(RegExp('^Open today 8:00.AM – 11:00.PM\$')),
      findsOneWidget,
    );
    expect(find.text('0912345678'), findsOneWidget);
    expect(find.byTooltip('Close'), findsOneWidget);
  });

  testWidgets('the place opens the way there, and its phone calls', (
    tester,
  ) async {
    await open(tester);

    await tester.ensureVisible(find.text('Andalus'));
    await tester.tap(find.text('Andalus'));
    await tester.pump();
    await tester.ensureVisible(find.text('Call'));
    await tester.tap(find.text('Call'));
    await tester.pump();

    expect(links.opened, [
      directionsLink(souqAlJuma),
      Uri(scheme: 'tel', path: '+218912345678'),
    ]);
  });

  testWidgets('scanned at the counter, the pass turns to the stars', (
    tester,
  ) async {
    bookings.bookings = [booking(canRate: true)];
    await open(tester);
    expect(find.text('Your booking is ready'), findsOneWidget);

    bookings.bookings = [
      booking(status: BookingStatus.pickedUp, canRate: true),
    ];
    await tester.pump(BookingViewModel.checkEvery);
    await tester.pumpAndSettle();

    expect(find.text('Picked up. Enjoy!'), findsOneWidget);
    expect(find.text('Your booking is ready'), findsNothing);
    expect(find.text('How was Sweet shop?'), findsOneWidget);
  });

  testWidgets('cancels after asking', (tester) async {
    await open(tester);

    final link = find.text('Cancel the booking (no penalty)');
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(bookings.cancels, 0);

    await tester.tap(link);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel reservation'));
    await tester.pumpAndSettle();

    expect(bookings.cancels, 1);
    expect(find.text('Reservation cancelled'), findsOneWidget);
    // No longer a pass.
    expect(find.text('Your booking is ready'), findsNothing);
    expect(find.text('A2GU GPJ7'), findsNothing);
  });

  testWidgets('cancelling once more is said to close the offer', (
    tester,
  ) async {
    bookings.bookings = [booking(cancelEndsBooking: true)];
    await open(tester);

    final link = find.text('Cancel the booking (no penalty)');
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'The pieces go back to the offer. You cancelled it once already, so '
        "you won't be able to book this offer again.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('a first cancel says it costs nothing', (tester) async {
    await open(tester);

    final link = find.text('Cancel the booking (no penalty)');
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(
      find.text(
        "The pieces go back to the offer, and it doesn't count against you.",
      ),
      findsOneWidget,
    );
    expect(find.textContaining('book this offer again'), findsNothing);
  });

  testWidgets("cancelled by us, it says why and that it doesn't count", (
    tester,
  ) async {
    bookings.bookings = [
      booking(
        status: BookingStatus.cancelled,
        canCancel: false,
        cancelReason: CancelReason.offerRemoved,
      ),
    ];
    await open(tester);

    expect(find.text('Kaziony cancelled this booking'), findsOneWidget);
    expect(
      find.text("We took this offer down. This doesn't count against you."),
      findsOneWidget,
    );
  });

  testWidgets('cancelled by the customer, there is nothing to explain', (
    tester,
  ) async {
    bookings.bookings = [
      booking(
        status: BookingStatus.cancelled,
        canCancel: false,
        cancelReason: CancelReason.customer,
      ),
    ];
    await open(tester);

    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Kaziony cancelled this booking'), findsNothing);
    expect(find.text('This booking was cancelled'), findsNothing);
  });

  testWidgets('once over, it hides the code', (tester) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);

    expect(find.text('Your booking is ready'), findsNothing);
    expect(find.text('A2GU GPJ7'), findsNothing);
    expect(find.text('Cancel the booking (no penalty)'), findsNothing);
  });

  testWidgets('once picked up, rates the store', (tester) async {
    bookings.bookings = [
      booking(status: BookingStatus.pickedUp, canRate: true),
    ];
    await open(tester);

    expect(find.text('How was Sweet shop?'), findsOneWidget);
    expect(
      find.text('Rate the store. It helps others choose.'),
      findsOneWidget,
    );
    // Picked first, sent with the button.
    await tester.tap(find.byTooltip('2 stars'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('4 stars'));
    await tester.pumpAndSettle();
    expect(bookings.rated, isEmpty);
    await tester.tap(find.text('Send rating'));
    await tester.pumpAndSettle();

    expect(bookings.rated, [('k1', 4)]);
    expect(find.text('Thanks for rating!'), findsOneWidget);
    expect(find.text('You rated Sweet shop'), findsOneWidget);
    // Given, the stars can't be tapped again from this pickup.
    expect(find.byTooltip('4 stars'), findsNothing);
  });

  testWidgets("the store's rating from an earlier pickup, until this one", (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    bookings.bookings = [booking(status: BookingStatus.pickedUp, myRating: 3)];
    await open(tester);

    expect(find.text('You rated Sweet shop'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('3 stars')), findsOneWidget);
    expect(
      find.text('One rating per store. Pick up there again to change it.'),
      findsOneWidget,
    );
    expect(find.byTooltip('1 star'), findsNothing);
    semantics.dispose();
  });

  testWidgets('a later pickup rates the store anew', (tester) async {
    bookings.bookings = [
      booking(status: BookingStatus.pickedUp, canRate: true, myRating: 3),
    ];
    await open(tester);

    expect(find.text('You rated Sweet shop'), findsOneWidget);
    expect(
      find.text(
        'Picked up there again: rate it anew, and your new stars replace the '
        'old ones.',
      ),
      findsOneWidget,
    );
    // The stars given are there; the same again sends nothing.
    await tester.tap(find.byTooltip('3 stars'));
    await tester.pumpAndSettle();
    expect(find.text('Update rating'), findsNothing);

    await tester.tap(find.byTooltip('5 stars'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update rating'));
    await tester.pumpAndSettle();

    expect(bookings.rated, [('k1', 5)]);
    expect(find.text('Thanks for rating!'), findsOneWidget);
    expect(find.byTooltip('5 stars'), findsNothing);
  });

  testWidgets('says why a rating was refused', (tester) async {
    bookings.bookings = [
      booking(status: BookingStatus.pickedUp, canRate: true),
    ];
    bookings.rateResult = const Err(ConflictFailure(null, 'AlreadyRated'));
    await open(tester);

    await tester.tap(find.byTooltip('5 stars'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send rating'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "You've already rated this store from this pickup or a later one.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('nothing to rate before the pickup', (tester) async {
    await open(tester);

    expect(find.textContaining('How was your pickup'), findsNothing);
  });
}
