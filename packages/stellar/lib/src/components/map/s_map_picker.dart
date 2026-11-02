import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show GeoPoint;

import '../../foundation/s_kit.dart';
import 's_map_renderer.dart';

/// A map that moves under a pin fixed in its middle, to set a place by
/// dragging. [areas] are drawn on it, such as where the app works.
class SMapPicker extends StatelessWidget {
  const SMapPicker({
    required this.target,
    required this.onMoved,
    this.areas = const [],
    super.key,
  });

  /// Where the map looks first. Changing it moves the map there (to where
  /// the phone is, say).
  final GeoPoint target;

  /// Where the pin points, each time the map stops moving.
  final ValueChanged<GeoPoint> onMoved;

  final List<SMapArea> areas;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).map.picker(
    context,
    MapPickerSpec(target: target, onMoved: onMoved, areas: areas),
  );
}
