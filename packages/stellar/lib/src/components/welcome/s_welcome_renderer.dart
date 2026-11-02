import 'package:flutter/widgets.dart';

@immutable
class WelcomePageSpec {
  const WelcomePageSpec({
    this.child,
    this.pages = const [],
    this.controller,
    this.onPageChanged,
    this.actions = const [],
    this.top = const [],
  });

  /// What the page says, centered between the top and [actions].
  final Widget? child;

  /// Pages that swipe edge to edge when there's no [child], each centered
  /// and padded like it.
  final List<Widget> pages;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;

  /// The ways on, full width at the bottom, the main one first.
  final List<Widget> actions;

  /// Small buttons along the top (back, language).
  final List<Widget> top;
}

@immutable
class PageDotsSpec {
  const PageDotsSpec({required this.count, required this.index});

  final int count;

  /// The page showing, from 0.
  final int index;
}

@immutable
class BrandSpec {
  const BrandSpec({required this.name, required this.tagline});

  final String name;
  final String tagline;
}

/// The pages a phone app opens on the first time (welcome, location,
/// sign-in): the brand's cream with its green and orange shapes.
abstract interface class WelcomeRenderer {
  Widget page(BuildContext context, WelcomePageSpec spec);

  /// Which of several pages is showing.
  Widget dots(BuildContext context, PageDotsSpec spec);

  /// The app's name, big in the brand's green, over its tagline on an
  /// orange pill.
  Widget brand(BuildContext context, BrandSpec spec);
}
