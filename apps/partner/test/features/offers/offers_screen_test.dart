import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/offers/presentation/offers_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOfferRepository offers;

  Future<void> open(
    WidgetTester tester, {
    List<Offer>? items,
    bool isOwner = true,
  }) async {
    offers = FakeOfferRepository(items);
    await pumpPartnerPages(
      tester,
      initial: Routes.offers,
      overrides: [
        offerRepositoryProvider.overrideWithValue(offers),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
      ],
      routes: [
        GoRoute(path: Routes.offers, builder: (_, _) => const OffersScreen()),
        stubPage(Routes.quickOffer, 'quick offer page'),
        stubPage(Routes.chooseOfferProduct, 'choose product page'),
        stubPage(Routes.offer(':id'), 'offer page'),
      ],
    );
  }

  testWidgets('lists offers with state, price, time and where the pieces are', (
    tester,
  ) async {
    await open(
      tester,
      items: [
        offer('o1'),
        offer('o2', type: OfferType.unlimited),
      ],
    );

    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.text('Live'), findsNWidgets(2));
    expect(find.textContaining('4 LD, Until '), findsNWidgets(2));
    expect(find.text('Picked up'), findsNWidgets(2));
    expect(find.text('On the way'), findsNWidgets(2));
    // Only the limited one has pieces to count.
    expect(find.text('Left'), findsOneWidget);
    expect(find.text('No limit'), findsOneWidget);
  });

  testWidgets('filters by status', (tester) async {
    await open(
      tester,
      items: [
        offer('o1'),
        offer('o2', status: OfferStatus.paused, state: OfferState.paused),
      ],
    );

    await tester.tap(find.text('Paused').first);
    await tester.pumpAndSettle();

    expect(offers.statuses.last, OfferStatus.paused);
    expect(find.text('Offer o1'), findsNothing);
    expect(find.text('Offer o2'), findsOneWidget);
  });

  testWidgets('opens an offer', (tester) async {
    await open(tester);

    await tester.tap(find.text('Offer o1'));
    await tester.pumpAndSettle();
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets('owners post from one of their products', (tester) async {
    await open(tester);

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(find.text("What's the offer on?"), findsOneWidget);
    await tester.tap(find.text('From my products'));
    await tester.pumpAndSettle();
    expect(find.text('choose product page'), findsOneWidget);
  });

  testWidgets('owners post something new', (tester) async {
    await open(tester);

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Something new'));
    await tester.pumpAndSettle();
    expect(find.text('quick offer page'), findsOneWidget);
  });

  testWidgets('owners start posting from the first empty list', (tester) async {
    await open(tester, items: []);

    expect(find.text('No offers yet'), findsOneWidget);
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('From my products'));
    await tester.pumpAndSettle();
    expect(find.text('choose product page'), findsOneWidget);
  });

  testWidgets("staff see the offers but can't post", (tester) async {
    await open(tester, items: [], isOwner: false);

    expect(find.text('No offers yet'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);

    await open(tester, isOwner: false);
    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);
  });
}
