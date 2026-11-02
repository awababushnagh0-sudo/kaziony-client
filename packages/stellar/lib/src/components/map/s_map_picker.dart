import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show GeoPoint;

import 's_map_material.dart';

/// A round area drawn on the map: where something is allowed.
@immutable
class SMapArea {
  const SMapArea({required this.center, required this.radiusKm});

  final GeoPoint center;
  final num radiusKm;
}

/// A map that moves under a pin fixed in its middle, to set a place by
/// dragging. [areas] are drawn on it, such as where the app works.
abstract interface class SMapPicker implements Widget {
  /// [target] is where the map looks first. Changing it moves the map
  /// there (to where the phone is, say). [onMoved] gets where the pin
  /// points, each time the map stops moving.
  const factory SMapPicker({
    required GeoPoint target,
    required ValueChanged<GeoPoint> onMoved,
    List<SMapArea> areas,
    Key? key,
  }) = SMapPickerMaterial;
}
