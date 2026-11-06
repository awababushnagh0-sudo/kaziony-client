import 'package:flutter/widgets.dart';

import 's_pass_page_material.dart';

/// A page to hold up at a counter (a booking's pickup code), on the
/// brand's deep green from edge to edge: a close button and the [title] at
/// the top, the [body] (cards, in the surface's color) scrolling under
/// them, and a quiet link at the foot ([footerLabel], [onFooter]: "Cancel
/// the booking"). Opens over the tabs, without their bar.
abstract interface class SPassPage implements Widget {
  /// [closeTooltip] names the close button, which has no words. [onRefresh]
  /// lets the page be pulled down to reload. The link shows when there's
  /// both a [footerLabel] and an [onFooter].
  const factory SPassPage({
    required String title,
    required String closeTooltip,
    required VoidCallback onClose,
    required Widget body,
    Future<void> Function()? onRefresh,
    String? footerLabel,
    VoidCallback? onFooter,
    Key? key,
  }) = SPassPageMaterial;
}
