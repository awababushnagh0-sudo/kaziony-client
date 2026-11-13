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

  testWidgets('held until the store closes, the pass says so', (tester) async {
    bookings.bookings = [
      booking(
        left: const Duration(minutes: 40),
        location: placeOpenUntil(const Duration(hours: 12, minutes: 40)),
      ),
    ];
    await open(tester);

    expect(find.text('40:00'), findsOneWidget);
    expect(
      find.textContaining(RegExp('^Until the store closes at 12:40.PM\$')),
      findsOneWidget,
    );
  });

  testWidgets('held for the usual time, nothing more is said', (tester) async {
    await open(tester);

    expect(find.textContaining('Until the store closes'), findsNothing);
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

  group('at a store that delivers', () {
    testWidgets('offers its number to have the booking brought', (
      tester,
    ) async {
      bookings.bookings = [booking(deliveryPhone: '+218921234567')];
      await open(tester);

      expect(find.text('This shop delivers'), findsOneWidget);
      expect(
        find.text(
          'Call \u20660921234567\u2069 and read them your code. Delivery and '
          'any fee are arranged with the store.',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('This shop delivers'));
      await tester.tap(find.text('This shop delivers'));
      await tester.pump();

      expect(links.opened, [Uri(scheme: 'tel', path: '+218921234567')]);
    });

    testWidgets("says nothing of delivery at a store that doesn't", (
      tester,
    ) async {
      await open(tester);

      expect(find.text('This shop delivers'), findsNothing);
    });

    testWidgets('once on its way, cancelling is a call to the store', (
      tester,
    ) async {
      bookings.bookings = [
        booking(
          status: BookingStatus.outForDelivery,
          canCancel: false,
          // Its time would be up: on its way, it has none.
          left: const Duration(minutes: -30),
          deliveryPhone: '+218921234567',
          sentForDeliveryAt: libyaTime(2026, 11, 12, 14, 20),
        ),
      ];
      await open(tester);

      expect(find.text('Your booking is on its way'), findsOneWidget);
      expect(find.text('On its way'), findsOneWidget);
      expect(
        find.textContaining("With the store's driver since 2:20"),
        findsOneWidget,
      );
      expect(find.text('Left to pick up'), findsNothing);
      expect(find.text('Pay the driver in cash'), findsOneWidget);
      // The code still works at the door.
      expect(find.text('A2GU GPJ7'), findsOneWidget);
      expect(find.text('Cancel the booking (no penalty)'), findsNothing);

      await tester.ensureVisible(find.text('To cancel, call the store'));
      await tester.tap(find.text('To cancel, call the store'));
      await tester.pump();
      expect(links.opened, [Uri(scheme: 'tel', path: '+218921234567')]);
    });

    testWidgets('says when the driver has it, and when it was delivered', (
      tester,
    ) async {
      await open(tester);

      bookings.bookings = [
        booking(
          status: BookingStatus.outForDelivery,
          canCancel: false,
          sentForDeliveryAt: now,
        ),
      ];
      await tester.pump(BookingViewModel.checkEvery);
      await tester.pumpAndSettle();
      expect(find.text("The store's driver has your booking."), findsOneWidget);

      bookings.bookings = [
        booking(
          status: BookingStatus.pickedUp,
          canCancel: false,
          canRate: true,
          sentForDeliveryAt: now,
        ),
      ];
      await tester.pump(BookingViewModel.checkEvery);
      await tester.pumpAndSettle();
      expect(find.text('Delivered. Enjoy!'), findsOneWidget);
    });

    testWidgets('says the store cancelled a delivery that didn\'t happen', (
      tester,
    ) async {
      bookings.bookings = [
        booking(
          status: BookingStatus.cancelled,
          canCancel: false,
          cancelReason: CancelReason.notDelivered,
          sentForDeliveryAt: now,
        ),
      ];
      await open(tester);

      expect(find.text('The store cancelled this delivery'), findsOneWidget);
      expect(
        find.text(
          "The store says the delivery didn't happen. This doesn't count "
          'against you.',
        ),
        findsOneWidget,
      );
    });
  });

  group('reporting a problem', () {
    /// Taps [text], scrolled to first: the sheet is taller than the test's
    /// screen.
    Future<void> tapOn(WidgetTester tester, String text) async {
      await tester.ensureVisible(find.text(text));
      await tester.pumpAndSettle();
      await tester.tap(find.text(text));
      await tester.pumpAndSettle();
    }

    testWidgets('sends why, with what happened, from the pass', (tester) async {
      bookings.bookings = [booking(canReport: true)];
      await open(tester);

      await tapOn(tester, 'Report a problem');
      expect(find.text('What went wrong?'), findsOneWidget);
      // Nothing to send before a reason.
      await tapOn(tester, 'Send report');
      expect(bookings.reports, isEmpty);

      await tapOn(tester, 'The store was closed');
      await tester.enterText(
        find.byType(EditableText),
        ' I came at 8:30 and it was shut ',
      );
      await tapOn(tester, 'Send report');

      expect(bookings.reports, [
        ('k1', ReportReason.storeClosed, 'I came at 8:30 and it was shut'),
      ]);
      expect(
        find.text('We got your report and will look into it.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('You reported a problem'));
      expect(find.text("We're looking into it."), findsOneWidget);
      expect(find.text('Report a problem'), findsNothing);
    });

    testWidgets('needs a note for something else', (tester) async {
      bookings.bookings = [booking(canReport: true)];
      await open(tester);
      await tapOn(tester, 'Report a problem');

      await tapOn(tester, 'Something else');
      await tapOn(tester, 'Send report');
      expect(bookings.reports, isEmpty);
    });

    testWidgets('says why it was refused, in the app\'s words', (tester) async {
      bookings
        ..bookings = [booking(canReport: true)]
        ..reportResult = const Err(
          ConflictFailure('Too late', 'ReportTooLate'),
        );
      await open(tester);
      await tapOn(tester, 'Report a problem');
      await tapOn(tester, 'Something was wrong with it');
      await tapOn(tester, 'Send report');

      expect(
        find.text('This booking ended too long ago to report.'),
        findsOneWidget,
      );
    });

    testWidgets('says what came of a report on a past booking', (tester) async {
      bookings.bookings = [
        booking(
          status: BookingStatus.expired,
          left: const Duration(minutes: -30),
          canCancel: false,
          report: BookingReport(
            resolved: true,
            strikeRemoved: true,
            createdAt: now,
          ),
        ),
      ];
      await open(tester);

      expect(find.text('You reported a problem'), findsOneWidget);
      expect(
        find.text(
          'We looked into it: this booking no longer counts against you.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('offers nothing once it can no longer be reported', (
      tester,
    ) async {
      bookings.bookings = [
        booking(
          status: BookingStatus.pickedUp,
          left: const Duration(days: -8),
          canCancel: false,
        ),
      ];
      await open(tester);

      expect(find.text('Report a problem'), findsNothing);
    });
  });
}
