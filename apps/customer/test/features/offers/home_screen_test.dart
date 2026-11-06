import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/home_screen.dart';
import 'package:customer/features/offers/presentation/widgets/offer_card.dart';
import 'package:customer/features/stores/domain/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOffersRepository offers;
  late FakeStoresRepository stores;

  setUp(() {
    offers = FakeOffersRepository();
    stores = FakeStoresRepository();
  });

  Future<void> open(WidgetTester tester, {bool signedIn = false}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.home,
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: Routes.offers,
            builder: (_, state) => SText('offers ${state.uri.query}'),
          ),
          stubPage(Routes.offerPattern, 'offer page'),
          stubPage(Routes.storePattern, 'store page'),
        ],
        overrides: [
          offersRepositoryProvider.overrideWithValue(offers),
          storesRepositoryProvider.overrideWithValue(stores),
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

  /// The page, which scrolls down (the rows scroll sideways).
  final page = find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down,
  );

  testWidgets('shows the rows of offers and opens one', (tester) async {
    await open(tester);

    expect(find.text('Ending soon'), findsOneWidget);
    expect(find.text('Bakeries'), findsOneWidget);
    expect(find.text('Kunafa box'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Near you').hitTestable(),
      200,
      scrollable: page,
    );

    final card = find
        .ancestor(of: find.text('Kunafa box'), matching: find.byType(OfferCard))
        .first;
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets('"See all" lists the row\'s offers', (tester) async {
    await open(tester);

    await tester.ensureVisible(find.text('See all').first);
    await tester.tap(find.text('See all').first);
    await tester.pumpAndSettle();

    expect(find.text('offers sort=endingSoon'), findsOneWidget);
  });

  testWidgets('ends with the way to every offer, newest first', (tester) async {
    await open(tester);

    final allOffers = find.text('Browse every offer around you');
    await tester.scrollUntilVisible(
      allOffers.hitTestable(),
      200,
      scrollable: page,
    );
    expect(find.text('1 offer waiting, newest first'), findsOneWidget);
    expect(find.text('All offers'), findsNothing);
    await tester.tap(allOffers);
    await tester.pumpAndSettle();

    expect(find.text('offers sort=newest'), findsOneWidget);
  });

  testWidgets('shows the stores near you and opens one', (tester) async {
    await open(tester);

    await tester.scrollUntilVisible(
      find.text('Sweet shop').hitTestable(),
      200,
      scrollable: page,
    );
    expect(find.text('Stores near you'), findsOneWidget);
    expect(find.text('Stores you follow'), findsNothing);
    await tester.tap(find.text('Sweet shop'));
    await tester.pumpAndSettle();

    expect(find.text('store page'), findsOneWidget);
  });

  testWidgets('shows the stores a signed-in customer follows', (tester) async {
    stores.followedStores = const [storeSummary];
    await open(tester, signedIn: true);

    await tester.scrollUntilVisible(
      find.text('Stores you follow').hitTestable(),
      200,
      scrollable: page,
    );
  });

  testWidgets('says when there are no offers around', (tester) async {
    offers.offers = [];
    await open(tester);

    expect(find.text('No offers near you right now'), findsOneWidget);
    expect(find.text('Near you'), findsNothing);
    expect(find.text('Stores near you'), findsNothing);
    expect(find.text('Browse every offer around you'), findsNothing);
  });
}
