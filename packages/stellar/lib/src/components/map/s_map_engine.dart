import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show GeoPoint;

import 's_map_picker.dart';

/// What the picker asks of the map underneath, whoever draws it.
@immutable
class MapEngineSpec {
  const MapEngineSpec({
    required this.target,
    required this.areas,
    required this.areaColor,
    required this.onMoveStarted,
    required this.onMoved,
  });

  /// Where to look; a new one moves the map there.
  final GeoPoint target;
  final List<SMapArea> areas;
  final Color areaColor;
  final VoidCallback onMoveStarted;

  /// Where the middle of the map is once it stops.
  final ValueChanged<GeoPoint> onMoved;
}

/// Close enough to tell one street from the next.
const mapZoom = 15.0;

/// Closer, when the map is sent to a place (where the phone is).
const mapFocusZoom = 17.0;

/// Far enough out to see a whole city and the circle around it.
const mapMinZoom = 9.0;
const mapMaxZoom = 19.0;

/// How strongly the areas are drawn over the map.
const mapAreaFillOpacity = 0.06;
const mapAreaLineOpacity = 0.5;
const mapAreaLineWidth = 2.0;
