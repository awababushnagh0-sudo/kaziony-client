import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/offers/presentation/new_offer_screen.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/finders.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOfferRepository offers;

  Future<void> open(WidgetTester tester, String location) async {
    offers = FakeOfferRepository([
      offer('old', status: OfferStatus.ended, state: OfferState.ended),
    ]);
    // A tall phone, so the whole form is on screen.
    tester.view
      ..physicalSize = const Size(1200, 6000)
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

  testWidgets('posts a limited offer, ending tonight or tomorrow', (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));

    expect(find.text('Regular price 8 LD'), findsOneWidget);
    await tester.enterText(amountField(), '5');
    await tester.pump();
    expect(find.text('-38%'), findsOneWidget);
    await tester.enterText(countField(), '12');
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    final posted = offers.created.single;
    expect(posted.productId, '1');
    expect(posted.offerPrice, '5.000');
    expect(posted.type, OfferType.limited);
    expect(posted.totalQuantity, 12);
    // No limit per customer unless one is set.
    expect(posted.maxPerUser, isNull);
    expect(posted.endsAt.hour, 23);
    expect(posted.endsAt.isAfter(DateTime.now()), isTrue);
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets("says when customers can't see the store yet, so it can't post", (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));
    offers.failNextCreate = const ForbiddenFailure(
      code: 'StoreDisabled',
      serverMessage: "Your store isn't live, so it can't post offers.",
    );

    await tester.enterText(amountField(), '5');
    await tester.enterText(countField(), '12');
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    expect(offers.created, isEmpty);
    expect(
      find.text(
        "Customers can't see your store yet, so it can't post offers. Home "
        "shows what's left.",
      ),
      findsOneWidget,
    );
    expect(find.text('offer page'), findsNothing);
  });

  testWidgets('a price at the regular one or over is not typed, and says '
      'why', (tester) async {
    await open(tester, Routes.newOffer('1'));
    const why = 'Must be lower than the regular price (8 LD)';

    await tester.enterText(amountField(), '7.5');
    await tester.enterText(amountField(), '8');
    await tester.pump();
    expect(find.text('7.5'), findsOneWidget);
    expect(find.text(why), findsOneWidget);

    await tester.enterText(amountField(), '7');
    await tester.pump();
    expect(find.text(why), findsNothing);
    expect(find.text('-13%'), findsOneWidget);
  });

  testWidgets('unlimited offers need no pieces', (tester) async {
    await open(tester, Routes.newOffer('1'));

    await tester.enterText(amountField(), '6.5');
    await tester.tap(find.text('No limit'));
    await tester.pumpAndSettle();
    expect(find.bySubtype<SCountInput>(), findsNothing);
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    final posted = offers.created.single;
    expect(posted.type, OfferType.unlimited);
    expect(posted.totalQuantity, isNull);
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

  testWidgets('a limit per customer, once unfolded; no hold time to pick', (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));
    await tester.enterText(amountField(), '5');
    expect(find.text('No limit per customer'), findsOneWidget);

    await tester.tap(find.text('Reservations'));
    await tester.pumpAndSettle();
    // How long reservations are held is our team's setting.
    expect(find.text('Held for'), findsNothing);
    expect(find.text('2 hours'), findsNothing);
    await tester.tap(find.text('At most'));
    await tester.pumpAndSettle();
    // Starts at 2, one more with the plus.
    await tester.tap(find.byTooltip('More').last);
    await tester.pump();
    expect(find.text('3 pieces per customer'), findsOneWidget);
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    expect(offers.created.single.maxPerUser, 3);
  });

  testWidgets('the price takes only an amount, Arabic digits too', (
    tester,
  ) async {
    await open(tester, Routes.newOffer('1'));

    await tester.enterText(amountField(), 'a٥,2509');
    await tester.pump();
    expect(find.text('5.250'), findsOneWidget);

    // Five pieces to start, one more with the plus.
    await tester.tap(find.byTooltip('More').first);
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(offers.created.single.offerPrice, '5.250');
    expect(offers.created.single.totalQuantity, 6);
  });
}
