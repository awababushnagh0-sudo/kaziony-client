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

/// The kinds of store, each a picture over its name, in a row: spread
/// across when they all fit, scrolling sideways when they don't, a green
/// dot between each two; the `selected` one's name in the brand's green,
/// its picture on a soft orange wavy sticker that pops in.
abstract interface class SCategoryStrip implements Widget {
  /// [selected] is the index in [choices] of the one showing.
  const factory SCategoryStrip({
    required List<CategoryChoice> choices,
    required int selected,
    required ValueChanged<int> onSelected,
    Key? key,
  }) = SCategoryStripMaterial;
}

/// A store's logo, round, with its name under it, tapped to open the
/// store: one of a row of stores (`SCarousel.small`). The brand's
/// picture of someone without one when it has no logo.
abstract interface class SLogoTile implements Widget {
  /// [url] is null when the store has no logo; [name] goes under it, on
  /// one line.
  const factory SLogoTile(
    String? url, {
    required String name,
    required VoidCallback onTap,
    Key? key,
  }) = SLogoTileMaterial;
}
