import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/stores/domain/store.dart';
import 'package:customer/features/stores/presentation/favorites_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeStoresRepository stores;

  setUp(() => stores = FakeStoresRepository());

  Future<void> open(WidgetTester tester, {bool signedIn = true}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.favorites,
        routes: [
          GoRoute(
            path: Routes.favorites,
            builder: (_, _) => const FavoritesScreen(),
          ),
          stubPage(Routes.signIn, 'sign-in page'),
          stubPage(Routes.storePattern, 'store page'),
          stubPage(Routes.home, 'home page'),
        ],
        overrides: [
          storesRepositoryProvider.overrideWithValue(stores),
          if (signedIn)
            sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );

  testWidgets('signed out, it opens the sign-in page', (tester) async {
    await open(tester, signedIn: false);

    expect(find.text('Sign in to save your favorite stores'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in page'), findsOneWidget);
  });

  testWidgets('lists the saved stores and opens one', (tester) async {
    stores.followedStores = const [storeSummary];
    await open(tester);

    expect(find.text('Sweet shop'), findsOneWidget);
    expect(find.text('2 offers now'), findsOneWidget);
    await tester.tap(find.text('Sweet shop'));
    await tester.pumpAndSettle();

    expect(find.text('store page'), findsOneWidget);
  });

  testWidgets('with nothing saved, it says how to save a store', (
    tester,
  ) async {
    stores.followedStores = const <StoreSummary>[];
    await open(tester);

    expect(find.text('No favorite stores yet'), findsOneWidget);
    await tester.tap(find.text('Browse offers'));
    await tester.pumpAndSettle();

    expect(find.text('home page'), findsOneWidget);
  });
}
