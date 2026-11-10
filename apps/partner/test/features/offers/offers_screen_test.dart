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

  testWidgets('shows each offer with its price, time, what is left and '
      'where the pieces are', (tester) async {
    await open(
      tester,
      items: [
        offer('o1'),
        offer('o2', type: OfferType.unlimited),
      ],
    );

    expect(offers.lists.single.ended, isFalse);
    expect(find.text('Offer o1'), findsOneWidget);
    // The group says they're live, so the cards don't.
    expect(find.text('Live now'), findsOneWidget);
    expect(find.text('Live'), findsNothing);
    expect(find.textContaining('4 LD, Until '), findsNWidgets(2));
    // The limited one's pieces left, big at its end and not in its key.
    expect(find.text('3'), findsOneWidget);
    expect(find.text('left of 10'), findsOneWidget);
    expect(find.text('Left'), findsNothing);
    // The unlimited one counts its pickups instead.
    expect(find.text('Picked up'), findsNWidgets(2));
    expect(find.text('On the way'), findsNWidgets(2));
    expect(find.text('No limit'), findsOneWidget);
  });

  testWidgets('groups the current offers: on now, coming up, then paused', (
    tester,
  ) async {
    // The whole list, so every group is on screen.
    tester.view
      ..physicalSize = const Size(800, 1600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await open(
      tester,
      items: [
        offer('o1'),
        offer('o2'),
        offer('o3', state: OfferState.scheduled),
        offer('o4', status: OfferStatus.paused, state: OfferState.paused),
      ],
    );

    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(find.text('Live now'), findsOneWidget);
    expect(top('Live now'), lessThan(top('Offer o1')));
    expect(top('Offer o2'), lessThan(top('Coming up')));
    expect(top('Coming up'), lessThan(top('Offer o3')));
    expect(top('Offer o3'), lessThan(top('Paused')));
    expect(top('Paused'), lessThan(top('Offer o4')));
    // Before it starts, only what's ready.
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('shows the ended ones apart, a removed one saying so', (
    tester,
  ) async {
    await open(
      tester,
      items: [
        offer('o1'),
        offer('o2', status: OfferStatus.ended, state: OfferState.ended),
        offer('o3', status: OfferStatus.removed, state: OfferState.removed),
      ],
    );

    await tester.tap(find.text('Ended'));
    await tester.pumpAndSettle();

    expect(offers.lists.last.ended, isTrue);
    expect(find.text('Offer o1'), findsNothing);
    expect(find.text('Offer o2'), findsOneWidget);
    expect(find.text('Removed by our team'), findsOneWidget);
    expect(find.text('Live now'), findsNothing);
    // What was picked up, now that it's over.
    expect(find.text('Picked up'), findsNWidgets(2));
  });

  testWidgets('owners resume a paused offer from its card', (tester) async {
    await open(
      tester,
      items: [
        offer('o1'),
        offer('o2', status: OfferStatus.paused, state: OfferState.paused),
      ],
    );

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    expect(offers.actions, [('o2', 'resume')]);
    expect(find.text('Customers see it again.'), findsOneWidget);
    expect(find.text('Paused'), findsNothing);
    expect(find.text('Resume'), findsNothing);
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

  testWidgets("staff see the offers but can't post or resume", (tester) async {
    await open(tester, items: [], isOwner: false);

    expect(find.text('No offers yet'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);

    await open(
      tester,
      items: [
        offer('o1', status: OfferStatus.paused, state: OfferState.paused),
      ],
      isOwner: false,
    );
    expect(find.text('Offer o1'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);
    expect(find.text('Resume'), findsNothing);
  });
}
