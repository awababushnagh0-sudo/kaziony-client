import 'package:kernel/kernel.dart';
import 'package:offers_api/customer.dart';

import '../domain/saved_place.dart';

class ApiPlacesRepository implements PlacesRepository {
  ApiPlacesRepository(this._api);

  final Api _api;
  late final _places = _api.client(PlacesClient.new);

  @override
  Future<Result<List<SavedPlace>>> list() async {
    final result = await _api.guard(() => _places.list());
    return result.map((list) => [for (final place in list) _toPlace(place)]);
  }

  @override
  Future<Result<SavedPlace>> add(PlaceDetails details, GeoPoint point) async {
    final result = await _api.guard(
      () => _places.create(
        body: CreateSavedPlaceDto(
          name: details.name,
          note: details.note,
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      ),
    );
    return result.map(_toPlace);
  }

  @override
  Future<Result<SavedPlace>> update(SavedPlace place) async {
    final result = await _api.guard(
      () => _places.update(
        placeId: place.id,
        body: UpdateSavedPlaceDto(
          name: place.name,
          // An empty note clears it; leaving it out would keep the old one.
          note: place.note ?? '',
          latitude: place.point.latitude,
          longitude: place.point.longitude,
        ),
      ),
    );
    return result.map(_toPlace);
  }

  @override
  Future<Result<void>> remove(String id) =>
      _api.guard(() => _places.remove(placeId: id));
}

SavedPlace _toPlace(SavedPlaceDto place) => SavedPlace(
  id: place.id,
  name: place.name,
  note: place.note,
  point: GeoPoint(place.latitude.toDouble(), place.longitude.toDouble()),
);
