import 'package:kernel/kernel.dart';

import '../domain/browse_location.dart';
import '../domain/saved_place.dart';

/// The customer's saved places, from their account; none for a guest.
/// Each change goes to the backend first and shows here only once it's
/// kept there; a failure comes back for the page to say, and nothing
/// changes.
class SavedPlacesViewModel extends AsyncViewModel<List<SavedPlace>> {
  /// Enough for home, work and the family; the list stays short. The
  /// backend holds to it too.
  static const max = 10;

  PlacesRepository get _places => ref.read(placesRepositoryProvider);

  @override
  Future<List<SavedPlace>> build() async {
    if (ref.watch(sessionProvider) is! SignedIn) return const [];
    return switch (await ref.watch(placesRepositoryProvider).list()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Saves a new place and browses from it. Null once saved.
  Future<AppFailure?> add(PlaceDetails details, GeoPoint point) async {
    switch (await _places.add(details, point)) {
      case Err(:final failure):
        return failure;
      case Ok(value: final place):
        _keep([...?state.value, place]);
        await _browseFrom(place);
        return null;
    }
  }

  /// Keeps [place]'s new name, note or point. If offers are shown from it,
  /// they follow it. Null once saved.
  Future<AppFailure?> change(SavedPlace place) async {
    switch (await _places.update(place)) {
      case Err(:final failure):
        return failure;
      case Ok(value: final changed):
        _keep([
          for (final kept in state.value ?? const <SavedPlace>[])
            kept.id == changed.id ? changed : kept,
        ]);
        if (ref.read(browseLocationProvider)?.placeId == changed.id) {
          await _browseFrom(changed);
        }
        return null;
    }
  }

  /// Deletes [place], never the one offers are shown from (the page doesn't
  /// offer it). Null once deleted.
  Future<AppFailure?> remove(SavedPlace place) async {
    switch (await _places.remove(place.id)) {
      case Err(:final failure):
        return failure;
      case Ok():
        _keep([
          for (final kept in state.value ?? const <SavedPlace>[])
            if (kept.id != place.id) kept,
        ]);
        return null;
    }
  }

  void _keep(List<SavedPlace> places) {
    if (ref.mounted) state = AsyncData(places);
  }

  Future<void> _browseFrom(SavedPlace place) =>
      ref.read(browseLocationProvider.notifier).set(BrowseLocation.of(place));
}

final savedPlacesViewModel =
    AsyncNotifierProvider.autoDispose<SavedPlacesViewModel, List<SavedPlace>>(
      SavedPlacesViewModel.new,
    );
