import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOffersRepository offers;

  setUp(() => offers = FakeOffersRepository());

  Future<void> open(WidgetTester tester) => pumpCustomerPages(
    tester,
    initial: Routes.home,
    routes: [
      GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: Routes.offers,
        builder: (_, state) => SText('offers ${state.uri.query}'),
      ),
      stubPage(Routes.offerPattern, 'offer page'),
    ],
    overrides: [
      offersRepositoryProvider.overrideWithValue(offers),
      browseLocationProvider.overrideWith(
        () => BrowseLocationController(
          const BrowseLocation(souqAlJuma, pinned: false),
        ),
      ),
      minuteClockProvider.overrideWith((ref) => Stream.value(now)),
    ],
  );

  /// The page, which scrolls down (the rows scroll sideways).
  final page = find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down,
  );

  testWidgets('shows the rows of offers and opens one', (tester) async {
    await open(tester);

    expect(find.text('Near you'), findsOneWidget);
    expect(find.text('Bakeries'), findsOneWidget);
    expect(find.text('Kunafa box'), findsWidgets);

    final card = find
        .ancestor(
          of: find.text('Kunafa box'),
          matching: find.bySubtype<SDealPoster>(),
        )
        .first;
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets('"See all" lists the row\'s offers', (tester) async {
    await open(tester);

    await tester.ensureVisible(find.text('See all').first);
    await tester.tap(find.text('See all').first);
    await tester.pumpAndSettle();

    expect(find.text('offers sort=endingSoon'), findsOneWidget);
  });

  testWidgets('ends with the newest offers, and "See all" of them', (
    tester,
  ) async {
    await open(tester);

    await tester.scrollUntilVisible(
      find.text('All offers').hitTestable(),
      200,
      scrollable: page,
    );
    await tester.tap(find.text('See all').hitTestable().last);
    await tester.pumpAndSettle();

    expect(find.text('offers sort=newest'), findsOneWidget);
  });

  testWidgets('says when there are no offers around', (tester) async {
    offers.offers = [];
    await open(tester);

    expect(find.text('No offers near you right now'), findsOneWidget);
    expect(find.text('Near you'), findsNothing);
    expect(find.text('All offers'), findsNothing);
  });
}
