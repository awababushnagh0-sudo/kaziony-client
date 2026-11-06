import 'package:flutter/widgets.dart';

import 's_favorite_button_material.dart';

/// A heart to tap, saving something (a store) to the customer's favorites
/// or taking it out: filled in the favorites' pink-red when [saved], an
/// outline when not. Plain, with no ring around it, at the end of a row.
abstract interface class SFavoriteButton implements Widget {
  /// [tooltip] says what a tap does ("Remove from favorites"): the button
  /// has no words of its own.
  const factory SFavoriteButton({
    required bool saved,
    required String tooltip,
    required VoidCallback? onPressed,
    Key? key,
  }) = SFavoriteButtonMaterial;
}
