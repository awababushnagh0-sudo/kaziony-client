import 'package:flutter/widgets.dart';

import 's_sliver_view_material.dart';

/// A page that scrolls down through sections of different kinds (rows
/// that scroll sideways, banners, a list), each a sliver, so only what's
/// on screen is built. Put it in an `SScaffold` that doesn't scroll.
abstract interface class SSliverView implements Widget {
  /// [onRefresh] lets the page be pulled down to reload, even when it's
  /// short; null while there's nothing to reload.
  const factory SSliverView({
    required List<Widget> slivers,
    Future<void> Function()? onRefresh,
    Key? key,
  }) = SSliverViewMaterial;
}
