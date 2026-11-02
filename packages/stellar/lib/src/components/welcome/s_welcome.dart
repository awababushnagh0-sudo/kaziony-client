import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_welcome_renderer.dart';

/// A page a phone app opens on the first time (welcome, location,
/// sign-in): the brand's cream with its green and orange shapes, [child]
/// in the middle, [actions] full width at the bottom and [top] along the
/// top.
class SWelcomePage extends StatelessWidget {
  const SWelcomePage({
    required Widget this.child,
    this.actions = const [],
    this.top = const [],
    super.key,
  }) : pages = const [],
       controller = null,
       onPageChanged = null;

  /// [pages] to swipe through, edge to edge, so they don't look cut off at
  /// the sides; show which with [SPageDots] in [actions].
  const SWelcomePage.swipe({
    required this.pages,
    this.controller,
    this.onPageChanged,
    this.actions = const [],
    this.top = const [],
    super.key,
  }) : child = null;

  final Widget? child;
  final List<Widget> pages;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final List<Widget> actions;
  final List<Widget> top;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).welcome.page(
    context,
    WelcomePageSpec(
      child: child,
      pages: pages,
      controller: controller,
      onPageChanged: onPageChanged,
      actions: actions,
      top: top,
    ),
  );
}

/// Dots under pages that swipe: which of [count] is showing.
class SPageDots extends StatelessWidget {
  const SPageDots({required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).welcome
          .dots(context, PageDotsSpec(count: count, index: index));
}

/// The app's [name], big in the brand's green, over its [tagline] on an
/// orange pill.
class SBrandTitle extends StatelessWidget {
  const SBrandTitle({required this.name, required this.tagline, super.key});

  final String name;
  final String tagline;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).welcome
          .brand(context, BrandSpec(name: name, tagline: tagline));
}
