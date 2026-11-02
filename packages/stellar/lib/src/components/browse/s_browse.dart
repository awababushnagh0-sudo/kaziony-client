import 'package:flutter/widgets.dart';

import '../illustration/s_illustration.dart';
import 's_browse_material.dart';

/// One kind of store to show offers from, with its picture.
@immutable
class CategoryChoice {
  const CategoryChoice({required this.label, this.illustration, this.imageUrl});

  final String label;

  /// One of the brand's pictures; else [imageUrl]; else a plain mark.
  final Illustration? illustration;
  final String? imageUrl;
}

/// Where offers are shown from, at the top of a home page: a quiet
/// `caption` over the `place` in bold, with an arrow that says it changes
/// (`onTap`), and `trailing` at the other end.
abstract interface class SPlaceHeader implements Widget {
  /// [caption] goes over the place ("Offers near"); [trailing] at the other
  /// end (the brand's logo).
  const factory SPlaceHeader({
    required String caption,
    required String place,
    required VoidCallback onTap,
    Widget? trailing,
    Key? key,
  }) = SPlaceHeaderMaterial;
}

/// The kinds of store, each a picture over its name, in a row that
/// scrolls sideways; the `selected` one's name in the brand's green and
/// underlined.
abstract interface class SCategoryStrip implements Widget {
  /// [selected] is the index in [choices] of the one showing.
  const factory SCategoryStrip({
    required List<CategoryChoice> choices,
    required int selected,
    required ValueChanged<int> onSelected,
    Key? key,
  }) = SCategoryStripMaterial;
}

/// A few words from us between a page's offers, on the brand's green:
/// the `title` big, a `message` and a `tag` on an orange pill.
abstract interface class SPromoBanner implements Widget {
  /// [tag] is a short line on an orange pill, under the [message].
  const factory SPromoBanner({
    required String title,
    required String message,
    String? tag,
    Key? key,
  }) = SPromoBannerMaterial;
}
