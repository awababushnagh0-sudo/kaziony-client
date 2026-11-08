import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_photo_header_material.dart';

/// The heart on an [SPhotoHeader], saving what the page shows (a store) to
/// the customer's favorites.
@immutable
class PhotoHeaderFavorite {
  const PhotoHeaderFavorite({
    required this.saved,
    required this.tooltip,
    required this.onPressed,
  });

  /// Filled when saved, an outline when not.
  final bool saved;

  /// What a tap does ("Add to favorites"): the button has no words of its
  /// own.
  final String tooltip;
  final VoidCallback onPressed;
}

/// A round button on an [SPhotoHeader], across from the back button: the
/// page's other actions (a menu of what can be done to an offer).
@immutable
class PhotoHeaderAction {
  const PhotoHeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final SIcons icon;

  /// What a tap does ("More"): the button has no words of its own.
  final String tooltip;
  final VoidCallback onPressed;
}

/// The top of a page that opens on a photo (an offer's, a store's cover),
/// as a sliver at the start of a `CustomScrollView`: the photo edge to edge
/// under the status bar, with a round back button on it, the `favorite`
/// heart or the `action` across from it and the `discountLabel` as a green tag against its
/// edge. Scrolling folds it into a bar in the surface's color that stays
/// pinned, the back button and the heart in it; once the bar is solid, the
/// `title` fades in, the `subtitle` under it and the `trailing` widget (a
/// badge) at its end, so what the page is about stays in sight while
/// scrolling. Without `imageUrl`, a plain band, shorter: the brand's green
/// under a caption. The page shows it without an app bar
/// (`SScaffold(showAppBar: false, underStatusBar: true)`).
abstract interface class SPhotoHeader implements Widget {
  /// [discountLabel] is "40% off". [onBack] is null on a page with nothing
  /// under it. [subtitle] (the store's name) and [trailing] ("3 left")
  /// show only on the folded bar. [caption] sits on the photo's foot over
  /// a dark shade, the photo a little taller for it (an offer's name and
  /// price, a store's logo, name and rating, in `SColor.onScrim` and
  /// `SColor.onScrimBrand`), and fades as it folds. A page has a
  /// [favorite] or an [action], not both.
  const factory SPhotoHeader({
    required String title,
    String? subtitle,
    Widget? trailing,
    Widget? caption,
    String? imageUrl,
    String? discountLabel,
    PhotoHeaderFavorite? favorite,
    PhotoHeaderAction? action,
    VoidCallback? onBack,
    Key? key,
  }) = SPhotoHeaderMaterial;
}
