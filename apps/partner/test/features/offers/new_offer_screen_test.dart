import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/offers/presentation/new_offer_screen.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

/// A store with two branches, to choose from.
class _TwoBranches extends FakeStoreRepository {
  @override
  Future<Result<Store>> getStore(String storeId) async {
    final base = storeDetails();
    return Ok(
      Store(
        id: base.id,
        name: base.name,
        category: base.category,
        profile: base.profile,
        isActive: true,
        branches: [
          ...base.branches,
          const Branch(
            id: 'b2',
            name: 'Gargaresh',
            city: City.tripoli,
            area: null,
            address: null,
            phone: null,
            isActive: true,
          ),
        ],
        members: base.members,
      ),
    );
  }
}

void main() {
  late FakeOfferRepository offers;

  Future<void> open(WidgetTester tester, String location) async {
    offers = FakeOfferRepository([
      offer('old', status: OfferStatus.ended, state: OfferState.ended),
    ]);
    // A tall phone, so the whole form is on screen.
    tester.view
      ..physicalSize = const Size(1200, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpPartnerPages(
      tester,
      initial: location,
      overrides: [
        offerRepositoryProvider.overrideWithValue(offers),
        productRepositoryProvider.overrideWithValue(
          FakeProductRepository([product('1')]),
        ),
        storeRepositoryProvider.overrideWithValue(_TwoBranches()),
        currentStoreProvider.overrideWithValue(store('a')),
      ],
      routes: [
        GoRoute(
          path: Routes.newOffer(':productId'),
          builder: (_, state) => NewOfferScreen(
            productId: state.pathParameters['productId']!,
            fromOfferId: state.uri.queryParameters['from'],
          ),
        ),
        stubPage(Routes.offer(':id'), 'offer page'),
      ],
    );
  }

  Finder field(String label) => find.widgetWithText(STextInput, label);

  testWidgets('posts a limited offer, ending tonight or tomorrow', (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));

    expect(find.text('Regular price 8 LD'), findsOneWidget);
    await tester.enterText(field('Offer price'), '5');
    await tester.pump();
    expect(find.text('38% off the regular price'), findsOneWidget);
    await tester.enterText(field('How many pieces'), '12');
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    final posted = offers.created.single;
    expect(posted.productId, '1');
    expect(posted.offerPrice, '5.000');
    expect(posted.type, OfferType.limited);
    expect(posted.totalQuantity, 12);
    expect(posted.claimWindowMinutes, 60);
    expect(posted.maxPerUser, 1);
    expect(posted.endsAt.hour, 23);
    expect(posted.endsAt.isAfter(DateTime.now()), isTrue);
    // All branches.
    expect(posted.branchIds, isNull);
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets('refuses a price that is not below the regular one', (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));

    await tester.enterText(field('Offer price'), '8');
    await tester.enterText(field('How many pieces'), '5');
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    expect(offers.created, isEmpty);
    expect(
      find.text('Must be lower than the regular price (8 LD)'),
      findsOneWidget,
    );
  });

  testWidgets('unlimited offers need no pieces', (tester) async {
    await open(tester, Routes.newOffer('1'));

    await tester.enterText(field('Offer price'), '6.5');
    await tester.tap(find.text('No limit'));
    await tester.pumpAndSettle();
    expect(field('How many pieces'), findsNothing);
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    final posted = offers.created.single;
    expect(posted.type, OfferType.unlimited);
    expect(posted.totalQuantity, isNull);
    expect(posted.claimWindowMinutes, isNull);
  });

  testWidgets('posts in the branches left ticked, and needs one', (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));
    await tester.enterText(field('Offer price'), '5');
    await tester.enterText(field('How many pieces'), '3');

    await tester.tap(find.text('Andalus'));
    await tester.tap(find.text('Gargaresh'));
    await tester.pump();
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(offers.created, isEmpty);
    expect(find.text('Choose at least one branch.'), findsOneWidget);

    await tester.tap(find.text('Gargaresh'));
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(offers.created.single.branchIds, ['b2']);
  });

  testWidgets('posts an ended offer again with its price', (tester) async {
    await open(tester, Routes.newOffer('1', from: 'old'));

    expect(find.text('4.000'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    final posted = offers.created.single;
    expect(posted.offerPrice, '4.000');
    expect(posted.totalQuantity, 10);
  });
}
