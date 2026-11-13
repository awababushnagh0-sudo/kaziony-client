import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/stores/domain/store.dart';
import 'package:customer/features/stores/presentation/store_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

/// Refuses to save, to see the page put it back.
class _RefusingStores extends FakeStoresRepository {
  @override
  Future<Result<void>> follow(String storeId) async =>
      const Err(NoConnectionFailure());
}

void main() {
  late FakeStoresRepository stores;

  setUp(() => stores = FakeStoresRepository());

  Future<void> open(WidgetTester tester, {bool signedIn = true}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.store('s1'),
        routes: [
          GoRoute(
            path: Routes.storePattern,
            builder: (_, state) =>
                StoreScreen(storeId: state.pathParameters['storeId']!),
          ),
          stubPage(Routes.signIn, 'sign-in page'),
        ],
        overrides: [
          storesRepositoryProvider.overrideWithValue(stores),
          browseLocationProvider.overrideWith(
            () => BrowseLocationController(
              const BrowseLocation(souqAlJuma, pinned: false),
            ),
          ),
          minuteClockProvider.overrideWith((ref) => Stream.value(now)),
          if (signedIn)
            sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );

  testWidgets('shows the store, its offers and its place', (tester) async {
    await open(tester);

    expect(find.text('Sweet shop'), findsOneWidget);
    expect(find.text('Bakeries'), findsOneWidget);
    expect(find.text('Kunafa box'), findsOneWidget);
    // Where it is, with the way there, its hours today and its phone.
    expect(find.text('Andalus'), findsOneWidget);
    expect(find.text('Jaraba Street · 1.2 km'), findsOneWidget);
    expect(
      find.textContaining(RegExp('^Open today 8:00.AM – 11:00.PM\$')),
      findsOneWidget,
    );
    expect(find.text('0912345678'), findsOneWidget);
  });

  testWidgets('says when the store is closed today', (tester) async {
    stores.location = const StoreLocation(
      point: souqAlJuma,
      area: 'Andalus',
      hours: StoreSchedule(weekly: OpeningHours({Weekday.mon: []})),
    );
    await open(tester);

    expect(find.text('Closed today'), findsOneWidget);
  });

  testWidgets('saves the store to favorites, then takes it out', (
    tester,
  ) async {
    await open(tester);

    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();
    expect(stores.follows, ['s1']);
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    expect(stores.unfollows, ['s1']);
    expect(find.byTooltip('Add to favorites'), findsOneWidget);
  });

  testWidgets('puts it back when saving was refused', (tester) async {
    stores = _RefusingStores();
    await open(tester);

    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Add to favorites'), findsOneWidget);
  });

  testWidgets('a guest is asked to sign in before saving', (tester) async {
    await open(tester, signedIn: false);

    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to save your favorite stores'), findsOneWidget);
    expect(stores.follows, isEmpty);
  });
}
