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
        branches: const [branch],
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

  testWidgets('directions open the branch in the maps', (tester) async {
    await open(tester);

    // The branch's box is the way there, near the top.
    await tester.tap(find.text('Hay Al Andalus'));
    await tester.pump();

    expect(links.opened, [directionsLink(souqAlJuma)]);
  });

  testWidgets('says so when the maps could not be opened', (tester) async {
    links = FakeLinkOpener(opens: false);
    await open(tester);

    await tester.tap(find.text('Hay Al Andalus'));
    await tester.pump();

    expect(find.text("We couldn't open the map. Try again."), findsOneWidget);
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

  testWidgets('already reserved, it shows the pickup code', (tester) async {
    offers.detail = Ok(
      OfferDetail(offer: offer(), branches: const [branch], myBookingId: 'k1'),
    );
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
