import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/domain/saved_place.dart';
import 'package:customer/features/location/presentation/places_screen.dart';
import 'package:customer/features/location/presentation/saved_places_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  const home = SavedPlace(
    id: '1',
    name: 'Home',
    point: souqAlJuma,
    note: 'Second floor',
  );
  const work = SavedPlace(id: '2', name: 'Work', point: GeoPoint(32.88, 13.2));

  late FakeLocationFinder finder;
  late FakePlacesRepository repository;

  late MemorySettingsStore settings;

  setUp(() {
    finder = FakeLocationFinder();
    repository = FakePlacesRepository();
    settings = MemorySettingsStore();
  });

  Future<BrowseLocation?> kept() =>
      BrowseLocationController.readSaved(settings);

  /// The page opened from another, browsing from [location], signed in
  /// with [places] unless [guest].
  Future<void> open(
    WidgetTester tester, {
    BrowseLocation? location,
    List<SavedPlace> places = const [home, work],
    bool guest = false,
  }) async {
    repository.places.addAll(places);
    await pumpCustomerPages(
      tester,
      initial: '/',
      locationFinder: finder,
      settings: settings,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => SButton(
            label: 'open',
            onPressed: () => context.push(Routes.places),
          ),
        ),
        GoRoute(
          path: Routes.places,
          builder: (_, _) => const PlacesScreen(),
          routes: [stubPage('add', 'add place page')],
        ),
      ],
      overrides: [
        serviceAreaRepositoryProvider.overrideWithValue(
          FakeServiceAreaRepository(),
        ),
        browseLocationProvider.overrideWith(
          () => BrowseLocationController(location ?? BrowseLocation.of(home)),
        ),
        placesRepositoryProvider.overrideWithValue(repository),
        if (!guest)
          sessionProvider.overrideWith(() => SignedInSession(customer())),
      ],
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  /// Whether the tile titled [title] is the chosen one.
  void expectChosen(
    WidgetTester tester,
    String title, {
    required bool chosen,
  }) => expect(
    tester.getSemantics(find.text(title)),
    isSemantics(isChecked: chosen),
  );

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('lists where the phone is and the saved places', (tester) async {
    await open(tester);

    expect(find.text('Show offers near'), findsOneWidget);
    expect(find.text('My current location'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Second floor'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Add a place'), findsOneWidget);
    expectChosen(tester, 'Home', chosen: true);
    expectChosen(tester, 'Work', chosen: false);
  });

  testWidgets('asks before switching to another saved place', (tester) async {
    await open(tester);

    await tapAndSettle(tester, find.text('Work'));
    expect(find.text('Switch place?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Cancel'));
    expectChosen(tester, 'Home', chosen: true);
    expect(await kept(), isNull);

    await tapAndSettle(tester, find.text('Work'));
    await tapAndSettle(tester, find.text('Switch'));

    expect(find.text('Show offers near'), findsNothing);
    expect((await kept())?.placeId, '2');
  });

  testWidgets('the place in use asks nothing', (tester) async {
    await open(tester);

    await tapAndSettle(tester, find.text('Home'));

    expect(find.text('Switch place?'), findsNothing);
  });

  testWidgets('switches to where the phone is', (tester) async {
    await open(tester);

    await tapAndSettle(tester, find.text('My current location'));
    await tapAndSettle(tester, find.text('Switch'));

    expect(finder.asked, 1);
    expect(find.text('Show offers near'), findsNothing);
    expect((await kept())?.pinned, isFalse);
  });

  testWidgets('stays and says why the phone could not be used', (tester) async {
    finder.next = const LocationOff();
    await open(tester);

    await tapAndSettle(tester, find.text('My current location'));
    await tapAndSettle(tester, find.text('Switch'));

    expect(find.text('Show offers near'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
    expectChosen(tester, 'Home', chosen: true);
    expect(await kept(), isNull);
  });

  testWidgets('asks before deleting a saved place', (tester) async {
    await open(tester);

    await tapAndSettle(tester, find.byTooltip('Delete'));
    expect(find.text('Delete “Work”?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Delete place'));

    expect(find.text('Work'), findsNothing);
    expect(find.text('Place deleted'), findsOneWidget);
    expect(repository.places, [home]);
  });

  testWidgets('keeps a place the backend would not delete', (tester) async {
    await open(tester);
    repository.failure = const NoConnectionFailure();

    await tapAndSettle(tester, find.byTooltip('Delete'));
    await tapAndSettle(tester, find.text('Delete place'));

    expect(find.text('Work'), findsOneWidget);
    expect(find.text('No internet connection'), findsOneWidget);
  });

  testWidgets('the place in use cannot be deleted', (tester) async {
    await open(tester);

    // Only Work has a bin: Home is where offers are shown from.
    expect(find.byTooltip('Delete'), findsOneWidget);
    expect(find.byTooltip('Edit'), findsNWidgets(2));
  });

  testWidgets('the last saved place can only be changed', (tester) async {
    // Not in use, offers being around the phone: still the last one.
    await open(
      tester,
      places: const [home],
      location: const BrowseLocation(souqAlJuma, pinned: false),
    );

    expect(find.byTooltip('Delete'), findsNothing);
    expect(find.byTooltip('Edit'), findsOneWidget);
  });

  testWidgets('opens a saved place to change it', (tester) async {
    await open(tester);

    await tapAndSettle(tester, find.byTooltip('Edit').last);

    expect(find.text('Edit place'), findsOneWidget);
    expect(find.text('Spot on the map'), findsOneWidget);
  });

  testWidgets('a guest signs in to add a place', (tester) async {
    await open(tester, guest: true, places: const []);

    await tapAndSettle(tester, find.text('Add a place'));

    expect(find.text('Sign in to save your places'), findsOneWidget);
    expect(find.text('add place page'), findsNothing);
  });

  testWidgets('opens the page to add one', (tester) async {
    await open(tester);

    await tapAndSettle(tester, find.text('Add a place'));

    expect(find.text('add place page'), findsOneWidget);
  });

  testWidgets('no more than the most places', (tester) async {
    await open(
      tester,
      places: [
        for (var i = 0; i < SavedPlacesViewModel.max; i++)
          SavedPlace(id: '$i', name: 'Place $i', point: souqAlJuma),
      ],
    );

    expect(find.text('Add a place', skipOffstage: false), findsNothing);
  });

  group('opening', () {
    /// A page that keeps the places, as the tabs do, and opens where
    /// offers are shown from.
    Future<void> openFrom(
      WidgetTester tester, {
      List<SavedPlace> places = const [],
      bool guest = false,
    }) async {
      repository.places.addAll(places);
      await pumpCustomerPages(
        tester,
        initial: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => AppConsumer(
              builder: (context, ref) {
                ref.watch(savedPlacesViewModel);
                return SButton(
                  label: 'open',
                  onPressed: () => PlacesScreen.open(context, ref),
                );
              },
            ),
          ),
          stubPage(Routes.places, 'places page'),
          stubPage(Routes.location, 'location page'),
        ],
        overrides: [
          placesRepositoryProvider.overrideWithValue(repository),
          if (!guest)
            sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('lists the saved places', (tester) async {
      await openFrom(tester, places: const [home]);
      expect(find.text('places page'), findsOneWidget);
    });

    testWidgets('with none saved, asks where instead', (tester) async {
      await openFrom(tester);
      expect(find.text('location page'), findsOneWidget);
    });

    testWidgets('a guest is asked where too', (tester) async {
      await openFrom(tester, guest: true);
      expect(find.text('location page'), findsOneWidget);
    });
  });
}
