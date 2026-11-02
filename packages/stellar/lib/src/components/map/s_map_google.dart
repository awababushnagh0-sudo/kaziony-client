import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kernel/kernel.dart' show GeoPoint;

import 's_map_engine.dart';

/// The map drawn by Google Maps.
class GoogleMapEngine extends StatefulWidget {
  const GoogleMapEngine(this.spec, {super.key});

  final MapEngineSpec spec;

  @override
  State<GoogleMapEngine> createState() => _GoogleMapEngineState();
}

class _GoogleMapEngineState extends State<GoogleMapEngine> {
  GoogleMapController? _controller;
  late LatLng _center = _latLng(widget.spec.target);

  static LatLng _latLng(GeoPoint point) =>
      LatLng(point.latitude, point.longitude);

  @override
  void didUpdateWidget(GoogleMapEngine old) {
    super.didUpdateWidget(old);
    if (widget.spec.target != old.spec.target) {
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(_latLng(widget.spec.target), mapFocusZoom),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _center, zoom: mapZoom),
      minMaxZoomPreference: const MinMaxZoomPreference(mapMinZoom, mapMaxZoom),
      onMapCreated: (controller) => _controller = controller,
      onCameraMoveStarted: spec.onMoveStarted,
      onCameraMove: (position) => _center = position.target,
      onCameraIdle: () =>
          spec.onMoved(GeoPoint(_center.latitude, _center.longitude)),
      circles: {
        for (final (index, area) in spec.areas.indexed)
          Circle(
            circleId: CircleId('$index'),
            center: _latLng(area.center),
            radius: area.radiusKm * 1000,
            fillColor: spec.areaColor.withValues(alpha: mapAreaFillOpacity),
            strokeColor: spec.areaColor.withValues(alpha: mapAreaLineOpacity),
            strokeWidth: mapAreaLineWidth.round(),
          ),
      },
      // The page has its own button for where the phone is.
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
    );
  }
}
