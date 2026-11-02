import 'package:kernel/kernel.dart';

/// Why the phone's location couldn't be used; the page says what to do.
enum LocationProblem {
  /// The customer said no; asking again shows the prompt again.
  denied,

  /// The phone won't ask again: only its settings can allow it.
  deniedForever,

  /// Location is off for the whole phone.
  off,

  /// No fix in time, or anything else.
  failed;

  /// Null when the phone's location was found.
  static LocationProblem? of(LocationFix fix) => switch (fix) {
    LocationFound() => null,
    LocationDenied(forever: false) => denied,
    LocationDenied(forever: true) => deniedForever,
    LocationOff() => off,
    LocationFailed() => failed,
  };

  /// Only the phone's settings can fix it.
  bool get needsSettings => this == deniedForever || this == off;
}
