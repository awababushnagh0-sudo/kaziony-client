import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/core/widgets/offer_card.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/home/domain/store_stats.dart';
import 'package:partner/features/home/presentation/home_screen.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  const support = SupportContact(
    phone: '+218910000000',
    whatsapp: '218920000000',
    email: 'support@kaziony.ly',
    hoursAr: 'السبت إلى الخميس',
    hoursEn: 'Saturday to Thursday',
  );

  late FakeStoreRepository storeRepository;
  late FakeLinkOpener links;

  Future<void> open(
    WidgetTester tester, {
    StoreMembership? member,
    List<StoreMembership>? stores,
    List<Claim>? claims,
    List<Offer>? offers,
    FakeStatsRepository? stats,
    Store? details,
  }) {
    storeRepository = FakeStoreRepository();
    if (details != null) storeRepository.getResult = Ok(details);
    links = FakeLinkOpener();
    // The whole page, so every section is on screen.
    tester.view
      ..physicalSize = const Size(800, 2000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return pumpPartnerPages(
      tester,
      initial: Routes.home,
      overrides: [
        currentStoreProvider.overrideWithValue(member ?? store('a')),
        myStoresProvider.overrideWithValue(stores ?? [member ?? store('a')]),
        statsRepositoryProvider.overrideWithValue(
          stats ?? FakeStatsRepository(),
        ),
        claimRepositoryProvider.overrideWithValue(
          FakeClaimRepository(claims ?? [claim('ABCD2345')]),
        ),
        offerRepositoryProvider.overrideWithValue(
          FakeOfferRepository(offers ?? [offer('o1')]),
        ),
        storeRepositoryProvider.overrideWithValue(storeRepository),
        supportContactProvider.overrideWith((ref) async => support),
        linkOpenerProvider.overrideWithValue(links),
        // No ticking clock in tests: the page reads the time when it builds.
        minuteClockProvider.overrideWith((ref) => const Stream.empty()),
      ],
      routes: [
        GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
        stubPage(Routes.pickups, 'pickups page'),
        stubPage(Routes.deliveries, 'deliveries page'),
        stubPage(Routes.offers, 'offers page'),
        stubPage(Routes.storeInfo, 'store info page'),
        stubPage(Routes.location, 'location page'),
        GoRoute(
          path: Routes.offer(':id'),
          builder: (_, state) => SText('offer ${state.pathParameters['id']}'),
        ),
        GoRoute(
          path: Routes.claim(':code'),
          builder: (_, state) => SText('claim ${state.pathParameters['code']}'),
        ),
      ],
    );
  }

  testWidgets("shows the owner today's numbers, who's coming and the offers", (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('of 14 reserved today'), findsOneWidget);
    expect(find.text('Not picked up'), findsOneWidget);
    expect(find.text('Live offers'), findsOneWidget);
    expect(find.text('Sara'), findsOneWidget);
    expect(find.text('40 min'), findsOneWidget);
    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.text('left of 10'), findsOneWidget);
  });

  testWidgets('shows staff only their counter numbers', (tester) async {
    await open(tester, member: store('a', isOwner: false));

    expect(find.text('Today'), findsOneWidget);
    // On the band, and on the offer's card.
    expect(find.text('Picked up'), findsWidgets);
    expect(find.text('Not picked up'), findsNothing);
    expect(find.text('Last 30 days'), findsNothing);
  });

  testWidgets('says which store the day is for to members of several', (
    tester,
  ) async {
    // A brand's two places: each its own store, with its own day.
    final andalus = store('a', area: 'Hay Al Andalus');
    await open(
      tester,
      member: andalus,
      stores: [
        andalus,
        store('b', area: 'Gargaresh'),
      ],
    );

    expect(find.text('Today at Store a · Hay Al Andalus'), findsOneWidget);
  });

  testWidgets('marks customers due soon and leaves out ones that ran out', (
    tester,
  ) async {
    await open(
      tester,
      claims: [
        claim(
          'GONE2345',
          customerName: 'Late',
          heldFor: const Duration(minutes: -1),
        ),
        claim('SOON2345', heldFor: const Duration(minutes: 12)),
      ],
    );

    expect(find.text('Late'), findsNothing);
    expect(find.text('12 min'), findsOneWidget);
    expect(find.text('Soonest due in 12 min'), findsOneWidget);

    await tester.tap(find.text('Sara'));
    await tester.pumpAndSettle();
    expect(find.text('claim SOON2345'), findsOneWidget);
  });

  testWidgets('says once when no one is coming and nothing is live', (
    tester,
  ) async {
    await open(tester, claims: [], offers: []);

    expect(find.text('A quiet day so far'), findsOneWidget);
    expect(find.text('No one is on their way right now.'), findsOneWidget);
    expect(find.text('See all'), findsNothing);
    expect(find.text('No live offers right now.'), findsNothing);
    expect(find.text('Post an offer'), findsOneWidget);
  });

  testWidgets("a store that isn't live isn't offered to post yet", (
    tester,
  ) async {
    await open(
      tester,
      claims: [],
      offers: [],
      details: storeDetails(isActive: false),
    );

    expect(find.text('A quiet day so far'), findsOneWidget);
    expect(find.text('Your store is ready'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);
  });

  testWidgets("staff aren't offered to post", (tester) async {
    await open(
      tester,
      member: store('a', isOwner: false),
      claims: [],
      offers: [],
    );

    expect(find.text('A quiet day so far'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);
  });

  testWidgets('says which list is empty when the other is not', (tester) async {
    await open(tester, claims: []);

    expect(find.text('No one is on their way right now.'), findsOneWidget);
    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.text('A quiet day so far'), findsNothing);
  });

  testWidgets('shows five offers in a sideways row, without their state', (
    tester,
  ) async {
    await open(tester, offers: [for (var i = 1; i <= 6; i++) offer('o$i')]);

    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.text('Offer o5'), findsOneWidget);
    expect(find.text('Offer o6'), findsNothing);
    // Side by side, not stacked.
    expect(
      tester.getTopLeft(find.byType(OfferCard).at(1)).dy,
      tester.getTopLeft(find.byType(OfferCard).first).dy,
    );
    expect(find.text('Live'), findsNothing);
  });

  testWidgets('the row uses the wide cards', (tester) async {
    await open(tester, offers: [offer('o1'), offer('o2')]);

    // The test's page is 800 wide, so the card is at its widest.
    expect(tester.getSize(find.byType(OfferCard).first).width, 420);
  });

  testWidgets('one offer takes the width, with nothing to scroll to', (
    tester,
  ) async {
    await open(tester);

    // The test's page is 800 wide, less its sides.
    expect(tester.getSize(find.byType(OfferCard)).width, 768);
  });

  testWidgets('"See all" opens the offers', (tester) async {
    await open(tester, claims: []);

    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();

    expect(find.text('offers page'), findsOneWidget);
  });

  testWidgets('a big card opens its offer', (tester) async {
    await open(tester);

    await tester.tap(find.text('Offer o1'));
    await tester.pumpAndSettle();

    expect(find.text('offer o1'), findsOneWidget);
  });

  testWidgets('unlimited offers do not say what is left', (tester) async {
    await open(tester, offers: [offer('o1', type: OfferType.unlimited)]);

    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.textContaining('left of'), findsNothing);
    expect(find.text('No limit'), findsOneWidget);
  });

  testWidgets('reminds the store of deliveries to close, and opens them', (
    tester,
  ) async {
    await open(
      tester,
      stats: FakeStatsRepository()..result = Ok(stats(outForDelivery: 2)),
    );

    expect(
      find.text(
        "Say if each was delivered. After a day, they're taken as "
        'delivered.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('2 deliveries to close'));
    await tester.pumpAndSettle();
    expect(find.text('deliveries page'), findsOneWidget);
  });

  testWidgets('says nothing of deliveries when none are out', (tester) async {
    await open(tester);

    expect(find.textContaining('to close'), findsNothing);
  });

  testWidgets('the band opens who is on their way', (tester) async {
    await open(tester);

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();

    expect(find.text('pickups page'), findsOneWidget);
  });

  testWidgets('the live offers number opens the offers', (tester) async {
    await open(tester);

    await tester.tap(find.text('Live offers'));
    await tester.pumpAndSettle();

    expect(find.text('offers page'), findsOneWidget);
  });

  testWidgets('the numbers without a list behind them stay on the page', (
    tester,
  ) async {
    await open(tester);

    // The band's comes first; the offer's card has one too.
    await tester.tap(find.text('Picked up').first);
    await tester.pumpAndSettle();

    expect(find.text('pickups page'), findsNothing);
    expect(find.text('offer o1'), findsNothing);
  });

  testWidgets('offers to try again when the numbers fail to load', (
    tester,
  ) async {
    final repository = FakeStatsRepository()
      ..result = const Err(NoConnectionFailure());
    await open(tester, stats: repository);
    expect(find.text('Try again'), findsOneWidget);

    repository.result = Ok(stats());
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Sara'), findsOneWidget);
  });

  testWidgets('says nothing about going live once customers see the store', (
    tester,
  ) async {
    await open(tester);

    expect(find.text("Customers can't see your store yet"), findsNothing);
    expect(find.text('Your store is ready'), findsNothing);
  });

  testWidgets('tells the owner what customers need before they can see it', (
    tester,
  ) async {
    await open(
      tester,
      details: storeDetails(
        isActive: false,
        missingToGoLive: GoLiveItem.values,
      ),
    );

    expect(find.text("Customers can't see your store yet"), findsOneWidget);
    expect(
      find.text('Add these, then our team will turn it on for customers.'),
      findsOneWidget,
    );
    expect(find.text('Logo'), findsOneWidget);
    expect(find.text('Pickup instructions'), findsOneWidget);
    expect(find.text('Opening hours'), findsOneWidget);
    // In that order.
    expect(
      tester.getTopLeft(find.text('Logo')).dy,
      lessThan(tester.getTopLeft(find.text('Pickup instructions')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Pickup instructions')).dy,
      lessThan(tester.getTopLeft(find.text('Opening hours')).dy),
    );
    expect(find.text('Your store is ready'), findsNothing);
  });

  for (final (item, label, page) in [
    (GoLiveItem.logo, 'Logo', 'store info page'),
    (GoLiveItem.pickupInstructions, 'Pickup instructions', 'store info page'),
    (GoLiveItem.openingHours, 'Opening hours', 'location page'),
  ]) {
    testWidgets('"$label" opens where the owner adds it', (tester) async {
      await open(
        tester,
        details: storeDetails(isActive: false, missingToGoLive: [item]),
      );

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(find.text(page), findsOneWidget);
    });
  }

  testWidgets("staff see what's missing, without opening it", (tester) async {
    await open(
      tester,
      member: store('a', isOwner: false),
      details: storeDetails(
        isActive: false,
        missingToGoLive: [GoLiveItem.logo],
      ),
    );

    expect(find.text("Customers can't see your store yet"), findsOneWidget);
    expect(
      find.text("The store's owner needs to add these first."),
      findsOneWidget,
    );

    await tester.tap(find.text('Logo'));
    await tester.pumpAndSettle();
    expect(find.text('store info page'), findsNothing);
  });

  testWidgets('a ready store waits for our team, and the owner can ask', (
    tester,
  ) async {
    await open(tester, details: storeDetails(isActive: false));

    expect(find.text('Your store is ready'), findsOneWidget);
    expect(
      find.text('Our team will turn it on for customers soon.'),
      findsOneWidget,
    );
    expect(find.text("Customers can't see your store yet"), findsNothing);

    await tester.tap(find.text('Message us on WhatsApp'));
    await tester.pumpAndSettle();

    final link = links.opened.single;
    expect('${link.origin}${link.path}', 'https://wa.me/218920000000');
    expect(
      link.queryParameters['text'],
      'Hello, my store is ready. Please turn it on for customers: '
      'Store a · Hay Al Andalus',
    );
  });

  testWidgets('a store our team turned off says so, and the owner can ask '
      'why', (tester) async {
    await open(
      tester,
      details: storeDetails(
        isActive: false,
        wasLive: true,
        missingToGoLive: [GoLiveItem.logo],
      ),
    );

    expect(find.text('Your store is off for customers'), findsOneWidget);
    expect(
      find.text(
        "Customers can't see it or its offers right now. Bookings already "
        'made can still be picked up.',
      ),
      findsOneWidget,
    );
    // Not waiting for its first day: neither the list nor the wait.
    expect(find.text('Your store is ready'), findsNothing);
    expect(find.text("Customers can't see your store yet"), findsNothing);
    expect(find.text('Logo'), findsNothing);

    await tester.tap(find.text('Message us on WhatsApp'));
    await tester.pumpAndSettle();
    expect(
      links.opened.single.queryParameters['text'],
      'Hello, my store is off for customers. Could you tell me why? '
      'Store a · Hay Al Andalus',
    );
  });

  testWidgets('staff see the store is off, without the chat', (tester) async {
    await open(
      tester,
      member: store('a', isOwner: false),
      details: storeDetails(isActive: false, wasLive: true),
    );

    expect(find.text('Your store is off for customers'), findsOneWidget);
    expect(find.text('Message us on WhatsApp'), findsNothing);
  });

  testWidgets('staff see a ready store waits, without the chat', (
    tester,
  ) async {
    await open(
      tester,
      member: store('a', isOwner: false),
      details: storeDetails(isActive: false),
    );

    expect(find.text('Your store is ready'), findsOneWidget);
    expect(find.text('Message us on WhatsApp'), findsNothing);
  });

  testWidgets('pulling down shows the store once our team turned it on', (
    tester,
  ) async {
    await open(tester, details: storeDetails(isActive: false));
    expect(find.text('Your store is ready'), findsOneWidget);

    storeRepository.getResult = Ok(storeDetails());
    // Far enough down the test's tall page to reload it.
    await tester.fling(find.text('Today'), const Offset(0, 800), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Your store is ready'), findsNothing);
  });
}
