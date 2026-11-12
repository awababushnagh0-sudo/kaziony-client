import 'dart:async';

import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/notifications/domain/app_notification.dart';
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
  late FakeServiceAreaRepository areas;
  late FakeNotificationsRepository notifications;

  setUp(() {
    offers = FakeOffersRepository();
    stores = FakeStoresRepository();
    areas = FakeServiceAreaRepository();
    notifications = FakeNotificationsRepository();
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
          stubPage(Routes.notifications, 'notifications page'),
        ],
        overrides: [
          offersRepositoryProvider.overrideWithValue(offers),
          storesRepositoryProvider.overrideWithValue(stores),
          serviceAreaRepositoryProvider.overrideWithValue(areas),
          notificationsRepositoryProvider.overrideWithValue(notifications),
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

  testWidgets('says where offers are from and how far around', (tester) async {
    await open(tester);

    expect(find.text('My current location'), findsOneWidget);
    expect(find.text('Offers within 10 km'), findsOneWidget);
  });

  testWidgets('says the distance as it is when it is not whole', (
    tester,
  ) async {
    areas.radius = const Ok(7.5);
    await open(tester);

    expect(find.text('Offers within 7.5 km'), findsOneWidget);
  });

  testWidgets('without the settings, still says the offers are nearby', (
    tester,
  ) async {
    areas.radius = const Err(NoConnectionFailure());
    await open(tester);

    expect(find.text('Offers nearby'), findsOneWidget);
  });

  testWidgets("the bell counts the notifications the customer hasn't seen", (
    tester,
  ) async {
    notifications.unread = const Ok(2);
    await open(tester, signedIn: true);

    final bell = find.byTooltip('Notifications');
    expect(find.descendant(of: bell, matching: find.text('2')), findsOneWidget);
  });

  testWidgets('the bell opens the notifications', (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('notifications page'), findsOneWidget);
  });

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

  testWidgets('picking a kind of store shows the rows\' skeleton meanwhile', (
    tester,
  ) async {
    await open(tester);
    offers.browseGate = Completer<void>();

    await tester.tap(find.text('Bakeries'));
    await tester.pump();

    expect(find.byWidgetPredicate((w) => w is SSkeleton), findsWidgets);
    expect(find.byWidgetPredicate((w) => w is SLoadingView), findsNothing);

    offers.browseGate!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(OfferCard), findsWidgets);
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
    expect(find.text('Your favorite stores'), findsNothing);
    await tester.tap(find.text('Sweet shop'));
    await tester.pumpAndSettle();

    expect(find.text('store page'), findsOneWidget);
  });

  testWidgets('shows the favorite stores of a signed-in customer', (
    tester,
  ) async {
    stores.followedStores = const [storeSummary];
    await open(tester, signedIn: true);

    await tester.scrollUntilVisible(
      find.text('Your favorite stores').hitTestable(),
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
