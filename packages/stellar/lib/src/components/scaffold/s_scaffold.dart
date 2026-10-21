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
    this.bottom,
    this.showAppBar = true,
    this.maxWidth,
    this.centered = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final ScaffoldParent? parent;
  final Widget? status;
  final List<Widget> actions;
  final bool padded;
  final bool scrollable;
  final Widget? bottom;
  final bool showAppBar;
  final double? maxWidth;
  final bool centered;

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
      bottom: bottom,
      showAppBar: showAppBar,
      maxWidth: maxWidth,
      centered: centered,
    ),
  );
}
