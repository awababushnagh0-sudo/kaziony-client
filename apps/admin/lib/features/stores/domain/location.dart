/// A point on the map.
typedef LatLng = ({double latitude, double longitude});

/// Reads a location the way our team has it at hand: a Google Maps link
/// (shared from the app or copied from the browser) or plain coordinates
/// ("32.8872, 13.1913"). Null when there is none.
///
/// Short links (maps.app.goo.gl/...) hide the coordinates behind a
/// redirect, so they can't be read here; the team pastes the full link or
/// the coordinates instead.
LatLng? parseLocation(String input) {
  final text = _decode(input.trim());
  for (final pattern in _patterns) {
    final match = pattern.firstMatch(text);
    if (match == null) continue;
    final latitude = double.tryParse(match.group(1)!);
    final longitude = double.tryParse(match.group(2)!);
    if (latitude == null || longitude == null) continue;
    if (latitude.abs() > 90 || longitude.abs() > 180) continue;
    return (latitude: latitude, longitude: longitude);
  }
  return null;
}

/// Links come percent-encoded (`%2C` for a comma); anything else, such as
/// Arabic text, is not a valid encoding and is read as it is.
String _decode(String text) {
  try {
    return Uri.decodeFull(text);
  } on ArgumentError {
    return text;
  }
}

/// Roughly Libya's borders, to catch swapped or mistyped coordinates.
bool isInLibya(LatLng point) =>
    point.latitude >= 19.5 &&
    point.latitude <= 33.5 &&
    point.longitude >= 9.3 &&
    point.longitude <= 25.2;

const _number = r'(-?\d{1,3}(?:\.\d+)?)';

final _patterns = [
  // The pin itself: ...!3d32.88!4d13.19 (place links).
  RegExp('!3d$_number!4d$_number'),
  // ?q=32.88,13.19 or ?query=... or &ll=...
  RegExp('[?&](?:q|query|ll|destination)=$_number,\\s*$_number'),
  // The map's center: /@32.88,13.19,17z
  RegExp('@$_number,$_number'),
  // Plain coordinates, the whole input.
  RegExp('^$_number\\s*[,،]\\s*$_number\$'),
];
