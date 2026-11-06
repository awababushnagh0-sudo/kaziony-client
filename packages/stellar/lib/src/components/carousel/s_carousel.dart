import 'package:flutter/widgets.dart';

import 's_carousel_material.dart';

/// Cards in a row that scrolls sideways, each most of the screen's width so
/// the next one peeks in and shows there's more (a home page's row of
/// offers). It moves only when swiped.
abstract interface class SCarousel implements Widget {
  /// [children] are the cards, all made the same width.
  const factory SCarousel({required List<Widget> children, Key? key}) =
      SCarouselMaterial;

  /// Small things at their own width, closer together, as many as fit
  /// (a row of stores' logos).
  const factory SCarousel.small({required List<Widget> children, Key? key}) =
      SCarouselMaterial.small;
}
