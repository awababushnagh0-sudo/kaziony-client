import 'package:kernel/kernel.dart';

import '../domain/browse_location.dart';
import 'location_problem.dart';

class MapPickerState {
  const MapPickerState({
    required this.areas,
    required this.target,
    required this.picked,
    this.locating = false,
  });

  /// Where Kaziony works, drawn on the map.
  final List<ServiceArea> areas;

  /// Where the map is told to look.
  final GeoPoint target;

  /// Where the pin points.
  final GeoPoint picked;

  final bool locating;

  bool get inside => coveredBy(areas, picked);

  MapPickerState copyWith({
    GeoPoint? target,
    GeoPoint? picked,
    bool? locating,
  }) => MapPickerState(
    areas: areas,
    target: target ?? this.target,
    picked: picked ?? this.picked,
    locating: locating ?? this.locating,
  );
}

/// Setting the place to browse from by moving a map under a pin.
class MapPickerViewModel extends AsyncViewModel<MapPickerState> {
  @override
  Future<MapPickerState> build() async {
    final areas = switch (await ref
        .watch(serviceAreaRepositoryProvider)
        .areas()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
    // Where they browse from now, if it still counts; else the middle of
    // the first city we work in.
    final saved = ref.read(browseLocationProvider)?.point;
    final start = saved != null && coveredBy(areas, saved)
        ? saved
        : areas.firstOrNull?.center ?? _tripoli;
    return MapPickerState(areas: areas, target: start, picked: start);
  }

  /// Only reached when the backend has no areas on.
  static const _tripoli = GeoPoint(32.8955, 13.1801);

  void moved(GeoPoint point) {
    if (state.value case final current?) {
      state = AsyncData(current.copyWith(picked: point));
    }
  }

  /// Moves the map to where the phone is. Null once there, else why not.
  Future<LocationProblem?> goToMyLocation() async {
    final current = state.value;
    if (current == null || current.locating) return null;
    state = AsyncData(current.copyWith(locating: true));
    final fix = await ref.read(locationFinderProvider).current();
    if (!ref.mounted) return null;
    final now = state.value!;
    state = AsyncData(
      fix is LocationFound
          ? now.copyWith(target: fix.point, picked: fix.point, locating: false)
          : now.copyWith(locating: false),
    );
    return LocationProblem.of(fix);
  }

  /// Keeps the pinned place, if Kaziony works there. True once kept.
  Future<bool> confirm() async {
    final current = state.value;
    if (current == null || !current.inside) return false;
    await ref
        .read(browseLocationProvider.notifier)
        .set(BrowseLocation(current.picked, pinned: true));
    return true;
  }
}

final mapPickerViewModel =
    AsyncNotifierProvider.autoDispose<MapPickerViewModel, MapPickerState>(
      MapPickerViewModel.new,
    );
