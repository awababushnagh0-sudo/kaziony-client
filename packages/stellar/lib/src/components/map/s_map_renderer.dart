import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show GeoPoint;

/// A round area drawn on the map: where something is allowed.
@immutable
class SMapArea {
  const SMapArea({required this.center, required this.radiusKm});

  final GeoPoint center;
  final num radiusKm;
}

@immutable
class MapPickerSpec {
  const MapPickerSpec({
    required this.target,
    required this.onMoved,
    required this.areas,
  });

  final GeoPoint target;
  final ValueChanged<GeoPoint> onMoved;
  final List<SMapArea> areas;
}

@immutable
class MapPageSpec {
  const MapPageSpec({
    required this.map,
    required this.panel,
    this.onBack,
    this.action,
  });

  final Widget map;
  final Widget panel;
  final VoidCallback? onBack;
  final Widget? action;
}

/// A map to choose a place on.
abstract interface class MapRenderer {
  /// The map moves under a pin fixed in the middle.
  Widget picker(BuildContext context, MapPickerSpec spec);

  /// A whole page of map, with its controls floating on it.
  Widget page(BuildContext context, MapPageSpec spec);
}
