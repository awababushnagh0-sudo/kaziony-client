import 'package:flutter/widgets.dart';

@immutable
class ScannerViewSpec {
  const ScannerViewSpec({
    required this.camera,
    required this.hint,
    required this.starting,
    required this.torchOn,
    required this.onTorch,
    required this.cover,
  });

  final Widget camera;
  final String hint;
  final bool starting;
  final bool torchOn;
  final VoidCallback? onTorch;
  final Widget? cover;
}

abstract interface class ScannerRenderer {
  Widget view(BuildContext context, ScannerViewSpec spec);
}
