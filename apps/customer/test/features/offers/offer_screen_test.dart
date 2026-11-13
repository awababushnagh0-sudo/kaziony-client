import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/offer_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOffersRepository offers;
  late FakeBookingsRepository bookings;
  late FakeLinkOpener links;

  setUp(() {
    offers = FakeOffersRepository();
    bookings = FakeBookingsRepository();
    links = FakeLinkOpener();
  });

  Future<void> open(WidgetTester tester, {bool signedIn = true}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.offer('o1'),
        routes: [
          GoRoute(
            path: Routes.offerPattern,
            builder: (_, state) =>
                OfferScreen(offerId: state.pathParameters['offerId']!),
          ),
          stubPage(Routes.signIn, 'sign-in page'),
          stubPage(Routes.bookingPattern, 'pickup code page'),
          stubPage(Routes.storePattern, 'store page'),
        ],
        overrides: [
          offersRepositoryProvider.overrideWithValue(offers),
          bookingsRepositoryProvider.overrideWithValue(bookings),
          linkOpenerProvider.overrideWithValue(links),
          browseLocationProvider.overrideWith(
            () => BrowseLocationController(
              const BrowseLocation(souqAlJuma, pinned: false),
            ),
          ),
          minuteClockProvider.overrideWith((ref) => Stream.value(now)),
          if (signedIn)
            sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );

  testWidgets('shows the offer and what is left', (tester) async {
    await open(tester);

    expect(find.text('Kunafa box'), findsOneWidget);
    expect(find.text('Sweet shop'), findsOneWidget);
    expect(find.text('Left'), findsOneWidget);
    expect(find.text('3 of 10'), findsOneWidget);
  });

  testWidgets('shows the store\'s rating once it has one', (tester) async {
    offers.offers = [offer(rating: const StoreRating(average: 4.5, count: 37))];
    await open(tester);

    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(37)'), findsOneWidget);
  });

  testWidgets('says nothing of a rating before the first', (tester) async {
    await open(tester);

    expect(find.text('(0)'), findsNothing);
    expect(find.textContaining('0.0'), findsNothing);
  });

  testWidgets('picking up within a day shows the hours, today', (tester) async {
    await open(tester);

    // The time's own format puts a narrow space before AM and PM.
    expect(find.text('Pick up'), findsOneWidget);
    expect(
      find.textContaining(RegExp('^Today 11:00.AM – 5:00.PM\$')),
      findsOneWidget,
    );
  });

  testWidgets('over several days, until when and which day', (tester) async {
    offers.offers = [
      offer(
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: now.add(const Duration(days: 1, hours: 9)),
      ),
    ];
    await open(tester);

    expect(
      find.textContaining(RegExp('^Tomorrow until 9:00.PM\$')),
      findsOneWidget,
    );
  });

  testWidgets('pickup instructions in our words, until the store has its own', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Pickup instructions'), findsOneWidget);
    expect(
      find.text(
        "Show your pickup code to a staff member at the store, and they'll "
        'hand you your order.',
      ),
      findsOneWidget,
    );
  });

  testWidgets("the store's own pickup instructions", (tester) async {
    offers.detail = Ok(
      OfferDetail(
        offer: offer(),
        pickupInstructions: 'Ring the bell at the side door.',
      ),
    );
    await open(tester);

    expect(find.text('Ring the bell at the side door.'), findsOneWidget);
    expect(find.textContaining('Show your pickup code'), findsNothing);
  });

  testWidgets('a guest is asked to sign in before reserving', (tester) async {
    await open(tester, signedIn: false);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to reserve'), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to reserve'), findsNothing);
    expect(find.text('sign-in page'), findsOneWidget);
    expect(bookings.reserved, isEmpty);
  });

  testWidgets('reserves two pieces and opens the pickup code', (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('More'));
    await tester.pump();
    // At the most it allows (two per customer), it can't go higher.
    await tester.tap(find.byTooltip('More'));
    await tester.pump();
    await tester.tap(find.text('Reserve 2'));
    await tester.pumpAndSettle();
    expect(find.text('Reserve 2 pieces?'), findsOneWidget);
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(bookings.reserved, [('o1', 2)]);
    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('with only one to take, there is nothing to pick', (
    tester,
  ) async {
    offers.offers = [offer(remaining: 1)];
    await open(tester);

    expect(find.byTooltip('More'), findsNothing);
    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(bookings.reserved, [('o1', 1)]);
  });

  testWidgets('the store opens its page', (tester) async {
    await open(tester);

    await tester.tap(find.text('Sweet shop'));
    await tester.pumpAndSettle();

    expect(find.text('store page'), findsOneWidget);
  });

  testWidgets('scrolled, the photo folds into a bar with the title', (
    tester,
  ) async {
    await open(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    // The back button stays; the name left the photo for the bar.
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.text('Kunafa box'), findsOneWidget);
  });

  testWidgets('where to pick up: the area, address, hours today and phone', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Andalus'), findsOneWidget);
    expect(find.text('Jaraba Street · 1.2 km'), findsOneWidget);
    // On a Monday, as the store said.
    expect(
      find.textContaining(RegExp('^Open today 8:00.AM – 11:00.PM\$')),
      findsOneWidget,
    );
    expect(find.text('0912345678'), findsOneWidget);
    expect(find.textContaining('branch'), findsNothing);
  });

  testWidgets('the place opens the way there in the maps', (tester) async {
    await open(tester);

    // The place's box is the way there, near the top.
    await tester.tap(find.text('Andalus'));
    await tester.pump();

    expect(links.opened, [directionsLink(souqAlJuma)]);
  });

  testWidgets("the place's phone calls it", (tester) async {
    await open(tester);

    final phone = find.text('0912345678');
    await tester.ensureVisible(phone);
    await tester.pumpAndSettle();
    await tester.tap(phone);
    await tester.pump();

    expect(links.opened, [Uri(scheme: 'tel', path: '+218912345678')]);
  });

  testWidgets('a store that said nothing of its hours or phone', (
    tester,
  ) async {
    offers.offers = [
      offer(
        location: const StoreLocation(point: souqAlJuma, area: 'Andalus'),
      ),
    ];
    await open(tester);

    expect(find.text('Andalus'), findsOneWidget);
    expect(find.textContaining('today'), findsNothing);
    expect(find.text('Call'), findsNothing);
  });

  testWidgets('says so when the maps could not be opened', (tester) async {
    links = FakeLinkOpener(opens: false);
    await open(tester);

    await tester.tap(find.text('Andalus'));
    await tester.pump();

    expect(find.text("We couldn't open the map. Try again."), findsOneWidget);
  });

  testWidgets('says how long a reservation is held', (tester) async {
    await open(tester);

    expect(find.text('You have 2 hours to pick up'), findsOneWidget);
  });

  testWidgets('the store closing first, it says so before booking', (
    tester,
  ) async {
    offers.offers = [
      offer(location: placeOpenUntil(const Duration(hours: 12, minutes: 50))),
    ];
    await open(tester);

    expect(find.text('Closes in 50 minutes'), findsOneWidget);
    // Held until the last pickup, 15 minutes before it closes.
    expect(find.text('You have 35 minutes to pick up'), findsOneWidget);
    expect(
      find.textContaining(
        RegExp('^Last pickup 12:35.PM, before the store closes at 12:50.PM.\$'),
      ),
      findsOneWidget,
    );
    expect(find.text('Less time'), findsOneWidget);
    expect(
      find.textContaining(
        RegExp('^Only 35 minutes to pick up: last pickup 12:35.PM\$'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        RegExp(
          '^You have 35 minutes to pick up: the last pickup is 12:35.PM, '
          'before the store closes. You pay cash then.\$',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'while the store is closed, says when it opens in place of the button',
    (tester) async {
      offers.offers = [
        offer(
          remaining: 5,
          location: placeOpenUntil(
            const Duration(hours: 23),
            opens: const Duration(hours: 14),
          ),
        ),
      ];
      await open(tester);

      expect(find.text('Closed now'), findsOneWidget);
      expect(find.text('Booking opens when the store does'), findsOneWidget);
      // Under the hours, in Good to know, and at the foot.
      expect(find.textContaining(RegExp('^Opens 2:00.PM\$')), findsNWidgets(3));
      expect(find.text('The store is closed now'), findsOneWidget);
      // Nothing to tap, nor how many to take.
      expect(find.text('Reserve now'), findsNothing);
      expect(find.byTooltip('More'), findsNothing);
    },
  );

  testWidgets('too close to closing, booking has stopped', (tester) async {
    offers.offers = [
      // Booking stops 35 minutes before it closes.
      offer(location: placeOpenUntil(const Duration(hours: 12, minutes: 30))),
    ];
    await open(tester);

    expect(find.text('Too late to book'), findsOneWidget);
    expect(
      find.textContaining(RegExp('^The store closes at 12:30.PM\$')),
      findsOneWidget,
    );
    expect(
      find.text('Booking has stopped: the store closes soon'),
      findsOneWidget,
    );
    expect(find.text('Reserve now'), findsNothing);
  });

  testWidgets('a code good until the end is given while closed', (
    tester,
  ) async {
    offers.offers = [
      offer(
        limited: false,
        location: placeOpenUntil(
          const Duration(hours: 23),
          opens: const Duration(hours: 14),
        ),
      ),
    ];
    await open(tester);

    expect(find.text('Reserve now'), findsOneWidget);
  });

  testWidgets('while booking is paused, the button says until when', (
    tester,
  ) async {
    bookings.standingNow = BookingStanding(
      strikes: 0,
      strikesBeforePause: 3,
      nextPauseDays: 7,
      activeReservations: 0,
      maxActiveReservations: 3,
      pausedUntil: now.add(const Duration(days: 2, hours: 3)),
    );
    await open(tester);

    final paused = find.textContaining(
      RegExp('^Booking paused until Wed, Nov 4 3:00.PM\$'),
    );
    expect(paused, findsOneWidget);
    expect(find.text('Reserve now'), findsNothing);
    expect(find.byTooltip('More'), findsNothing);
    await tester.tap(paused);
    await tester.pumpAndSettle();
    expect(find.text('Confirm reservation'), findsNothing);
  });

  testWidgets('a guest is never told of a pause', (tester) async {
    bookings.standingNow = BookingStanding(
      strikes: 0,
      strikesBeforePause: 3,
      nextPauseDays: 7,
      activeReservations: 0,
      maxActiveReservations: 3,
      pausedUntil: now.add(const Duration(days: 2)),
    );
    await open(tester, signedIn: false);

    expect(find.text('Reserve now'), findsOneWidget);
    expect(bookings.standingLoads, 0);
  });

  testWidgets('holding the most at once, it says so before reserving', (
    tester,
  ) async {
    bookings.standingNow = const BookingStanding(
      strikes: 0,
      strikesBeforePause: 3,
      nextPauseDays: 3,
      activeReservations: 3,
      maxActiveReservations: 3,
    );
    await open(tester);

    expect(
      find.text(
        'You hold 3 reservations, the most at once. Pick one up or cancel '
        'one to book this one.',
      ),
      findsOneWidget,
    );
    expect(find.text('Reserve now'), findsOneWidget);
  });

  testWidgets('the most at once is only for counted offers', (tester) async {
    bookings.standingNow = const BookingStanding(
      strikes: 0,
      strikesBeforePause: 3,
      nextPauseDays: 3,
      activeReservations: 3,
      maxActiveReservations: 3,
    );
    offers.offers = [offer(limited: false)];
    await open(tester);

    expect(find.textContaining('the most at once'), findsNothing);
  });

  testWidgets('says in the sheet why a reservation was refused', (
    tester,
  ) async {
    bookings.reserveResult = const Err(
      ConflictFailure('Only 1 left', 'NotEnoughLeft'),
    );
    await open(tester);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(
      find.text("There aren't that many left. Try fewer."),
      findsOneWidget,
    );
    expect(find.text('pickup code page'), findsNothing);
  });

  testWidgets('refused as the store closed meanwhile, the sheet says so', (
    tester,
  ) async {
    bookings.reserveResult = const Err(
      ConflictFailure('The store is closed now', 'StoreClosed'),
    );
    await open(tester);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(
      find.text('The store is closed now. Book once it opens.'),
      findsOneWidget,
    );
  });

  testWidgets('refused for a pause, the sheet says until when', (tester) async {
    bookings.reserveResult = const Err(ForbiddenFailure(code: 'ClaimBanned'));
    await open(tester);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    // Paused meanwhile: the refusal brings the standing up to date.
    bookings.standingNow = BookingStanding(
      strikes: 0,
      strikesBeforePause: 3,
      nextPauseDays: 7,
      activeReservations: 0,
      maxActiveReservations: 3,
      pausedUntil: now.add(const Duration(days: 2, hours: 3)),
    );
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(RegExp('^Booking paused until Wed, Nov 4 3:00.PM\$')),
      findsNWidgets(2),
    );
  });

  testWidgets('refused after cancelling it twice, the sheet says so', (
    tester,
  ) async {
    bookings.reserveResult = const Err(
      ConflictFailure('Cancelled too often', 'CancelledTooOften'),
    );
    await open(tester);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(
      find.text("You cancelled this offer twice, so you can't book it again."),
      findsOneWidget,
    );
  });

  testWidgets('already reserved, it shows the pickup code', (tester) async {
    offers.detail = Ok(OfferDetail(offer: offer(), myBookingId: 'k1'));
    await open(tester);

    expect(find.text('Reserve now'), findsNothing);
    await tester.tap(find.text('Show my pickup code'));
    await tester.pumpAndSettle();

    expect(find.text('pickup code page'), findsOneWidget);
  });

  testWidgets('sold out, it cannot be reserved', (tester) async {
    offers.offers = [offer(remaining: 0)];
    await open(tester);

    await tester.tap(find.text('Sold out'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm reservation'), findsNothing);
    expect(bookings.reserved, isEmpty);
  });
}
