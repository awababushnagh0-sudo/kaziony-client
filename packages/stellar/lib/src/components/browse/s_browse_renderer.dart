import 'package:flutter/widgets.dart';

import '../illustration/s_illustration_renderer.dart';

/// Where offers are shown from, at the top of a home page.
@immutable
class PlaceHeaderSpec {
  const PlaceHeaderSpec({
    required this.caption,
    required this.place,
    required this.onTap,
    this.trailing,
  });

  /// Over the place: "Offers near".
  final String caption;
  final String place;
  final VoidCallback onTap;

  /// At the other end (the brand's logo).
  final Widget? trailing;
}

/// One kind of store to show offers from, with its picture.
@immutable
class CategoryChoice {
  const CategoryChoice({required this.label, this.illustration, this.imageUrl});

  final String label;

  /// One of the brand's pictures; else [imageUrl]; else a plain mark.
  final Illustration? illustration;
  final String? imageUrl;
}

@immutable
class CategoryStripSpec {
  const CategoryStripSpec({
    required this.choices,
    required this.selected,
    required this.onSelected,
  });

  final List<CategoryChoice> choices;

  /// The index of the one showing.
  final int selected;
  final ValueChanged<int> onSelected;
}

/// A few words from us on a page of offers, on the brand's green.
@immutable
class PromoBannerSpec {
  const PromoBannerSpec({required this.title, required this.message, this.tag});

  final String title;
  final String message;

  /// A short line on an orange pill.
  final String? tag;
}

/// The parts of a page where customers browse offers.
abstract interface class BrowseRenderer {
  Widget place(BuildContext context, PlaceHeaderSpec spec);

  Widget categories(BuildContext context, CategoryStripSpec spec);

  Widget banner(BuildContext context, PromoBannerSpec spec);
}
