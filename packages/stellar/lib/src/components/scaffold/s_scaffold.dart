import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_scaffold_renderer.dart';

/// A page: app bar, body and an optional action pinned to the bottom.
/// Record pages put their list in [parent] and their status in [status].
class SScaffold extends StatelessWidget {
  const SScaffold({
    required this.body,
    this.title,
    this.parent,
    this.status,
    this.actions = const [],
    this.padded = true,
    this.scrollable = false,
    this.onRefresh,
    this.bottom,
    this.floating,
    this.showAppBar = true,
    this.maxWidth,
    this.centered = false,
    this.underStatusBar = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final ScaffoldParent? parent;
  final Widget? status;
  final List<Widget> actions;
  final bool padded;
  final bool scrollable;
  final Future<void> Function()? onRefresh;
  final Widget? bottom;

  /// Floats over the end of the page, above the content: the page's main
  /// action on a long list ("Post an offer").
  final Widget? floating;
  final bool showAppBar;
  final double? maxWidth;
  final bool centered;
  final bool underStatusBar;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).scaffold.render(
    context,
    ScaffoldSpec(
      body: body,
      title: title,
      parent: parent,
      status: status,
      actions: actions,
      padded: padded,
      scrollable: scrollable,
      onRefresh: onRefresh,
      bottom: bottom,
      floating: floating,
      showAppBar: showAppBar,
      maxWidth: maxWidth,
      centered: centered,
      underStatusBar: underStatusBar,
    ),
  );
}
