import 'package:flutter/widgets.dart';

import '../badge/s_badge.dart';
import '../icon/s_icon.dart';
import '../stat/s_figures.dart';
import 's_deal_material.dart';

/// How much of a limited offer is left, at a tile's end.
@immutable
class DealTileStock {
  const DealTileStock({
    required this.left,
    required this.total,
    required this.note,
    required this.label,
    this.hot = false,
  });

  /// Pieces left, in big figures.
  final int left;
  final int total;

  /// Under them: "of 10".
  final String note;

  /// The whole of it for screen readers: "3 of 10 left".
  final String label;

  /// Almost gone: the figures turn orange, so orange in a list always
  /// means something.
  final bool hot;
}

/// What customers see of an offer right now, on its photo: "● Live".
@immutable
class DealStatus {
  const DealStatus({required this.label, required this.tone});

  final String label;
  final BadgeTone tone;
}

/// A round button on an offer's photo.
@immutable
class DealAction {
  const DealAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final SIcons icon;

  /// Required: the button has no words of its own.
  final String tooltip;
  final VoidCallback onPressed;
}

/// How much of a limited offer is left on an [SDealCard], as a bar with
/// words above it.
@immutable
class DealStockSpec {
  const DealStockSpec({
    required this.label,
    required this.note,
    required this.left,
  });

  final String label;
  final String? note;
  final double left;
}

/// An offer in a list, at a glance: its photo with the discount in the
/// brand's orange, the title, the offer price, and at its end how much is
/// left (`stock`). The rest is on the offer's page. Without
/// `discountPercent`, a product the same way, with its regular price.
abstract interface class SDealTile implements Widget {
  /// [price] is already written for people (`formatPrice`).
  /// [discountPercent] is 50 for half price; null shows the photo alone.
  /// [stock] is null for what isn't counted (unlimited offers, products).
  /// [bordered] gives it a card of its own, with a thin border, for a list
  /// of offers alone; else it's a plain row among other things (a page's
  /// section).
  const factory SDealTile({
    required String title,
    required String price,
    int? discountPercent,
    String? imageUrl,
    DealTileStock? stock,
    bool bordered,
    VoidCallback? onTap,
    Key? key,
  }) = SDealTileMaterial;
}

/// The top of an offer's page: its photo edge to edge, under the status
/// bar, with a round back button and an `action` on it and the offer's
/// `status` at its foot; then the title, the offer price in big figures
/// beside the regular one crossed out, and the `discountLabel`. The page
/// shows it without an app bar. Without `originalPrice` and
/// `discountLabel`, a product's page the same way, with its regular price.
abstract interface class SDealHeader implements Widget {
  /// [price] and [originalPrice] are already written for people
  /// (`formatPrice`); [discountLabel] is "40% off".
  const factory SDealHeader({
    required String title,
    required String price,
    String? originalPrice,
    String? discountLabel,
    String? imageUrl,
    DealStatus? status,
    VoidCallback? onBack,
    DealAction? action,
    Key? key,
  }) = SDealHeaderMaterial;
}

/// How much of a limited offer is left: `label` ("3 of 10 left") and a
/// `note` (when it ends) over a bar, in the brand's orange.
abstract interface class SDealStock implements Widget {
  /// [left] is from 0 to 1.
  const factory SDealStock({
    required String label,
    required double left,
    String? note,
    Key? key,
  }) = SDealStockMaterial;
}

/// An offer as a card of its own: more than [SDealTile] shows, for the
/// store's list of its offers: its photo, title, prices and state, until
/// when it runs, how much is left, and how it's selling.
abstract interface class SDealCard implements Widget {
  /// [when] is until when it runs, or when it starts or ended ("Ends
  /// 9:00 PM"). [stock] is how much of a limited offer is left; null for
  /// unlimited ones. [figures] is how it's selling, at the bottom: views,
  /// reservations, pickups.
  const factory SDealCard({
    required String title,
    required String price,
    String? originalPrice,
    int? discountPercent,
    String? imageUrl,
    DealStatus? status,
    String? when,
    DealStockSpec? stock,
    List<Figure> figures,
    VoidCallback? onTap,
    Key? key,
  }) = SDealCardMaterial;
}

/// An offer as customers browse it: a wide photo, rounded, with the
/// discount, the store's logo and how much is left on it; the title
/// and prices under it, then `details` ("Ends in 45 min · 0.8 km"). The
/// offer comes first: the logo stands for the store, whose `storeName`
/// screen readers say. `inRow` makes it most of the screen's width, for a
/// row that scrolls sideways.
abstract interface class SDealPoster implements Widget {
  /// [price] and [originalPrice] are already written for people
  /// (`formatPrice`); [discountLabel] is "44% off". [stockLabel] is
  /// "3 left", null for what isn't counted; [stockHot] turns it orange,
  /// almost gone. [details] are short facts under the title, in this
  /// order. [inRow] makes it one of a row that scrolls sideways: most of
  /// the screen's width, so the next card peeks in.
  const factory SDealPoster({
    required String title,
    required String price,
    required String storeName,
    String? originalPrice,
    String? discountLabel,
    String? imageUrl,
    String? storeLogoUrl,
    String? stockLabel,
    bool stockHot,
    List<String> details,
    bool inRow,
    VoidCallback? onTap,
    Key? key,
  }) = SDealPosterMaterial;
}

/// The bottom of an offer's page, pinned under it (`SScaffold.bottom`):
/// the `price` in big figures with the regular one crossed out above it,
/// and the `action` beside it.
abstract interface class SDealFooter implements Widget {
  /// [price] and [originalPrice] are already written for people
  /// (`formatPrice`); [action] is the main button (an `SButton`).
  const factory SDealFooter({
    required String price,
    required Widget action,
    String? originalPrice,
    Key? key,
  }) = SDealFooterMaterial;
}
