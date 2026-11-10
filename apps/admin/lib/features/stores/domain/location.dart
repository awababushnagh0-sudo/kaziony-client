/// A point on the map.
typedef LatLng = ({double latitude, double longitude});

/// Why the backend couldn't use a location: the `code` of the
/// ValidationFailure from `StoreRepository.resolveLocation`, or
/// [outsideLibya] from saving a store's place.
abstract final class LocationCodes {
  static const unreadable = 'UnreadableLocation';
  static const outsideLibya = 'LocationOutsideLibya';
}
