import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/offers/presentation/edit_offer_screen.dart';
import 'package:partner/features/offers/presentation/offer_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOfferRepository offers;

  Future<void> open(
    WidgetTester tester, {
    Offer? shown,
    bool isOwner = true,
  }) async {
    offers = FakeOfferRepository([shown ?? offer('o1')]);
    tester.view
      ..physicalSize = const Size(1200, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpPartnerPages(
      tester,
      initial: Routes.offer('o1'),
      overrides: [
        offerRepositoryProvider.overrideWithValue(offers),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
      ],
      routes: [
        GoRoute(
          path: Routes.offer(':id'),
          builder: (_, state) =>
              OfferScreen(offerId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: Routes.editOffer(':id'),
          builder: (_, state) =>
              EditOfferScreen(offerId: state.pathParameters['id']!),
        ),
        stubPage(Routes.newOffer(':productId'), 'new offer page'),
      ],
    );
  }

  testWidgets('shows the claims and the details', (tester) async {
    await open(tester);

    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('60 min'), findsOneWidget);
    expect(find.text('1 branch'), findsOneWidget);
  });

  testWidgets('pauses and resumes', (tester) async {
    await open(tester);

    await tester.tap(find.text('Pause'));
    await tester.pumpAndSettle();
    expect(offers.actions.last, ('o1', 'pause'));
    expect(find.text('Paused: customers don\'t see it now.'), findsOneWidget);

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();
    expect(offers.actions.last, ('o1', 'resume'));
  });

  testWidgets('ends only once confirmed, then offers to post again', (
    tester,
  ) async {
    await open(tester);

    await tester.tap(find.text('End the offer'));
    await tester.pumpAndSettle();
    expect(find.text('End this offer?'), findsOneWidget);
    await tester.tap(find.text('End the offer').last);
    await tester.pumpAndSettle();

    expect(offers.actions.single, ('o1', 'end'));
    await tester.tap(find.text('Post it again'));
    await tester.pumpAndSettle();
    expect(find.text('new offer page'), findsOneWidget);
  });

  testWidgets('staff see it without the actions', (tester) async {
    await open(tester, isOwner: false);

    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);
    expect(find.text('End the offer'), findsNothing);
    expect(find.byTooltip('Edit the offer'), findsNothing);
  });

  testWidgets('the owner edits the title', (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('Edit the offer'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(STextInput, 'Title'),
      'Two for one',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final (id, changes) = offers.updated.single;
    expect(id, 'o1');
    expect(changes.title, 'Two for one');
    expect(changes.endsAt.isAfter(DateTime.now()), isTrue);
  });
}
