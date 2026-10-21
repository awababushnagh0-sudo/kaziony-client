import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:admin/features/stores/presentation/store_details_screen.dart';
import 'package:admin/features/stores/presentation/stores_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

/// The stores list with a store's page on top of it, as in the app.
Widget harness(FakeStoreRepository stores, {String at = '/stores/store-1'}) =>
    AppScope(
      overrides: [
        ...testOverrides(kind: AppKind.admin),
        storeRepositoryProvider.overrideWithValue(stores),
        localeProvider.overrideWith(EnglishLocale.new),
      ],
      child: SApp(
        routerConfig: GoRouter(
          initialLocation: at,
          routes: [
            GoRoute(
              path: '/stores',
              builder: (_, _) => const StoresScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, state) =>
                      StoreDetailsScreen(storeId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        locale: const Locale('en'),
        density: StellarDensity.compact,
        onGenerateTitle: (_) => 'test',
        localizationsDelegates: const [AdminLocalizations.delegate],
      ),
    );

void setWindow(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1400, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('opens a store from the list', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores, at: '/stores'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Store 1'));
    await tester.pumpAndSettle();

    expect(stores.opened, ['store-1']);
    expect(find.byType(StoreDetailsScreen), findsOneWidget);
  });

  testWidgets('shows the store under "Stores", with its status and facts', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Stores'), findsOneWidget);
    expect(find.text('Sweet Coast'), findsWidgets);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Fresh sweets every morning.'), findsOneWidget);
    expect(find.text('Sweets'), findsWidgets);
    expect(find.text('Oct 15, 2026'), findsOneWidget);
  });

  testWidgets('switches to the contact tab', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()));
    await tester.pumpAndSettle();
    expect(find.text('https://instagram.com/sweetcoast'), findsNothing);

    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();

    expect(find.text('https://instagram.com/sweetcoast'), findsOneWidget);
    expect(find.text('Fresh sweets every morning.'), findsNothing);
  });

  testWidgets('goes back to the list from the breadcrumb', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stores'));
    await tester.pumpAndSettle();

    expect(find.byType(StoreDetailsScreen), findsNothing);
    expect(find.text('Store 1'), findsOneWidget);
  });

  testWidgets('shows a failure with a retry', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..detailsResult = const Err(NoConnectionFailure());
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    stores.detailsResult = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(stores.opened, ['store-1', 'store-1']);
    expect(find.text('Fresh sweets every morning.'), findsOneWidget);
  });
}
