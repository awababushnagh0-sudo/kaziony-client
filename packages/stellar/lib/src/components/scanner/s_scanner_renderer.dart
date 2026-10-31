import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

/// Where the phone scans, shown over the camera's top as a button that
/// changes it (a store's branch).
@immutable
class ScannerPlace {
  const ScannerPlace({
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  final String label;

  /// Read out instead of [label], naming what it is ("Your branch: …").
  final String semanticLabel;
  final VoidCallback onTap;
}

/// A button under the square, for when the camera can't read the code.
@immutable
class ScannerAction {
  const ScannerAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.count,
  });

  final String label;
  final VoidCallback onPressed;
  final SIcons? icon;

  /// A number in a badge after the label; none when null or 0.
  final int? count;
}

@immutable
class ScannerViewSpec {
  const ScannerViewSpec({
    required this.camera,
    required this.hint,
    required this.starting,
    required this.torchOn,
    required this.onTorch,
    required this.cover,
    required this.place,
    required this.actions,
  });

  final Widget camera;
  final String hint;
  final bool starting;
  final bool torchOn;
  final VoidCallback? onTorch;
  final Widget? cover;
  final ScannerPlace? place;
  final List<ScannerAction> actions;
}

abstract interface class ScannerRenderer {
  Widget view(BuildContext context, ScannerViewSpec spec);
}
