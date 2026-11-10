import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_scanner_material.dart';

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

/// A camera filling the page, up to the status bar, dimmed around a square
/// to aim at with a hint under it. Over its top: the phone's light; under
/// the square: the actions.
abstract interface class SScannerView implements Widget {
  /// [camera] is the camera's picture (kernel's `QrScanner.view`), and
  /// [hint] is shown under the square. [starting] shows a spinner in the
  /// square while the camera opens.
  ///
  /// [onTorch] switches the light, which is on when [torchOn]; null hides
  /// the button (no light on this phone).
  ///
  /// [cover] is shown on the page's background instead of the camera, e.g.
  /// when the camera is off. The camera stays underneath, so it opens again
  /// by itself once allowed. The [actions] stay.
  ///
  /// Of the [actions], the first is the main one, drawn solid; the rest are
  /// quieter.
  const factory SScannerView({
    required Widget camera,
    required String hint,
    bool starting,
    bool torchOn,
    VoidCallback? onTorch,
    Widget? cover,
    List<ScannerAction> actions,
    Key? key,
  }) = SScannerViewMaterial;
}
