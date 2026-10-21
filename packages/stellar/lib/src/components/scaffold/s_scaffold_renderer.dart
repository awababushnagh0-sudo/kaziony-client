import 'package:flutter/widgets.dart';

@immutable
class ScaffoldSpec {
  const ScaffoldSpec({
    required this.body,
    this.title,
    this.actions = const [],
    this.padded = true,
    this.scrollable = false,
    this.bottom,
    this.showAppBar = true,
    this.maxWidth,
    this.centered = false,
  });

  final Widget body;
  final String? title;
  final List<Widget> actions;

  /// Standard page padding around [body].
  final bool padded;

  /// Wrap [body] in a scroll view (forms, so the keyboard never hides fields).
  final bool scrollable;

  /// Pinned to the bottom (e.g. a primary action).
  final Widget? bottom;
  final bool showAppBar;

  /// Keeps the content narrow on wide screens (forms on the web).
  final double? maxWidth;

  /// Centers the content vertically too (login pages).
  final bool centered;
}

abstract interface class ScaffoldRenderer {
  Widget render(BuildContext context, ScaffoldSpec spec);
}
