import 'package:flutter/widgets.dart';

import 's_photo_header_material.dart';

/// The store whose logo sits on an [SPhotoHeader]'s photo.
@immutable
class PhotoHeaderLogo {
  const PhotoHeaderLogo(this.url, {required this.storeName});

  /// Null when the store has no logo: its icon stands in.
  final String? url;

  /// What screen readers say for it.
  final String storeName;
}

/// The top of a page that opens on a photo (an offer's, a store's cover),
/// as a sliver at the start of a `CustomScrollView`: the photo edge to edge
/// under the status bar, with a round back button on it, the
/// `discountLabel` and the store's `logo` at its foot. Scrolling folds it
/// into a bar in the surface's color that stays pinned, the back button
/// in it and the `title` fading in, the `subtitle` under it and the
/// `trailing` widget (a badge) at its end, so what the page is about stays
/// in sight while scrolling. Without `imageUrl`, a plain band,
/// shorter. The page shows it without an app bar
/// (`SScaffold(showAppBar: false, underStatusBar: true)`).
abstract interface class SPhotoHeader implements Widget {
  /// [discountLabel] is "40% off". [onBack] is null on a page with nothing
  /// under it. [subtitle] (the store's name) and [trailing] ("3 left")
  /// show only on the folded bar.
  const factory SPhotoHeader({
    required String title,
    String? subtitle,
    Widget? trailing,
    String? imageUrl,
    String? discountLabel,
    PhotoHeaderLogo? logo,
    VoidCallback? onBack,
    Key? key,
  }) = SPhotoHeaderMaterial;
}
