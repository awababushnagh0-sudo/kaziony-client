import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// A point on the map.
@immutable
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  static const _earthRadiusKm = 6371.0;

  /// Straight-line distance to [other], in km (the haversine formula, as
  /// the backend uses).
  double distanceKmTo(GeoPoint other) {
    double rad(double degrees) => degrees * math.pi / 180;
    final dLat = rad(other.latitude - latitude);
    final dLng = rad(other.longitude - longitude);
    final h =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(latitude)) *
            math.cos(rad(other.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * _earthRadiusKm * math.asin(math.sqrt(h));
  }

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// What came of asking where the phone is.
sealed class LocationFix {
  const LocationFix();
}

final class LocationFound extends LocationFix {
  const LocationFound(this.point);

  final GeoPoint point;
}

/// The user said no. When [forever], the phone won't ask again: only
/// [LocationFinder.openAppSettings] can allow it.
final class LocationDenied extends LocationFix {
  const LocationDenied({required this.forever});

  final bool forever;
}

/// Location is off for the whole phone:
/// [LocationFinder.openLocationSettings] turns it on.
final class LocationOff extends LocationFix {
  const LocationOff();
}

/// No fix in time, or anything else.
final class LocationFailed extends LocationFix {
  const LocationFailed(this.error);

  final Object error;
}

/// Finds roughly where the phone is (a city block is enough to show
/// what's near). Tests use a fake.
abstract interface class LocationFinder {
  /// Asks for the permission the first time, then where the phone is.
  Future<LocationFix> current();

  /// The app's page in the phone's settings, where location can be
  /// allowed again.
  Future<void> openAppSettings();

  /// The phone's location settings, where location can be turned on.
  Future<void> openLocationSettings();
}

class DeviceLocationFinder implements LocationFinder {
  const DeviceLocationFinder();

  /// Indoors a fix can take a while; after this the last known one does.
  static const _timeLimit = Duration(seconds: 15);

  @override
  Future<LocationFix> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationOff();
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.denied:
          return const LocationDenied(forever: false);
        case LocationPermission.deniedForever:
          return const LocationDenied(forever: true);
        case LocationPermission.whileInUse ||
            LocationPermission.always ||
            LocationPermission.unableToDetermine:
          break;
      }
      final position = await _position();
      return switch (position) {
        null => LocationFailed(StateError('No location fix')),
        _ => LocationFound(GeoPoint(position.latitude, position.longitude)),
      };
    } on Object catch (error) {
      return LocationFailed(error);
    }
  }

  Future<Position?> _position() async {
    try {
      return await Geolocator.getCurrentPosition(
        // Nearby offers need a block, not a doorstep: faster, and easier
        // on the battery and on privacy.
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: _timeLimit,
        ),
      );
    } on Object {
      return Geolocator.getLastKnownPosition();
    }
  }

  @override
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}

final locationFinderProvider = Provider<LocationFinder>(
  (ref) => const DeviceLocationFinder(),
);
