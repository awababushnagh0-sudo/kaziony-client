import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/offers/presentation/edit_offer_screen.dart';
import 'package:partner/features/offers/presentation/offer_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/presentation/store_view_model.dart';

import '../../fakes.dart';
import '../../support/finders.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOfferRepository offers;

  Future<void> open(
    WidgetTester tester, {
    Offer? shown,
    bool isOwner = true,
    bool live = true,
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
        storeIsLiveProvider.overrideWithValue(live),
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

  testWidgets('says each number once: where the pieces are, then details', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('3 of 10'), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.textContaining('not picked up'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    // Our team's hold time, as the offer came with it.
    expect(find.text('Held for'), findsOneWidget);
    expect(find.text('2 hours'), findsOneWidget);
  });

  testWidgets('an offer without a limit shows who saw it instead', (
    tester,
  ) async {
    await open(tester, shown: offer('o1', type: OfferType.unlimited));

    expect(find.text('Seen'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('No limit'), findsWidgets);
    expect(find.text('Held for'), findsNothing);
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

  testWidgets('ends from the menu, only once confirmed, then offers to post '
      'again', (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End the offer'));
    await tester.pumpAndSettle();
    expect(find.text('End this offer?'), findsOneWidget);
    await tester.tap(find.text('End the offer').last);
    await tester.pumpAndSettle();

    expect(offers.actions.single, ('o1', 'end'));
    // Over: no menu, and posting it again is the main button.
    expect(find.byTooltip('More'), findsNothing);
    await tester.tap(find.text('Post it again'));
    await tester.pumpAndSettle();
    expect(find.text('new offer page'), findsOneWidget);
  });

  testWidgets("a store that isn't live can't resume or post again yet", (
    tester,
  ) async {
    await open(
      tester,
      shown: offer('o1', status: OfferStatus.paused, state: OfferState.paused),
      live: false,
    );

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();
    expect(offers.actions, isEmpty);
    expect(
      find.text(
        "Customers can't see your store yet, so it can't post offers. Home shows what's left.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('a live offer is not posted again until it is over', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Post it again'), findsNothing);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    expect(find.text('End the offer'), findsOneWidget);
    expect(find.text('Post it again'), findsNothing);
  });

  testWidgets('staff see it without the actions', (tester) async {
    await open(tester, isOwner: false);

    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.byTooltip('More'), findsNothing);
  });

  testWidgets('the owner edits the title', (tester) async {
    await open(tester);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(textField('Title'), 'Two for one');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final (id, changes) = offers.updated.single;
    expect(id, 'o1');
    expect(changes.title, 'Two for one');
    expect(changes.endsAt.isAfter(DateTime.now()), isTrue);
  });
}
