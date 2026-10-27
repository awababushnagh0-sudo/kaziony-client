import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_scanner_renderer.dart';

/// A camera filling the area, dimmed around a square to aim at, with [hint]
/// under it and a button for the phone's light.
class SScannerView extends StatelessWidget {
  const SScannerView({
    required this.camera,
    required this.hint,
    this.starting = false,
    this.torchOn = false,
    this.onTorch,
    this.cover,
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
  /// itself once allowed.
  final Widget? cover;

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
    ),
  );
}
