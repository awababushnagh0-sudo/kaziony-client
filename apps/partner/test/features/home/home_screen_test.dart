import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/core/widgets/offer_card.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/home/domain/store_stats.dart';
import 'package:partner/features/home/presentation/home_screen.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  Future<void> open(
    WidgetTester tester, {
    StoreMembership? member,
    List<Claim>? claims,
    List<Offer>? offers,
    FakeStatsRepository? stats,
  }) {
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
        statsRepositoryProvider.overrideWithValue(
          stats ?? FakeStatsRepository(),
        ),
        claimRepositoryProvider.overrideWithValue(
          FakeClaimRepository(claims ?? [claim('ABCD2345')]),
        ),
        offerRepositoryProvider.overrideWithValue(
          FakeOfferRepository(offers ?? [offer('o1')]),
        ),
        // No ticking clock in tests: the page reads the time when it builds.
        minuteClockProvider.overrideWith((ref) => const Stream.empty()),
      ],
      routes: [
        GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
        stubPage(Routes.pickups, 'pickups page'),
        stubPage(Routes.offers, 'offers page'),
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
    expect(find.text('Left'), findsOneWidget);
  });

  testWidgets('shows staff only their counter numbers', (tester) async {
    await open(tester, member: store('a', isOwner: false, branchId: 'b1'));

    expect(find.text('Today at your branch'), findsOneWidget);
    // On the band, and on the offer's card.
    expect(find.text('Picked up'), findsWidgets);
    expect(find.text('Not picked up'), findsNothing);
    expect(find.text('Last 30 days'), findsNothing);
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

  testWidgets("staff aren't offered to post", (tester) async {
    await open(
      tester,
      member: store('a', isOwner: false, branchId: 'b1'),
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
    expect(find.text('Left'), findsNothing);
    expect(find.text('No limit'), findsOneWidget);
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
}
