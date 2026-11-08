import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/domain/saved_place.dart';
import 'package:customer/features/location/presentation/location_problem.dart';
import 'package:customer/features/location/presentation/location_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeLocationFinder finder;
  late FakeServiceAreaRepository areas;
  late ProviderContainer container;
  late LocationViewModel viewModel;

  setUp(() {
    finder = FakeLocationFinder();
    areas = FakeServiceAreaRepository();
    container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer, locationFinder: finder),
        serviceAreaRepositoryProvider.overrideWithValue(areas),
      ],
    );
    addTearDown(container.dispose);
    container.listen(locationViewModel, (_, _) {});
    viewModel = container.read(locationViewModel.notifier);
  });

  LocationState state() => container.read(locationViewModel);
  BrowseLocation? place() => container.read(browseLocationProvider);

  test('keeps where the phone is, inside our areas', () async {
    expect(await viewModel.useMyLocation(), isTrue);
    expect(place()?.point, const GeoPoint(32.88, 13.19));
    expect(place()?.pinned, isFalse);
    expect(state().finding, isFalse);
  });

  test('finds where the phone is without keeping it', () async {
    expect(await viewModel.locate(), const GeoPoint(32.88, 13.19));
    expect(place(), isNull);
  });

  test('shows offers from a saved place', () async {
    const home = SavedPlace(id: '1', name: 'Home', point: souqAlJuma);
    await viewModel.useSaved(home);

    expect(place()?.point, souqAlJuma);
    expect(place()?.placeId, '1');
  });

  test('refuses where Kaziony does not work yet', () async {
    finder.next = const LocationFound(zawiya);

    expect(await viewModel.useMyLocation(), isFalse);
    expect(state().outsideOf, [tripoli]);
    expect(place(), isNull);
  });

  test('says when the areas could not be checked', () async {
    areas.result = const Err(NoConnectionFailure());

    expect(await viewModel.useMyLocation(), isFalse);
    expect(state().failure, isA<NoConnectionFailure>());
    expect(place(), isNull);
  });

  test('says why the location could not be used', () async {
    final cases = {
      const LocationDenied(forever: false): LocationProblem.denied,
      const LocationDenied(forever: true): LocationProblem.deniedForever,
      const LocationOff(): LocationProblem.off,
      LocationFailed(StateError('timeout')): LocationProblem.failed,
    };
    for (final MapEntry(key: fix, value: problem) in cases.entries) {
      finder.next = fix;
      expect(await viewModel.useMyLocation(), isFalse);
      expect(state().problem, problem);
    }
    expect(areas.loads, 0);
    expect(place(), isNull);
  });

  test('settings open where the problem can be fixed', () async {
    finder.next = const LocationOff();
    await viewModel.useMyLocation();
    await viewModel.openSettings();
    expect(finder.locationSettingsOpened, 1);

    finder.next = const LocationDenied(forever: true);
    await viewModel.useMyLocation();
    await viewModel.openSettings();
    expect(finder.appSettingsOpened, 1);
  });
}
