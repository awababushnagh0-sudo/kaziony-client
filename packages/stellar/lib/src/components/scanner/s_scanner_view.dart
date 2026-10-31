import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_scanner_renderer.dart';

/// A camera filling the page, up to the status bar, dimmed around a square
/// to aim at with [hint] under it. Over its top: the [place] and the
/// phone's light; under the square: the [actions].
class SScannerView extends StatelessWidget {
  const SScannerView({
    required this.camera,
    required this.hint,
    this.starting = false,
    this.torchOn = false,
    this.onTorch,
    this.cover,
    this.place,
    this.actions = const [],
    super.key,
  });

  /// The camera's picture (kernel's `QrScanner.view`).
  final Widget camera;
  final String hint;

  /// Shows a spinner in the square while the camera opens.
  final bool starting;
  final bool torchOn;

  /// Switches the light; null hides the button (no light on this phone).
  final VoidCallback? onTorch;

  /// Shown on the page's background instead of the camera, e.g. when the
  /// camera is off. The camera stays underneath, so it opens again by
  /// itself once allowed. The [place] and [actions] stay.
  final Widget? cover;

  /// Where the phone scans; null hides the button (nothing to change).
  final ScannerPlace? place;

  /// The first is the main one, drawn solid; the rest are quieter.
  final List<ScannerAction> actions;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).scanner.view(
    context,
    ScannerViewSpec(
      camera: camera,
      hint: hint,
      starting: starting,
      torchOn: torchOn,
      onTorch: onTorch,
      cover: cover,
      place: place,
      actions: actions,
    ),
  );
}
