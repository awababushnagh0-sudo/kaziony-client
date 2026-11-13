import 'package:customer/features/offers/presentation/widgets/offer_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  Future<void> show(WidgetTester tester, List<OfferCard> cards) =>
      pumpCustomerPages(
        tester,
        initial: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => ListView(children: cards),
          ),
        ],
        overrides: [
          minuteClockProvider.overrideWith((ref) => Stream.value(now)),
        ],
      );

  /// The store closes 40 minutes from [now].
  final closingSoon = placeOpenUntil(const Duration(hours: 12, minutes: 40));

  /// The store opens at 2 PM.
  final closed = placeOpenUntil(
    const Duration(hours: 23),
    opens: const Duration(hours: 14),
  );

  testWidgets('says on the card when the store closes within the hour', (
    tester,
  ) async {
    await show(tester, [OfferCard(offer(location: closingSoon))]);

    expect(find.text('Closes in 40 min'), findsOneWidget);
  });

  testWidgets('says on the card while the store is closed', (tester) async {
    await show(tester, [
      OfferCard(offer(location: closed)),
      OfferCard(offer(location: closed), shape: OfferCardShape.tile),
    ]);

    expect(find.text('Closed now'), findsNWidgets(2));
  });

  testWidgets('says nothing while the store is open for a while yet', (
    tester,
  ) async {
    await show(tester, [
      OfferCard(offer(location: placeOpenUntil(const Duration(hours: 22)))),
      OfferCard(offer()),
    ]);

    expect(find.textContaining('Closes in'), findsNothing);
    expect(find.text('Closed now'), findsNothing);
  });

  testWidgets("leaves it to the store's own page", (tester) async {
    await show(tester, [OfferCard(offer(location: closed), inStore: true)]);

    expect(find.text('Closed now'), findsNothing);
  });
}
