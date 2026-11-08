import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/domain/saved_place.dart';
import 'package:customer/features/location/presentation/place_details_view_model.dart';
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
  const moved = GeoPoint(32.9, 13.19);
  const PlaceDraft adding = (place: null, point: souqAlJuma);
  const PlaceDraft editing = (place: home, point: souqAlJuma);

  late FakePlacesRepository places;
  late ProviderContainer container;

  setUp(() async {
    places = FakePlacesRepository([home]);
    container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer),
        placesRepositoryProvider.overrideWithValue(places),
        sessionProvider.overrideWith(() => SignedInSession(customer())),
      ],
    );
    addTearDown(container.dispose);
    // The page under the sheet keeps the list.
    container.listen(savedPlacesViewModel, (_, _) {});
    await container.read(savedPlacesViewModel.future);
  });

  PlaceDetailsViewModel open(PlaceDraft draft) {
    container.listen(placeDetailsViewModel(draft), (_, _) {});
    return container.read(placeDetailsViewModel(draft).notifier);
  }

  void fill(PlaceDetailsViewModel viewModel, {String? name, String? note}) =>
      viewModel.form.value = {'name': name, 'note': note};

  test('needs a name', () {
    final viewModel = open(adding);
    fill(viewModel, name: '   ', note: 'Second floor');
    expect(viewModel.submit(), isNull);
    expect(viewModel.form.control('name').touched, isTrue);
  });

  test('gives the name and description, trimmed', () {
    final viewModel = open(adding);
    fill(viewModel, name: ' Home ', note: ' Second floor ');
    expect(viewModel.submit(), (name: 'Home', note: 'Second floor'));
  });

  test('the description can be left out', () {
    final viewModel = open(adding);
    fill(viewModel, name: 'Work', note: '  ');
    expect(viewModel.submit(), (name: 'Work', note: null));
  });

  test('a name too long is refused', () {
    final viewModel = open(adding);
    fill(viewModel, name: 'x' * (PlaceDetailsViewModel.nameMaxLength + 1));
    expect(viewModel.submit(), isNull);
  });

  test('a new place is saved where the map was set', () async {
    final viewModel = open(adding);

    expect(await viewModel.save((name: 'Work', note: null)), isNull);

    expect(places.places.last.name, 'Work');
    expect(places.places.last.point, souqAlJuma);
    expect(container.read(browseLocationProvider)?.name, 'Work');
  });

  test('a saved place starts with its name and description', () {
    final viewModel = open(editing);

    expect(viewModel.form.value, {'name': 'Home', 'note': 'Second floor'});
    expect(viewModel.moved, isFalse);
  });

  test('keeps the new details and where it moved to', () async {
    final viewModel = open(editing)..moveTo(moved);
    expect(viewModel.moved, isTrue);

    expect(await viewModel.save((name: 'Our house', note: null)), isNull);

    final saved = places.places.single;
    expect((saved.name, saved.note, saved.point), ('Our house', null, moved));
    expect(container.read(placeDetailsViewModel(editing)).saving, isFalse);
  });

  test('gives back what the backend refused', () async {
    places.failure = const NoConnectionFailure();
    final viewModel = open(editing);

    expect(
      await viewModel.save((name: 'Our house', note: null)),
      isA<NoConnectionFailure>(),
    );
    expect(places.places.single.name, 'Home');
  });
}
