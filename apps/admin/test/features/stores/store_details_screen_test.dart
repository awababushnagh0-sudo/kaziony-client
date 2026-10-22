import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/providers/access.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:admin/features/stores/presentation/store_details_screen.dart';
import 'package:admin/features/stores/presentation/stores_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

/// The stores list with a store's page on top of it, as in the app.
Widget harness(
  FakeStoreRepository stores, {
  String at = '/stores/store-1',
  bool admin = true,
}) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    isAdminProvider.overrideWithValue(admin),
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
              onExit: LeaveGuard.onExit,
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
    expect(find.text('hello@sweetcoast.ly'), findsOneWidget);
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

  Future<void> chooseAction(WidgetTester tester, String action) async {
    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(action));
    await tester.pumpAndSettle();
  }

  testWidgets('disables a store after confirming', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable store');
    expect(find.text('Disable Sweet Coast?'), findsOneWidget);
    await tester.tap(find.text('Disable store').last);
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', false)]);
    expect(find.text('Store disabled'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);

    await chooseAction(tester, 'Enable store');
    expect(stores.activeChanges.last, ('store-1', true));
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('keeps the store when the confirmation is cancelled', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Delete store');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(stores.deleted, isEmpty);
    expect(find.byType(StoreDetailsScreen), findsOneWidget);
  });

  testWidgets('deletes a store and goes back to the list', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Delete store');
    expect(find.text('Delete Sweet Coast?'), findsOneWidget);
    await tester.tap(find.text('Delete store').last);
    await tester.pumpAndSettle();

    expect(stores.deleted, ['store-1']);
    expect(find.byType(StoreDetailsScreen), findsNothing);
    expect(find.text('Store deleted'), findsOneWidget);
  });

  testWidgets('explains that a store with offers can only be disabled', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..deleteResult = const Err(ConflictFailure('has offers'));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Delete store');
    await tester.tap(find.text('Delete store').last);
    await tester.pumpAndSettle();

    expect(
      find.text(
        "This store has offers, so it can't be deleted. Disable it instead.",
      ),
      findsOneWidget,
    );
    expect(find.byType(StoreDetailsScreen), findsOneWidget);
  });

  Finder field(String label) => find.descendant(
    of: find.byWidgetPredicate(
      (widget) => widget is STextInput && widget.label == label,
    ),
    matching: find.byType(EditableText),
  );

  testWidgets('shows "Not saved" and Save once a field changes', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()));
    await tester.pumpAndSettle();
    expect(find.text('Actions'), findsOneWidget);

    await tester.enterText(field('Store name'), 'Sweet Coast 2');
    await tester.pumpAndSettle();
    expect(find.text('Not saved'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Actions'), findsNothing);

    // Typed back to what was saved: nothing to save.
    await tester.enterText(field('Store name'), ' Sweet Coast ');
    await tester.pumpAndSettle();
    expect(find.text('Not saved'), findsNothing);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Actions'), findsOneWidget);
  });

  testWidgets('saves the edited fields, clearing emptied ones', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.enterText(field('Description'), 'Open late.');
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Store phone'), '092 123 4567');
    await tester.enterText(field('Store email'), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final (id, edited) = stores.updates.single;
    expect(id, 'store-1');
    expect(edited.name, 'Sweet Coast');
    expect(edited.categoryId, 'cat-sweets');
    expect(edited.description, 'Open late.');
    expect(edited.phone, '+218921234567');
    expect(edited.email, isNull);
    expect(edited.instagramUrl, 'https://instagram.com/sweetcoast');
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Not saved'), findsNothing);
    expect(find.text('Actions'), findsOneWidget);
  });

  testWidgets("doesn't save invalid fields", (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.enterText(field('Store name'), '');
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Instagram'), 'instagram.com/sweetcoast');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates, isEmpty);
    expect(
      find.text('Enter a valid link starting with https://'),
      findsOneWidget,
    );
    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('keeps the changes when saving fails', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..updateResult = const Err(NoConnectionFailure());
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.enterText(field('Store name'), 'Sweet Coast 2');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates, hasLength(1));
    expect(find.text('Not saved'), findsOneWidget);
    expect(find.text('Sweet Coast 2'), findsOneWidget);
  });

  testWidgets('asks before leaving with unsaved changes', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()));
    await tester.pumpAndSettle();
    await tester.enterText(field('Store name'), 'Sweet Coast 2');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stores'));
    await tester.pumpAndSettle();
    expect(find.text('Discard your changes?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(StoreDetailsScreen), findsOneWidget);
    expect(find.text('Sweet Coast 2'), findsOneWidget);

    await tester.tap(find.text('Stores'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.byType(StoreDetailsScreen), findsNothing);
    expect(find.text('Store 1'), findsOneWidget);
  });

  testWidgets('editors can disable a store but not delete it', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository(), admin: false));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
    expect(find.text('Disable store'), findsOneWidget);
    expect(find.text('Delete store'), findsNothing);
  });
}
