import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/domain/saved_place.dart';
import 'package:customer/features/location/presentation/saved_places_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  const home = SavedPlace(
    id: '1',
    name: 'Home',
    point: souqAlJuma,
    note: 'Second floor',
  );
  const work = SavedPlace(id: '2', name: 'Work', point: GeoPoint(32.88, 13.2));
  const moved = GeoPoint(32.9, 13.19);

  late FakePlacesRepository places;

  setUp(() => places = FakePlacesRepository([home, work]));

  /// Signed in unless [guest], browsing from [location].
  Future<ProviderContainer> open({
    bool guest = false,
    BrowseLocation? location,
  }) async {
    final c = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer),
        placesRepositoryProvider.overrideWithValue(places),
        browseLocationProvider.overrideWith(
          () => BrowseLocationController(location),
        ),
        if (!guest)
          sessionProvider.overrideWith(() => SignedInSession(customer())),
      ],
    );
    addTearDown(c.dispose);
    c.listen(savedPlacesViewModel, (_, _) {});
    await c.read(savedPlacesViewModel.future);
    return c;
  }

  SavedPlacesViewModel viewModel(ProviderContainer c) =>
      c.read(savedPlacesViewModel.notifier);

  List<String> names(ProviderContainer c) => [
    for (final place in c.read(savedPlacesViewModel).requireValue) place.name,
  ];

  test('a guest has none, and nothing is asked', () async {
    final c = await open(guest: true);

    expect(names(c), isEmpty);
    expect(places.loads, 0);
  });

  test("loads the account's places", () async {
    final c = await open();

    expect(names(c), ['Home', 'Work']);
  });

  test('a place added is saved, then shown from', () async {
    final c = await open();

    expect(
      await viewModel(c).add((name: 'Family', note: null), souqAlJuma),
      isNull,
    );

    expect(names(c), ['Home', 'Work', 'Family']);
    final location = c.read(browseLocationProvider);
    expect((location?.placeId, location?.name), ('p3', 'Family'));
  });

  test('a change the backend refused changes nothing', () async {
    final c = await open(location: BrowseLocation.of(home));
    places.failure = const NoConnectionFailure();

    expect(
      await viewModel(c).add((name: 'Family', note: null), souqAlJuma),
      isA<NoConnectionFailure>(),
    );
    expect(
      await viewModel(c)
          .change(const SavedPlace(id: '1', name: 'Our house', point: moved)),
      isA<NoConnectionFailure>(),
    );
    expect(await viewModel(c).remove(work), isA<NoConnectionFailure>());

    expect(names(c), ['Home', 'Work']);
    expect(c.read(browseLocationProvider)?.name, 'Home');
  });

  test('offers follow the place in use where it moved', () async {
    final c = await open(location: BrowseLocation.of(home));

    await viewModel(c)
        .change(const SavedPlace(id: '1', name: 'Our house', point: moved));

    expect(names(c), ['Our house', 'Work']);
    final location = c.read(browseLocationProvider);
    expect((location?.name, location?.point), ('Our house', moved));
  });

  test('changing another place leaves the one in use', () async {
    final c = await open(location: BrowseLocation.of(home));

    await viewModel(c)
        .change(const SavedPlace(id: '2', name: 'Office', point: moved));

    expect(c.read(browseLocationProvider)?.name, 'Home');
  });

  test('a place deleted is gone', () async {
    final c = await open(location: BrowseLocation.of(home));

    expect(await viewModel(c).remove(work), isNull);

    expect(names(c), ['Home']);
    expect(places.places.single.id, '1');
  });
}
