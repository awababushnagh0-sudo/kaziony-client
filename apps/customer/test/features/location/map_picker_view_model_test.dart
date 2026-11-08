import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/presentation/location_problem.dart';
import 'package:customer/features/location/presentation/map_picker_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeLocationFinder finder;
  late FakeServiceAreaRepository areas;

  setUp(() {
    finder = FakeLocationFinder();
    areas = FakeServiceAreaRepository();
  });

  /// The map from [start], or from where the customer browses ([saved]).
  Future<ProviderContainer> open({
    BrowseLocation? saved,
    GeoPoint? start,
  }) async {
    final container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer, locationFinder: finder),
        serviceAreaRepositoryProvider.overrideWithValue(areas),
        browseLocationProvider.overrideWith(
          () => BrowseLocationController(saved),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(mapPickerViewModel(start), (_, _) {});
    await container.read(mapPickerViewModel(start).future);
    return container;
  }

  MapPickerState state(ProviderContainer c) =>
      c.read(mapPickerViewModel(null)).requireValue;

  test('starts in the middle of the first area', () async {
    final c = await open();
    expect(state(c).target, tripoli.center);
    expect(state(c).inside, isTrue);
  });

  test('starts where the customer browses from, if still inside', () async {
    var c = await open(saved: const BrowseLocation(souqAlJuma, pinned: true));
    expect(state(c).target, souqAlJuma);

    c = await open(saved: const BrowseLocation(zawiya, pinned: true));
    expect(state(c).target, tripoli.center);
  });

  test('gives back a pinned place inside an area', () async {
    final c = await open();
    final viewModel = c.read(mapPickerViewModel(null).notifier)
      ..moved(souqAlJuma);

    expect(viewModel.confirm(), souqAlJuma);
    // The page that opened the map keeps it, or saves it.
    expect(c.read(browseLocationProvider), isNull);
  });

  test('starts where it was told, where the phone was found', () async {
    final c = await open(
      saved: BrowseLocation(tripoli.center, pinned: true),
      start: souqAlJuma,
    );
    expect(
      c.read(mapPickerViewModel(souqAlJuma)).requireValue.target,
      souqAlJuma,
    );
  });

  test('refuses a place outside the areas', () async {
    final c = await open();
    final viewModel = c.read(mapPickerViewModel(null).notifier)..moved(zawiya);

    expect(state(c).inside, isFalse);
    expect(viewModel.confirm(), isNull);
  });

  test('moves to where the phone is', () async {
    final c = await open();
    final viewModel = c.read(mapPickerViewModel(null).notifier);

    expect(await viewModel.goToMyLocation(), isNull);
    expect(state(c).target, const GeoPoint(32.88, 13.19));
    expect(state(c).locating, isFalse);
  });

  test('says why it could not move to the phone', () async {
    finder.next = const LocationOff();
    final c = await open();
    final viewModel = c.read(mapPickerViewModel(null).notifier);

    expect(await viewModel.goToMyLocation(), LocationProblem.off);
    expect(state(c).target, tripoli.center);
  });

  test('fails to open without the areas', () async {
    areas.result = const Err(NoConnectionFailure());
    final container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer),
        serviceAreaRepositoryProvider.overrideWithValue(areas),
      ],
    );
    addTearDown(container.dispose);
    container.listen(mapPickerViewModel(null), (_, _) {});
    await pumpEventQueue();
    expect(
      container.read(mapPickerViewModel(null)).error,
      isA<NoConnectionFailure>(),
    );
  });
}
