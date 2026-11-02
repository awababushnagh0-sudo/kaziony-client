import 'package:flutter/widgets.dart';

import 's_welcome_material.dart';

/// A page a phone app opens on the first time (welcome, location,
/// sign-in): the brand's cream with its green and orange shapes, [child]
/// in the middle, [actions] full width at the bottom and [top] along the
/// top.
abstract interface class SWelcomePage implements Widget {
  /// [child] is what the page says, centered between the top and
  /// [actions]. [actions] are the ways on, the main one first; [top] holds
  /// small buttons (back, language).
  const factory SWelcomePage({
    required Widget child,
    List<Widget> actions,
    List<Widget> top,
    Key? key,
  }) = SWelcomePageMaterial;

  /// [pages] to swipe through, edge to edge, so they don't look cut off at
  /// the sides, each centered and padded like a [child]; show which with
  /// [SPageDots] in [actions].
  const factory SWelcomePage.swipe({
    required List<Widget> pages,
    PageController? controller,
    ValueChanged<int>? onPageChanged,
    List<Widget> actions,
    List<Widget> top,
    Key? key,
  }) = SWelcomePageMaterial.swipe;
}

/// Dots under pages that swipe: which of [count] is showing.
abstract interface class SPageDots implements Widget {
  /// [index] is the page showing, from 0.
  const factory SPageDots({required int count, required int index, Key? key}) =
      SPageDotsMaterial;
}

/// The app's [name], big in the brand's green, over its [tagline] on an
/// orange pill.
abstract interface class SBrandTitle implements Widget {
  const factory SBrandTitle({
    required String name,
    required String tagline,
    Key? key,
  }) = SBrandTitleMaterial;
}
