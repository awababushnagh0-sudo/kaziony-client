import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_map_renderer.dart';

/// A page that is all [map], edge to edge and under the status bar, with
/// its controls floating on it: a back button at the top when [onBack] is
/// given, [action] at the end above the [panel], and the [panel] (what to
/// do, and the button to do it) on a card at the bottom.
class SMapPage extends StatelessWidget {
  const SMapPage({
    required this.map,
    required this.panel,
    this.onBack,
    this.action,
    super.key,
  });

  /// Usually an [SMapPicker].
  final Widget map;
  final Widget panel;
  final VoidCallback? onBack;

  /// A secondary button, such as going to where the phone is.
  final Widget? action;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).map.page(
    context,
    MapPageSpec(map: map, panel: panel, onBack: onBack, action: action),
  );
}
