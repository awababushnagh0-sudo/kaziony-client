import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/stores/domain/location.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:admin/features/stores/presentation/stores_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeStoreRepository stores) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    storeRepositoryProvider.overrideWithValue(stores),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const StoresScreen())],
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

/// The text fields of the add-store dialog, in order (the page's search
/// box behind it doesn't count).
enum Field {
  name,
  phone,
  email,
  area,
  address,
  location,
  saturday,
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  owner,
  ownerPhone,
}

/// Types a location and waits for the backend to read it.
Future<void> typeLocation(WidgetTester tester, String text) async {
  await type(tester, Field.location, text);
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> type(WidgetTester tester, Field field, String text) =>
    tester.enterText(
      find
          .descendant(
            of: find.bySubtype<SDialog>(),
            matching: find.byType(EditableText),
          )
          .at(field.index),
      text,
    );

void main() {
  testWidgets('lists the stores with their status and the total', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()));
    await tester.pumpAndSettle();

    // Each with its area: a brand's places share the name.
    expect(find.text('Store 1 · Area 1'), findsOneWidget);
    expect(find.text('Store 2 · Area 2'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);
    expect(find.text('Disabled'), findsWidgets);
    expect(find.text('2 stores'), findsOneWidget);
    expect(find.text('Page 1 of 1'), findsOneWidget);
  });

  testWidgets('searches after a pause in typing, from the first page', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), 'store 2');
    await tester.pump(const Duration(milliseconds: 100));
    expect(stores.queries, hasLength(1), reason: 'still typing');
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(stores.queries.last.search, 'store 2');
    expect(find.text('Store 1 · Area 1'), findsNothing);
    expect(find.text('Store 2 · Area 2'), findsOneWidget);
  });

  testWidgets('filters by status', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    // The pill, not the badge in the table.
    await tester.tap(find.text('Disabled').first);
    await tester.pumpAndSettle();
    expect(stores.queries.last.filter, StoreStatus.disabled);
  });

  testWidgets('offers to add the first store when there are none', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeStoreRepository()..stores = []));
    await tester.pumpAndSettle();

    expect(find.text('No stores yet'), findsOneWidget);
    expect(find.text('Add store'), findsNWidgets(2));
  });

  testWidgets('adds a store and shows the owner login once', (tester) async {
    setWindow(tester);
    final stores = FakeStoreRepository();
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add store'));
    await tester.pumpAndSettle();
    expect(find.text('New store'), findsOneWidget);

    // Nothing is sent while required fields are empty.
    await tester.tap(find.text('Create store'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsWidgets);
    expect(stores.created, isEmpty);

    await type(tester, Field.name, 'حلويات الساحل');
    await tester.tap(find.bySubtype<SSelectInput<String>>());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sweets').last);
    await tester.pumpAndSettle();
    await type(tester, Field.email, 'hello@sahel.ly');
    await type(tester, Field.area, ' حي الأندلس ');
    await type(tester, Field.saturday, '8-13، 16-23');
    await type(tester, Field.friday, '16:00 - 24');
    await type(tester, Field.monday, 'all day');
    stores.locationResult = const Err(
      ValidationFailure([], code: LocationCodes.unreadable),
    );
    await typeLocation(tester, 'not a place');
    await type(tester, Field.owner, 'Ahmed');
    await type(tester, Field.ownerPhone, '091 234 5678');
    await tester.tap(find.text('Create store'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining("Couldn't read a location from this link"),
      findsOneWidget,
    );
    expect(
      find.text('Write times like 08:00-23:00, at most 4 a day.'),
      findsOneWidget,
    );
    expect(stores.created, isEmpty);
    await type(tester, Field.monday, '');

    stores.locationResult = const Ok((latitude: 32.8872, longitude: 13.1913));
    await typeLocation(tester, 'https://maps.app.goo.gl/AbC123');
    expect(stores.resolvedLinks.last, 'https://maps.app.goo.gl/AbC123');
    expect(find.text('Location found: 32.88720, 13.19130'), findsOneWidget);
    await tester.tap(find.text('Create store'));
    await tester.pumpAndSettle();

    final store = stores.created.single;
    expect(store.name, 'حلويات الساحل');
    expect(store.categoryId, sampleCategory.id);
    expect(store.email, 'hello@sahel.ly');
    expect(store.place.city, City.tripoli);
    expect(store.place.area, 'حي الأندلس');
    expect(store.place.address, isNull);
    expect(store.place.latitude, 32.8872);
    expect(store.place.longitude, 13.1913);
    expect(
      store.place.openingHours,
      const OpeningHours({
        Weekday.sat: [
          OpeningShift(opens: 8 * 60, closes: 13 * 60),
          OpeningShift(opens: 16 * 60, closes: 23 * 60),
        ],
        Weekday.fri: [OpeningShift(opens: 16 * 60, closes: 0)],
      }),
    );
    expect(store.ownerPhone, '+218912345678');

    expect(find.text('Store created'), findsOneWidget);
    expect(find.text('0912345678'), findsOneWidget);
    expect(find.text('Tmp-4821-xk'), findsOneWidget);
    // The list reloads behind the dialog.
    expect(stores.queries, hasLength(2));

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Store created'), findsNothing);
  });

  testWidgets('explains when the owner phone is a customer account', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..createResult = const Err(ConflictFailure());
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add store'));
    await tester.pumpAndSettle();
    await type(tester, Field.name, 'Cafe');
    await tester.tap(find.bySubtype<SSelectInput<String>>());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sweets').last);
    await tester.pumpAndSettle();
    await typeLocation(tester, '32.8872, 13.1913');
    await type(tester, Field.owner, 'Sara');
    await type(tester, Field.ownerPhone, '0921234567');
    await tester.tap(find.text('Create store'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('belongs to a customer account'),
      findsOneWidget,
    );
    // The dialog stays open with what was typed.
    expect(find.text('New store'), findsOneWidget);
  });

  testWidgets('says so when the store is refused for being outside Libya', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..createResult = const Err(
        ValidationFailure([], code: LocationCodes.outsideLibya),
      );
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add store'));
    await tester.pumpAndSettle();
    await type(tester, Field.name, 'Cafe');
    await tester.tap(find.bySubtype<SSelectInput<String>>());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sweets').last);
    await tester.pumpAndSettle();
    await typeLocation(tester, '32.8872, 13.1913');
    await type(tester, Field.owner, 'Sara');
    await type(tester, Field.ownerPhone, '0921234567');
    await tester.tap(find.text('Create store'));
    await tester.pumpAndSettle();

    expect(stores.created, hasLength(1));
    expect(find.text('This location is outside Libya.'), findsOneWidget);
    expect(find.text('New store'), findsOneWidget);
  });

  testWidgets('says why a location can\'t be used, and checks again', (
    tester,
  ) async {
    setWindow(tester);
    final stores = FakeStoreRepository()
      ..locationResult = const Err(
        ValidationFailure([], code: LocationCodes.outsideLibya),
      );
    await tester.pumpWidget(harness(stores));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add store'));
    await tester.pumpAndSettle();

    await typeLocation(tester, '48.85, 2.35');
    expect(find.text('This location is outside Libya.'), findsOneWidget);

    // No connection: submitting reads the link again.
    stores.locationResult = const Err(NoConnectionFailure());
    await typeLocation(tester, '32.8872, 13.1913');
    expect(find.textContaining("Couldn't check the link"), findsOneWidget);

    stores.locationResult = const Ok((latitude: 32.8872, longitude: 13.1913));
    await tester.tap(find.text('Create store'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(stores.resolvedLinks, hasLength(3));
    expect(find.text('Location found: 32.88720, 13.19130'), findsOneWidget);
  });
}
