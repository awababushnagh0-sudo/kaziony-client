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

  Future<ProviderContainer> open({BrowseLocation? saved}) async {
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
    container.listen(mapPickerViewModel, (_, _) {});
    await container.read(mapPickerViewModel.future);
    return container;
  }

  MapPickerState state(ProviderContainer c) =>
      c.read(mapPickerViewModel).requireValue;

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

  test('keeps a pinned place inside an area', () async {
    final c = await open();
    final viewModel = c.read(mapPickerViewModel.notifier)..moved(souqAlJuma);

    expect(await viewModel.confirm(), isTrue);
    final place = c.read(browseLocationProvider);
    expect(place?.point, souqAlJuma);
    expect(place?.pinned, isTrue);
  });

  test('refuses a place outside the areas', () async {
    final c = await open();
    final viewModel = c.read(mapPickerViewModel.notifier)..moved(zawiya);

    expect(state(c).inside, isFalse);
    expect(await viewModel.confirm(), isFalse);
    expect(c.read(browseLocationProvider), isNull);
  });

  test('moves to where the phone is', () async {
    final c = await open();
    final viewModel = c.read(mapPickerViewModel.notifier);

    expect(await viewModel.goToMyLocation(), isNull);
    expect(state(c).target, const GeoPoint(32.88, 13.19));
    expect(state(c).locating, isFalse);
  });

  test('says why it could not move to the phone', () async {
    finder.next = const LocationOff();
    final c = await open();
    final viewModel = c.read(mapPickerViewModel.notifier);

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
    container.listen(mapPickerViewModel, (_, _) {});
    await pumpEventQueue();
    expect(
      container.read(mapPickerViewModel).error,
      isA<NoConnectionFailure>(),
    );
  });
}
