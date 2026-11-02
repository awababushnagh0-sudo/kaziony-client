import 'package:flutter/widgets.dart';

import 's_map_material.dart';

/// A page that is all map, edge to edge and under the status bar, with
/// its controls floating on it: a back button at the top, an action at the
/// end above the panel, and the panel (what to do, and the button to do
/// it) on a card at the bottom.
abstract interface class SMapPage implements Widget {
  /// [map] is usually an [SMapPicker]. The back button shows only when
  /// [onBack] is given. [action] is a secondary button, such as going to
  /// where the phone is.
  const factory SMapPage({
    required Widget map,
    required Widget panel,
    VoidCallback? onBack,
    Widget? action,
    Key? key,
  }) = SMapPageMaterial;
}
