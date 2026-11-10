import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/core/widgets/offer_card.dart';
import 'package:partner/features/offers/domain/offer.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  Future<void> open(WidgetTester tester, Offer offer) => pumpPartnerPages(
    tester,
    initial: Routes.offers,
    routes: [
      GoRoute(
        path: Routes.offers,
        builder: (_, _) => OfferCard(offer: offer),
      ),
    ],
  );

  testWidgets('a limited offer shows what is left beside where the rest are', (
    tester,
  ) async {
    await open(tester, offer('o1'));

    expect(find.text('3'), findsOneWidget);
    expect(find.text('left of 10'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget);
    // Said once, big at the end.
    expect(find.text('Left'), findsNothing);
    expect(find.text('No limit'), findsNothing);
  });

  testWidgets('a sold out offer says so over its whole count', (tester) async {
    await open(tester, offer('o1', left: 0));

    expect(find.text('Sold out'), findsOneWidget);
    expect(find.text('all 10'), findsOneWidget);
  });

  testWidgets('an unlimited offer counts its pickups instead', (tester) async {
    await open(tester, offer('o1', type: OfferType.unlimited));

    expect(find.text('5'), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget);
    expect(find.textContaining('left of'), findsNothing);
    expect(find.text('No limit'), findsOneWidget);
  });

  testWidgets('a scheduled offer only says what is ready and when it starts', (
    tester,
  ) async {
    await open(tester, offer('o1', state: OfferState.scheduled));

    expect(find.textContaining('Starts '), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);
    expect(find.text('Picked up'), findsNothing);
  });

  testWidgets('an ended offer says when it ended and what was picked up', (
    tester,
  ) async {
    await open(
      tester,
      offer('o1', status: OfferStatus.ended, state: OfferState.ended),
    );

    expect(find.textContaining('Ended '), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
    // The pieces nobody took.
    expect(find.text('Left'), findsOneWidget);
  });

  testWidgets('a removed offer says who removed it', (tester) async {
    await open(
      tester,
      offer('o1', status: OfferStatus.removed, state: OfferState.removed),
    );

    expect(find.text('Removed by our team'), findsOneWidget);
  });
}
