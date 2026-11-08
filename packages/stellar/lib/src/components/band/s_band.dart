import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_band_material.dart';

/// A colored band across a page's top, behind the status bar, with a
/// rounded foot: for a page that starts at the screen's top
/// (`SScaffold(showAppBar: false, underStatusBar: true, padded: false)`).
abstract interface class SBand implements Widget {
  /// - [child]: what's on the band, below the status bar and within the
  ///   page's sides.
  /// - [foot]: sits across the band's rounded foot, half on the page (a
  ///   raised card).
  /// - [onTap]: opens what the band is about; [foot] keeps its own taps.
  const factory SBand({
    required Widget child,
    Widget? foot,
    SColor color,
    VoidCallback? onTap,
    Key? key,
  }) = SBandMaterial;
}
