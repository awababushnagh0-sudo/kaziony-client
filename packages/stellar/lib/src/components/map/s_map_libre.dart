import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show GeoPoint;
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../foundation/s_tokens.dart';
import 's_map_engine.dart';

/// OpenFreeMap's look closest to the maps people know: streets, places
/// and their names, in the local language.
const _styleUrl = 'https://tiles.openfreemap.org/styles/liberty';

/// Points around an area's edge: enough for a smooth circle.
const _edgePoints = 72;
const _earthRadiusKm = 6371.0;

/// The map drawn by MapLibre with OpenFreeMap's tiles.
class LibreMapEngine extends StatefulWidget {
  const LibreMapEngine(this.spec, {super.key});

  final MapEngineSpec spec;

  @override
  State<LibreMapEngine> createState() => _LibreMapEngineState();
}

class _LibreMapEngineState extends State<LibreMapEngine> {
  MapLibreMapController? _controller;
  late LatLng _center = _latLng(widget.spec.target);
  var _moving = false;

  static LatLng _latLng(GeoPoint point) =>
      LatLng(point.latitude, point.longitude);

  @override
  void didUpdateWidget(LibreMapEngine old) {
    super.didUpdateWidget(old);
    if (widget.spec.target != old.spec.target) {
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(_latLng(widget.spec.target), mapFocusZoom),
      );
    }
  }

  /// MapLibre draws no circles in km: each area is a ring of points.
  Future<void> _drawAreas() async {
    final controller = _controller;
    if (controller == null) return;
    final spec = widget.spec;
    final color = _hex(spec.areaColor);
    for (final area in spec.areas) {
      final edge = _circle(area.center, area.radiusKm.toDouble());
      await controller.addFill(
        FillOptions(
          geometry: [edge],
          fillColor: color,
          fillOpacity: mapAreaFillOpacity,
        ),
      );
      await controller.addLine(
        LineOptions(
          geometry: edge,
          lineColor: color,
          lineOpacity: mapAreaLineOpacity,
          lineWidth: mapAreaLineWidth,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    return MapLibreMap(
      styleString: _styleUrl,
      initialCameraPosition: CameraPosition(target: _center, zoom: mapZoom),
      minMaxZoomPreference: const MinMaxZoomPreference(mapMinZoom, mapMaxZoom),
      onMapCreated: (controller) => _controller = controller,
      onStyleLoadedCallback: _drawAreas,
      trackCameraPosition: true,
      onCameraMove: (position) {
        _center = position.target;
        if (!_moving) {
          _moving = true;
          spec.onMoveStarted();
        }
      },
      onCameraIdle: () {
        _moving = false;
        final center = _controller?.cameraPosition?.target ?? _center;
        spec.onMoved(GeoPoint(center.latitude, center.longitude));
      },
      compassEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      // The data's licence asks for its credit to be shown; MapLibre keeps
      // it behind this button, at the top corner the back button leaves
      // free (the bottom has the page's controls).
      attributionButtonPosition: Directionality.of(context) == TextDirection.rtl
          ? AttributionButtonPosition.topLeft
          : AttributionButtonPosition.topRight,
      // iOS keeps it clear of the status bar itself; Android doesn't.
      attributionButtonMargins: math.Point(
        Space.lg,
        Space.lg +
            (defaultTargetPlatform == TargetPlatform.android
                ? MediaQuery.paddingOf(context).top
                : 0),
      ),
    );
  }
}

/// [color] as MapLibre reads it, `#RRGGBB`.
String _hex(Color color) =>
    '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// The edge of a circle of [radiusKm] around [center], closed.
List<LatLng> _circle(GeoPoint center, double radiusKm) {
  double rad(double degrees) => degrees * math.pi / 180;
  double deg(double radians) => radians * 180 / math.pi;
  final lat = rad(center.latitude);
  final lng = rad(center.longitude);
  final distance = radiusKm / _earthRadiusKm;
  return [
    for (var i = 0; i <= _edgePoints; i++)
      () {
        final bearing = 2 * math.pi * i / _edgePoints;
        final pointLat = math.asin(
          math.sin(lat) * math.cos(distance) +
              math.cos(lat) * math.sin(distance) * math.cos(bearing),
        );
        final pointLng =
            lng +
            math.atan2(
              math.sin(bearing) * math.sin(distance) * math.cos(lat),
              math.cos(distance) - math.sin(lat) * math.sin(pointLat),
            );
        return LatLng(deg(pointLat), deg(pointLng));
      }(),
  ];
}
