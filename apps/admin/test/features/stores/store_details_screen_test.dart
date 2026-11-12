import 'dart:convert';

import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/providers/access.dart';
import 'package:admin/features/stores/domain/location.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:admin/features/stores/presentation/store_details_screen.dart';
import 'package:admin/features/stores/presentation/stores_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/finders.dart';

/// The stores list with a store's page on top of it, as in the app.
Widget harness(
  FakeStoreRepository stores, {
  String at = '/stores/store-1',
  bool admin = true,
  FakePhotoPicker? photos,
}) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    isAdminProvider.overrideWithValue(admin),
    storeRepositoryProvider.overrideWithValue(stores),
    photoPickerProvider.overrideWithValue(photos ?? FakePhotoPicker()),
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
    style: StellarStyle.dashboard,
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

    await tester.tap(find.text('Store 1 · Area 1'));
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
    // The page says which of the brand's places it is.
    expect(find.text('Sweet Coast · Hay Al Andalus'), findsOneWidget);
    expect(find.text('Sweet Coast'), findsWidgets);
    expect(find.text('★ 4.5 · 37 ratings'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Show your code at the cashier.'), findsOneWidget);
    expect(find.text('Sweets'), findsWidgets);
    expect(find.text('Oct 15, 2026'), findsOneWidget);
    // Live with all it needs: nothing to check.
    expect(find.text('Before customers see it'), findsNothing);
  });

  testWidgets('a store not ready says what it lacks, and why it stays off', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..detailsResult = Ok(
        sampleDetails(
          'store-1',
          active: false,
          missing: const [GoLiveItem.logo, GoLiveItem.openingHours],
        ),
      )
      ..setActiveResult = const Err(
        ConflictFailure('A live store needs a logo', StoreCodes.notReady),
      );
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    expect(find.text('Not ready'), findsOneWidget);
    expect(find.text('Before customers see it'), findsOneWidget);
    expect(find.text('Missing'), findsNWidgets(2));
    expect(find.text('Done'), findsOneWidget);

    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
    expect(find.text('Needs: Logo · Opening hours'), findsOneWidget);
    await tester.tap(find.text('Enable store'));
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', true)]);
    expect(
      find.text(
        'A store customers see needs a logo, pickup instructions and '
        'opening hours.',
      ),
      findsOneWidget,
    );
    expect(find.text('Not ready'), findsOneWidget);
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
    expect(find.text('Store 1 · Area 1'), findsOneWidget);
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
    expect(find.text('Show your code at the cashier.'), findsOneWidget);
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
    expect(find.text('Disable Sweet Coast · Hay Al Andalus?'), findsOneWidget);
    await tester.tap(find.text('Disable store').last);
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', false)]);
    expect(find.text('Store disabled'), findsOneWidget);
    // It has all it needs, so it can be turned on again.
    expect(find.text('Ready to turn on'), findsOneWidget);
    expect(find.text('Before customers see it'), findsOneWidget);

    await chooseAction(tester, 'Enable store');
    expect(stores.activeChanges.last, ('store-1', true));
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('says what turning it off touches before confirming', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..ongoingResult = const Ok(StoreOngoing(liveOffers: 2, openBookings: 1));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable store');

    expect(
      find.textContaining('Its 2 live offers are hidden with it.'),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        '1 booking is waiting to be picked up. It stays valid, and if the '
        "customer misses it, it won't count against them.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('once off, an admin can cancel the bookings waiting there', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..ongoingResult = const Ok(StoreOngoing(liveOffers: 0, openBookings: 2))
      ..cancelBookingsResult = const Ok(2);
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable store');
    await tester.tap(find.text('Disable store').last);
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', false)]);
    expect(
      find.text(
        'Cancel the 2 bookings waiting at Sweet Coast · Hay Al Andalus?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel the bookings'));
    await tester.pumpAndSettle();

    expect(stores.bookingsCancelled, ['store-1']);
    expect(
      find.text('2 bookings cancelled: their customers were told'),
      findsOneWidget,
    );
  });

  testWidgets('keeps the bookings when the admin says so', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..ongoingResult = const Ok(StoreOngoing(liveOffers: 0, openBookings: 1));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable store');
    await tester.tap(find.text('Disable store').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep them'));
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', false)]);
    expect(stores.bookingsCancelled, isEmpty);
  });

  testWidgets("an editor isn't asked to cancel the bookings", (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..ongoingResult = const Ok(StoreOngoing(liveOffers: 0, openBookings: 1));
    await tester.pumpWidget(harness(stores, admin: false));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable store');
    await tester.tap(find.text('Disable store').last);
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', false)]);
    expect(find.text('Keep them'), findsNothing);
  });

  testWidgets("a store that's off cancels its bookings from the menu", (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..detailsResult = Ok(sampleDetails('store-1', active: false));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    // None waiting: nothing to ask.
    await chooseAction(tester, 'Cancel its bookings');
    expect(find.text('No bookings are waiting at this store'), findsOneWidget);
    expect(stores.bookingsCancelled, isEmpty);

    stores
      ..ongoingResult = const Ok(StoreOngoing(liveOffers: 0, openBookings: 1))
      ..cancelBookingsResult = const Ok(1);
    await chooseAction(tester, 'Cancel its bookings');
    await tester.tap(find.text('Cancel the bookings'));
    await tester.pumpAndSettle();

    expect(stores.bookingsCancelled, ['store-1']);
    expect(
      find.text('Booking cancelled: its customer was told'),
      findsOneWidget,
    );
  });

  testWidgets('still asks when what it touches can\'t be read', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..ongoingResult = const Err(NoConnectionFailure());
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable store');
    await tester.tap(find.text('Disable store').last);
    await tester.pumpAndSettle();

    expect(stores.activeChanges, [('store-1', false)]);
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
    expect(find.text('Delete Sweet Coast · Hay Al Andalus?'), findsOneWidget);
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
    of: textField(label),
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

    await tester.enterText(field('Pickup instructions'), ' Ask at the door. ');
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
    expect(edited.pickupInstructions, 'Ask at the door.');
    expect(edited.phone, '+218921234567');
    expect(edited.email, isNull);
    expect(edited.instagramUrl, 'https://instagram.com/sweetcoast');
    // The place wasn't touched, so it isn't sent.
    expect(edited.place, isNull);
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

  testWidgets('keeps its phone: it can change, not be emptied', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Store phone'), '');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates, isEmpty);
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('says why a live store keeps its pickup instructions', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..updateResult = const Err(
        ConflictFailure(
          'A live store needs pickup instructions',
          StoreCodes.notReady,
        ),
      );
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.enterText(field('Pickup instructions'), '');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates.single.$2.pickupInstructions, isNull);
    expect(
      find.text(
        'A store customers see needs a logo, pickup instructions and '
        'opening hours.',
      ),
      findsOneWidget,
    );
    expect(find.text('Not saved'), findsOneWidget);
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
    expect(find.text('Store 1 · Area 1'), findsOneWidget);
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

  testWidgets('shows the place and its hours, without reading it again', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Place'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Tripoli'), findsOneWidget);
    expect(find.text('Hay Al Andalus'), findsOneWidget);
    expect(find.text('Jaraba Street'), findsOneWidget);
    expect(find.text('32.8872, 13.1913'), findsOneWidget);
    expect(find.text('Location found: 32.88720, 13.19130'), findsOneWidget);
    expect(find.text('08:00-13:00, 16:00-23:00'), findsOneWidget);
    expect(find.text('16:00-23:00'), findsOneWidget);
    expect(stores.resolvedLinks, isEmpty);
    expect(find.text('Not saved'), findsNothing);
  });

  testWidgets('moves the store and changes its hours', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..locationResult = const Ok((latitude: 32.9, longitude: 13.2));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Place'));
    await tester.pumpAndSettle();
    // Every store has an area: it can change, not be emptied.
    await tester.enterText(field('Area'), '');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsOneWidget);
    expect(stores.updates, isEmpty);
    await tester.enterText(field('Area'), 'Gargaresh');
    await tester.enterText(field('Location'), 'https://maps.app.goo.gl/AbC');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(stores.resolvedLinks, ['https://maps.app.goo.gl/AbC']);
    expect(find.text('Location found: 32.90000, 13.20000'), findsOneWidget);
    await tester.enterText(field('Saturday'), '9-22');
    await tester.enterText(field('Friday'), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final place = stores.updates.single.$2.place!;
    expect(place.city, City.tripoli);
    expect(place.area, 'Gargaresh');
    expect(place.address, 'Jaraba Street');
    expect(place.latitude, 32.9);
    expect(place.longitude, 13.2);
    expect(
      place.openingHours,
      const OpeningHours({
        Weekday.sat: [OpeningShift(opens: 9 * 60, closes: 22 * 60)],
      }),
    );
    expect(find.text('Saved'), findsOneWidget);
    // Filled again from what was saved.
    expect(find.text('09:00-22:00'), findsOneWidget);
    expect(find.text('32.9, 13.2'), findsOneWidget);
  });

  testWidgets('waits for a new location to be read before saving', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..locationResult = const Ok((latitude: 32.9, longitude: 13.2));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Place'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Location'), '32.9, 13.2');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(stores.updates.single.$2.place?.latitude, 32.9);
  });

  testWidgets('marks the location when the new place is outside Libya', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..locationResult = const Ok((latitude: 48.85, longitude: 2.35))
      ..updateResult = const Err(
        ValidationFailure([], code: LocationCodes.outsideLibya),
      );
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Place'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Location'), '48.85, 2.35');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates, hasLength(1));
    expect(find.text('This location is outside Libya.'), findsOneWidget);
    expect(find.text('Not saved'), findsOneWidget);
  });

  testWidgets("doesn't save hours it can't read", (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Place'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Sunday'), '8-12, 13-14, 15-16, 17-18, 19-20');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates, isEmpty);
    expect(
      find.text('Write times like 08:00-23:00, at most 4 a day.'),
      findsOneWidget,
    );
  });

  Finder dialogField(String label) => find.descendant(
    of: find.bySubtype<SDialog>(),
    matching: find.descendant(
      of: textField(label),
      matching: find.byType(EditableText),
    ),
  );

  testWidgets('adds another location of the brand and opens it', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..locationResult = const Ok((latitude: 32.85, longitude: 13.1));
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Add another location');
    expect(find.text('New location of Sweet Coast'), findsOneWidget);
    expect(
      find.textContaining('name, photos, category, contact links'),
      findsOneWidget,
    );

    // Nothing is sent without a location.
    await tester.tap(find.text('Add location'));
    await tester.pumpAndSettle();
    expect(stores.addedLocations, isEmpty);

    await tester.enterText(dialogField('Area'), 'Gargaresh');
    await tester.enterText(
      dialogField('Location'),
      'https://maps.app.goo.gl/XyZ',
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.enterText(dialogField('Thursday'), '10-22');
    await tester.enterText(dialogField('Phone of this location'), '0947654321');
    await tester.tap(find.text('Add location'));
    await tester.pumpAndSettle();

    final (brandId, location) = stores.addedLocations.single;
    expect(brandId, 'store-1');
    expect(location.place.city, City.tripoli);
    expect(location.place.area, 'Gargaresh');
    expect(location.place.latitude, 32.85);
    expect(
      location.place.openingHours,
      const OpeningHours({
        Weekday.thu: [OpeningShift(opens: 10 * 60, closes: 22 * 60)],
      }),
    );
    expect(location.phone, '+218947654321');

    expect(find.text('Location added'), findsOneWidget);
    expect(find.bySubtype<SDialog>(), findsNothing);
    expect(stores.opened.last, 'store-new');
    expect(find.byType(StoreDetailsScreen), findsOneWidget);
  });

  testWidgets('a new location without a phone takes the brand\'s', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Add another location');
    await tester.enterText(dialogField('Location'), '32.8872, 13.1913');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    // Not without its area: it tells the brand's places apart.
    await tester.tap(find.text('Add location'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsOneWidget);
    expect(stores.addedLocations, isEmpty);
    await tester.enterText(dialogField('Area'), 'Gargaresh');
    await tester.tap(find.text('Add location'));
    await tester.pumpAndSettle();

    final (_, location) = stores.addedLocations.single;
    expect(location.phone, isNull);
    expect(location.place.area, 'Gargaresh');
    expect(location.place.openingHours, isEmpty);
  });

  testWidgets('says why a new location was refused', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..addLocationResult = const Err(
        ValidationFailure([], code: LocationCodes.outsideLibya),
      );
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Add another location');
    await tester.enterText(dialogField('Area'), 'Gargaresh');
    await tester.enterText(dialogField('Location'), '32.8872, 13.1913');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add location'));
    await tester.pumpAndSettle();

    expect(find.text('This location is outside Libya.'), findsOneWidget);
    expect(find.text('New location of Sweet Coast'), findsOneWidget);
    expect(stores.opened, ['store-1']);
  });

  group('photos', () {
    // A real 1×1 picture, so the preview can be drawn.
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwAD'
      'hgGAWjR9awAAAABJRU5ErkJggg==',
    );

    Future<void> openPhotos(
      WidgetTester tester,
      FakeStoreRepository stores, {
      FakePhotoPicker? photos,
    }) async {
      setWindow(tester);
      await tester.pumpWidget(harness(stores, photos: photos));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Photos'));
      await tester.pumpAndSettle();
    }

    testWidgets('adds a logo from the computer, uploaded right away', (
      tester,
    ) async {
      final stores = FakeStoreRepository()
        ..detailsResult = Ok(sampleDetails('store-1', active: false));
      final photo = PreparedPhoto(full: png, thumb: png);
      final photos = FakePhotoPicker(PhotoReady(photo));
      await openPhotos(tester, stores, photos: photos);
      expect(find.text('Remove the logo'), findsNothing);

      await tester.tap(find.bySemanticsLabel('Add a logo'));
      await tester.pumpAndSettle();

      expect(photos.picks, [PhotoSource.gallery]);
      expect(photos.shapes, [PhotoShape.round]);
      expect(stores.imageUploads.single, ('store-1', StoreImage.logo, photo));
      expect(find.text('Remove the logo'), findsOneWidget);
      expect(find.text('Add a cover photo'), findsOneWidget);
    });

    testWidgets('says when a photo is too big to upload', (tester) async {
      final stores = FakeStoreRepository();
      final photos = FakePhotoPicker(const PhotoFailed(PhotoTooLarge()));
      await openPhotos(tester, stores, photos: photos);

      await tester.tap(find.bySemanticsLabel('Add a cover photo'));
      await tester.pumpAndSettle();

      expect(
        find.text('This photo is over 1 MB. Choose a smaller one, or a JPEG.'),
        findsOneWidget,
      );
      expect(stores.imageUploads, isEmpty);
    });

    testWidgets('removes the cover once confirmed', (tester) async {
      final stores = FakeStoreRepository()
        ..detailsResult = Ok(
          sampleDetails(
            'store-1',
            logoUrl: 'https://img.test/logo.jpg',
            coverUrl: 'https://img.test/cover.jpg',
          ),
        );
      await openPhotos(tester, stores);

      await tester.tap(find.text('Remove the cover'));
      await tester.pumpAndSettle();
      expect(
        find.text("Remove Sweet Coast · Hay Al Andalus's cover photo?"),
        findsOneWidget,
      );
      await tester.tap(find.text('Remove the cover').last);
      await tester.pumpAndSettle();

      expect(stores.removedImages, [('store-1', StoreImage.cover)]);
      expect(find.text('Photo removed'), findsOneWidget);
      expect(find.text('Remove the cover'), findsNothing);
      expect(find.text('Add a cover photo'), findsOneWidget);
    });

    testWidgets('a live store keeps its logo: it can only be changed', (
      tester,
    ) async {
      final stores = FakeStoreRepository()
        ..detailsResult = Ok(
          sampleDetails('store-1', logoUrl: 'https://img.test/logo.jpg'),
        );
      await openPhotos(tester, stores);

      expect(find.text('Remove the logo'), findsNothing);
      expect(
        find.text(
          'A live store keeps its logo: it can be changed, not removed.',
        ),
        findsOneWidget,
      );
    });
  });
}
