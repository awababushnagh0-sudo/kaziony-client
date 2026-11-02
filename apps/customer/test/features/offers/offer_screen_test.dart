import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/offer_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOffersRepository offers;
  late FakeBookingsRepository bookings;

  setUp(() {
    offers = FakeOffersRepository();
    bookings = FakeBookingsRepository();
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
        ],
        overrides: [
          offersRepositoryProvider.overrideWithValue(offers),
          bookingsRepositoryProvider.overrideWithValue(bookings),
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
    expect(find.text('3 of 10 left'), findsOneWidget);
  });

  testWidgets('a guest signs in before reserving', (tester) async {
    await open(tester, signedIn: false);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in page'), findsOneWidget);
    expect(bookings.reserved, isEmpty);
  });

  testWidgets('reserves two pieces and opens the pickup code', (tester) async {
    await open(tester);

    await tester.tap(find.text('Reserve now'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More'));
    await tester.pump();
    await tester.tap(find.text('Confirm reservation'));
    await tester.pumpAndSettle();

    expect(bookings.reserved, [('o1', 2)]);
    expect(find.text('pickup code page'), findsOneWidget);
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

    expect(find.text('How many?'), findsNothing);
    expect(bookings.reserved, isEmpty);
  });
}
