/// A point on the map.
typedef LatLng = ({double latitude, double longitude});

/// Why the backend couldn't use a pasted location: the `code` of the
/// ValidationFailure from `StoreRepository.resolveLocation`.
abstract final class LocationCodes {
  static const unreadable = 'UnreadableLocation';
  static const outsideLibya = 'LocationOutsideLibya';
}
