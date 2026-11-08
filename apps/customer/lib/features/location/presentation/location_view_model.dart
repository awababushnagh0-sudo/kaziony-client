import 'package:kernel/kernel.dart';

import '../domain/browse_location.dart';
import '../domain/saved_place.dart';
import 'location_problem.dart';

class LocationState {
  const LocationState({
    this.finding = false,
    this.problem,
    this.outsideOf,
    this.failure,
  });

  final bool finding;
  final LocationProblem? problem;

  /// Set when the phone is outside all of these, where Kaziony works.
  final List<ServiceArea>? outsideOf;

  /// The areas couldn't be loaded to check the location against.
  final AppFailure? failure;
}

class LocationViewModel extends ViewModel<LocationState> {
  @override
  LocationState build() => const LocationState();

  LocationFinder get _finder => ref.read(locationFinderProvider);

  /// Asks where the phone is. The point once Kaziony works there, else
  /// null and why not in the state.
  Future<GeoPoint?> locate() async {
    if (state.finding) return null;
    state = const LocationState(finding: true);
    final fix = await _finder.current();
    if (!ref.mounted) return null;
    if (fix is! LocationFound) {
      state = LocationState(problem: LocationProblem.of(fix));
      return null;
    }
    final areas = await ref.read(serviceAreaRepositoryProvider).areas();
    if (!ref.mounted) return null;
    switch (areas) {
      case Err(:final failure):
        state = LocationState(failure: failure);
        return null;
      case Ok(value: final areas) when !coveredBy(areas, fix.point):
        state = LocationState(outsideOf: areas);
        return null;
      case Ok():
        state = const LocationState();
        return fix.point;
    }
  }

  /// Browses from [point]: where the phone is, or [pinned] on the map.
  Future<void> use(GeoPoint point, {required bool pinned}) => ref
      .read(browseLocationProvider.notifier)
      .set(BrowseLocation(point, pinned: pinned));

  /// Browses from one of the saved places.
  Future<void> useSaved(SavedPlace place) =>
      ref.read(browseLocationProvider.notifier).set(BrowseLocation.of(place));

  /// Browses from where the phone is now. True once it does.
  Future<bool> useMyLocation() async {
    final point = await locate();
    if (point == null || !ref.mounted) return false;
    await use(point, pinned: false);
    return true;
  }

  /// Where the problem can be fixed: the phone's location settings when
  /// it's off, else the app's page in the settings.
  Future<void> openSettings() => state.problem == LocationProblem.off
      ? _finder.openLocationSettings()
      : _finder.openAppSettings();
}

final locationViewModel =
    NotifierProvider.autoDispose<LocationViewModel, LocationState>(
      LocationViewModel.new,
    );
