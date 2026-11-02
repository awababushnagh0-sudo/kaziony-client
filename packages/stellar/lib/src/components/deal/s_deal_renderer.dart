import 'package:flutter/widgets.dart';

import '../badge/s_badge_renderer.dart';
import '../icon/s_icon.dart';
import '../stat/s_stat_renderer.dart';

@immutable
class DealTileSpec {
  const DealTileSpec({
    required this.title,
    required this.price,
    required this.discountPercent,
    required this.imageUrl,
    required this.stock,
    required this.bordered,
    required this.onTap,
  });

  final String title;
  final String price;
  final int? discountPercent;
  final String? imageUrl;
  final DealTileStock? stock;

  /// A card of its own, with a thin border, instead of a plain row.
  final bool bordered;
  final VoidCallback? onTap;
}

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

/// The top of an offer's page: its photo edge to edge, with round buttons
/// and the offer's state on it, then its title and prices.
@immutable
class DealHeaderSpec {
  const DealHeaderSpec({
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.discountLabel,
    required this.imageUrl,
    required this.status,
    required this.onBack,
    required this.action,
  });

  final String title;
  final String price;
  final String? originalPrice;

  /// "40% off".
  final String? discountLabel;
  final String? imageUrl;
  final DealStatus? status;
  final VoidCallback? onBack;
  final DealAction? action;
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

/// How much of a limited offer is left, as a bar with words above it.
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

/// An offer as a card of its own, for the store's list of its offers: its
/// photo, title, prices and state, until when it runs, how much is left,
/// and how it's selling.
@immutable
class DealCardSpec {
  const DealCardSpec({
    required this.title,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.imageUrl,
    this.status,
    this.when,
    this.stock,
    this.figures = const [],
    this.onTap,
  });

  final String title;
  final String price;
  final String? originalPrice;
  final int? discountPercent;
  final String? imageUrl;
  final DealStatus? status;

  /// Until when it runs, or when it starts or ended: "Ends 9:00 PM".
  final String? when;

  /// How much of a limited offer is left; null for unlimited ones.
  final DealStockSpec? stock;

  /// How it's selling, at the bottom: views, reservations, pickups.
  final List<Figure> figures;
  final VoidCallback? onTap;
}

/// An offer as customers browse it: its photo big, with the discount and
/// the store's logo on it, then the title, prices and what to know at a
/// glance (when it ends, how far).
@immutable
class DealPosterSpec {
  const DealPosterSpec({
    required this.title,
    required this.price,
    required this.storeName,
    this.originalPrice,
    this.discountLabel,
    this.imageUrl,
    this.storeLogoUrl,
    this.stockLabel,
    this.stockHot = false,
    this.details = const [],
    this.inRow = false,
    this.onTap,
  });

  final String title;
  final String price;
  final String storeName;
  final String? originalPrice;

  /// "44% off".
  final String? discountLabel;
  final String? imageUrl;
  final String? storeLogoUrl;

  /// "3 left", on the photo; null for what isn't counted.
  final String? stockLabel;

  /// Almost gone: the count turns orange.
  final bool stockHot;

  /// Short facts under the title, in this order ("Ends in 45 min",
  /// "0.8 km").
  final List<String> details;

  /// One of a row that scrolls sideways: a fixed width, so the next card
  /// peeks in.
  final bool inRow;
  final VoidCallback? onTap;
}

/// The bottom of an offer's page: its price and the way to take it.
@immutable
class DealFooterSpec {
  const DealFooterSpec({
    required this.price,
    required this.action,
    this.originalPrice,
  });

  final String price;
  final String? originalPrice;

  /// The main button (an `SButton`).
  final Widget action;
}

abstract interface class DealRenderer {
  Widget tile(BuildContext context, DealTileSpec spec);

  Widget header(BuildContext context, DealHeaderSpec spec);

  Widget stock(BuildContext context, DealStockSpec spec);

  Widget card(BuildContext context, DealCardSpec spec);

  Widget poster(BuildContext context, DealPosterSpec spec);

  Widget footer(BuildContext context, DealFooterSpec spec);
}
