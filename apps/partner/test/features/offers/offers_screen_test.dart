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
        stubPage(Routes.chooseOfferProduct, 'choose product page'),
        stubPage(Routes.offer(':id'), 'offer page'),
      ],
    );
  }

  testWidgets('lists offers with prices, state, time, stock and selling', (
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
    expect(find.text('4 LD'), findsNWidgets(2));
    expect(find.textContaining('50%'), findsNWidgets(2));
    expect(find.text('Live'), findsNWidgets(2));
    expect(find.text('8 LD'), findsNWidgets(2));
    expect(find.textContaining('Ends '), findsNWidgets(2));
    // Only the limited one has pieces to count.
    expect(find.text('3 of 10 left'), findsOneWidget);
    expect(find.text('Views'), findsNWidgets(2));
    expect(find.text('42'), findsNWidgets(2));
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

  testWidgets('owners post from the button over the list', (tester) async {
    await open(tester);

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(find.text('choose product page'), findsOneWidget);
  });

  testWidgets('owners start posting from the first empty list', (tester) async {
    await open(tester, items: []);

    expect(find.text('No offers yet'), findsOneWidget);
    await tester.tap(find.text('Post an offer'));
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
