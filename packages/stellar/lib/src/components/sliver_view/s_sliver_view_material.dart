import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import 's_sliver_view.dart';

/// [SSliverView], drawn as a [CustomScrollView] in a [RefreshIndicator].
class SSliverViewMaterial extends StatelessWidget implements SSliverView {
  const SSliverViewMaterial({required this.slivers, this.onRefresh, super.key});

  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final onRefresh = this.onRefresh;
    final view = CustomScrollView(
      // Short pages can still be pulled down to reload.
      physics: onRefresh == null ? null : const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );
    if (onRefresh == null) return view;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: context.colors.primary,
      backgroundColor: context.colors.surface,
      child: view,
    );
  }
}
