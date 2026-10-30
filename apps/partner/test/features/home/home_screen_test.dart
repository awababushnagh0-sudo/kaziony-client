import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/providers/clock.dart';
import 'package:partner/core/routes/routes.dart';
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
    expect(find.text('3 of 10 left'), findsOneWidget);
    expect(find.text('268 pickups · 90% picked up'), findsOneWidget);
  });

  testWidgets('shows staff only their counter numbers', (tester) async {
    await open(tester, member: store('a', isOwner: false, branchId: 'b1'));

    expect(find.text('Today at your branch'), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
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

  testWidgets('says when no one is coming and nothing is live', (tester) async {
    await open(tester, claims: [], offers: []);

    expect(find.text('No one is on their way right now.'), findsOneWidget);
    expect(find.text('No live offers right now.'), findsOneWidget);
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
