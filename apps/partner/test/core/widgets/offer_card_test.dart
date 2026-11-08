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

  testWidgets('a limited offer counts where all its pieces are', (
    tester,
  ) async {
    await open(tester, offer('o1'));

    expect(find.text('5'), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Left'), findsOneWidget);
    expect(find.text('No limit'), findsNothing);
  });

  testWidgets('an unlimited offer has nothing left to count', (tester) async {
    await open(tester, offer('o1', type: OfferType.unlimited));

    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('Left'), findsNothing);
    expect(find.text('No limit'), findsOneWidget);
  });

  testWidgets('a scheduled offer only says what is ready and when it starts', (
    tester,
  ) async {
    await open(tester, offer('o1', state: OfferState.scheduled));

    expect(find.text('Scheduled'), findsOneWidget);
    expect(find.textContaining('Starts '), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);
    expect(find.text('Picked up'), findsNothing);
  });

  testWidgets('an ended offer says when it ended', (tester) async {
    await open(
      tester,
      offer('o1', status: OfferStatus.ended, state: OfferState.ended),
    );

    expect(find.text('Ended'), findsOneWidget);
    expect(find.textContaining('Ended '), findsOneWidget);
  });
}
