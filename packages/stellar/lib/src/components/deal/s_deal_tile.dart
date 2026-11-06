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

/// The bottom of an offer's page, pinned under it (`SScaffold.bottom`):
/// the main `action`, with how many to take beside it, in thumb reach.
/// The page above shows the price.
abstract interface class SDealFooter implements Widget {
  /// [action] is the main button (an `SButton`); [quantity] an
  /// `SQuantityInput`, null when there's only one to take.
  const factory SDealFooter({
    required Widget action,
    Widget? quantity,
    Key? key,
  }) = SDealFooterMaterial;
}
