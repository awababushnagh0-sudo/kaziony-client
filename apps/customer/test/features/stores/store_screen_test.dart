import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/stores/domain/store.dart';
import 'package:customer/features/stores/presentation/store_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

/// Refuses to follow, to see the page put it back.
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

  testWidgets('shows the store, its offers and its branches', (tester) async {
    await open(tester);

    expect(find.text('Sweet shop'), findsOneWidget);
    expect(find.text('Bakeries · 3 followers'), findsOneWidget);
    expect(find.text('Kunafa box'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.text('Hay Al Andalus'), findsOneWidget);
    expect(find.text('Get directions'), findsOneWidget);
  });

  testWidgets('follows the store, then stops', (tester) async {
    await open(tester);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();
    expect(stores.follows, ['s1']);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Bakeries · 4 followers'), findsOneWidget);

    await tester.tap(find.text('Following'));
    await tester.pumpAndSettle();
    expect(stores.unfollows, ['s1']);
    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('Bakeries · 3 followers'), findsOneWidget);
  });

  testWidgets('puts it back when following was refused', (tester) async {
    stores = _RefusingStores();
    await open(tester);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();

    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('Bakeries · 3 followers'), findsOneWidget);
  });

  testWidgets('a guest is asked to sign in before following', (tester) async {
    await open(tester, signedIn: false);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to follow stores'), findsOneWidget);
    expect(stores.follows, isEmpty);
  });
}
