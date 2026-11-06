import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/offers_view_model.dart';
import 'package:customer/features/offers/presentation/search_screen.dart';
import 'package:customer/features/offers/presentation/widgets/offer_card.dart';
import 'package:customer/features/offers/presentation/widgets/offers_layout_switch.dart';
import 'package:customer/features/stores/domain/store.dart';
import 'package:customer/features/stores/presentation/widgets/store_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOffersRepository offers;
  late FakeStoresRepository stores;

  setUp(() {
    offers = FakeOffersRepository();
    stores = FakeStoresRepository();
  });

  Future<void> open(WidgetTester tester) => pumpCustomerPages(
    tester,
    initial: Routes.search,
    routes: [
      GoRoute(path: Routes.search, builder: (_, _) => const SearchScreen()),
      stubPage(Routes.offerPattern, 'offer page'),
      stubPage(Routes.storePattern, 'store page'),
    ],
    overrides: [
      offersRepositoryProvider.overrideWithValue(offers),
      storesRepositoryProvider.overrideWithValue(stores),
      browseLocationProvider.overrideWith(
        () => BrowseLocationController(
          const BrowseLocation(souqAlJuma, pinned: false),
        ),
      ),
      minuteClockProvider.overrideWith((ref) => Stream.value(now)),
    ],
  );

  final field = find.byWidgetPredicate((w) => w is SSearchField);

  /// The recent search [label], as a chip.
  Finder chip(String label) => find.ancestor(
    of: find.text(label),
    matching: find.byWidgetPredicate((w) => w is SChip),
  );

  Future<void> submit(WidgetTester tester, String words) async {
    await tester.enterText(field, words);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
  }

  Future<void> clearField(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Clear the search'));
    await tester.pumpAndSettle();
  }

  testWidgets('before searching: kinds of store and stores near, no offers', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('What are you craving?'), findsOneWidget);
    expect(find.text('Bakeries'), findsOneWidget);
    expect(find.text('Stores near you'), findsOneWidget);
    expect(find.byType(StoreTile), findsOneWidget);
    expect(find.byType(OfferCard), findsNothing);
    expect(find.byType(OffersLayoutSwitch), findsNothing);
    // Nothing searched yet.
    expect(find.text('Recent searches'), findsNothing);
  });

  testWidgets('submitting shows the stores and offers found, with filters', (
    tester,
  ) async {
    await open(tester);

    await submit(tester, ' kunafa ');

    expect(offers.queries.last.search, 'kunafa');
    expect(find.text('Stores'), findsOneWidget);
    expect(find.byType(StoreTile), findsOneWidget);
    expect(find.byType(OfferCard), findsOneWidget);
    expect(find.text('Nearest'), findsOneWidget);
    expect(find.byType(OffersLayoutSwitch), findsOneWidget);
    expect(find.text('What are you craving?'), findsNothing);
  });

  testWidgets('says when nothing matches, without filters', (tester) async {
    offers.offers = [];
    stores.stores = [];
    await open(tester);

    await submit(tester, 'pizza');

    expect(find.text('Nothing found'), findsOneWidget);
    expect(find.byType(OffersLayoutSwitch), findsNothing);
  });

  testWidgets('a submitted search comes back as a recent one, and goes', (
    tester,
  ) async {
    await open(tester);
    await submit(tester, 'kunafa');
    await submit(tester, 'cake');

    await clearField(tester);
    expect(find.text('Recent searches'), findsOneWidget);
    expect(chip('cake'), findsOneWidget);
    expect(chip('kunafa'), findsOneWidget);

    await tester.tap(
      find.descendant(of: chip('cake'), matching: find.byTooltip('Remove')),
    );
    await tester.pumpAndSettle();
    expect(chip('cake'), findsNothing);
    expect(chip('kunafa'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Recent searches'), findsNothing);
  });

  testWidgets('tapping a recent search searches it again', (tester) async {
    await open(tester);
    await submit(tester, 'kunafa');
    await clearField(tester);

    await tester.tap(find.text('kunafa'));
    await tester.pumpAndSettle();

    expect(offers.queries.last.search, 'kunafa');
    expect(find.byType(OfferCard), findsOneWidget);
  });

  testWidgets('a kind of store shows its offers, until it is taken off', (
    tester,
  ) async {
    await open(tester);

    await tester.tap(find.text('Bakeries'));
    await tester.pumpAndSettle();
    expect(offers.queries.last.categoryId, bakery.id);
    expect(find.byType(OfferCard), findsOneWidget);

    await tester.tap(
      find.ancestor(
        of: find.text('Bakeries'),
        matching: find.byWidgetPredicate((w) => w is SPill),
      ),
    );
    await tester.pumpAndSettle();
    expect(offers.queries.last.categoryId, isNull);
    expect(find.text('What are you craving?'), findsOneWidget);
  });

  testWidgets('opening a store found by typing remembers the search', (
    tester,
  ) async {
    await open(tester);
    await tester.enterText(field, 'sweet');
    await tester.pump(OffersFilterController.searchDelay);
    await tester.pumpAndSettle();
    expect(find.text('Stores'), findsOneWidget);

    await tester.tap(find.byType(StoreTile));
    await tester.pumpAndSettle();
    expect(find.text('store page'), findsOneWidget);

    GoRouter.of(tester.element(find.text('store page'))).pop();
    await tester.pumpAndSettle();
    await clearField(tester);
    expect(chip('sweet'), findsOneWidget);
  });

  testWidgets('opening a store before searching remembers nothing', (
    tester,
  ) async {
    stores.stores = const [
      StoreSummary(
        id: 's2',
        name: 'Corner cafe',
        category: bakery,
        liveOfferCount: 0,
      ),
    ];
    await open(tester);

    await tester.tap(find.byType(StoreTile));
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.text('store page'))).pop();
    await tester.pumpAndSettle();

    expect(find.text('Recent searches'), findsNothing);
    expect(find.text('Corner cafe'), findsOneWidget);
  });
}
