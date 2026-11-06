import 'package:flutter/widgets.dart';

import 's_ongoing_bar_material.dart';

/// Something under way to come back to (a booking to pick up), as a dark
/// bar floating over the page above the tabs (`SNavBar`'s `banner`): a
/// round picture (the store's logo), the [title] and a quieter
/// [subtitle], the [trailing] figures in orange (the time left), and an
/// arrow; tapping it opens what it's about.
abstract interface class SOngoingBar implements Widget {
  /// [imageUrl] null shows a plain store mark.
  const factory SOngoingBar({
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    String? imageUrl,
    String? trailing,
    Key? key,
  }) = SOngoingBarMaterial;
}
