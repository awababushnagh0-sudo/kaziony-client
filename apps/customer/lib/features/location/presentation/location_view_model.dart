import 'package:kernel/kernel.dart';

import '../domain/browse_location.dart';
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

  /// Asks where the phone is and keeps it if Kaziony works there. True
  /// once kept.
  Future<bool> useMyLocation() async {
    if (state.finding) return false;
    state = const LocationState(finding: true);
    final fix = await _finder.current();
    if (!ref.mounted) return false;
    if (fix is! LocationFound) {
      state = LocationState(problem: LocationProblem.of(fix));
      return false;
    }
    final areas = await ref.read(serviceAreaRepositoryProvider).areas();
    if (!ref.mounted) return false;
    switch (areas) {
      case Err(:final failure):
        state = LocationState(failure: failure);
        return false;
      case Ok(value: final areas) when !coveredBy(areas, fix.point):
        state = LocationState(outsideOf: areas);
        return false;
      case Ok():
        await ref
            .read(browseLocationProvider.notifier)
            .set(BrowseLocation(fix.point, pinned: false));
        if (ref.mounted) state = const LocationState();
        return true;
    }
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
