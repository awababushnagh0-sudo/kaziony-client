import 'package:flutter/widgets.dart';

import '../badge/s_badge_renderer.dart';
import '../icon/s_icon.dart';

@immutable
class DealTileSpec {
  const DealTileSpec({
    required this.title,
    required this.price,
    required this.discountPercent,
    required this.imageUrl,
    required this.details,
    required this.hot,
    required this.bordered,
    required this.trailing,
    required this.onTap,
  });

  final String title;
  final String price;
  final int discountPercent;
  final String? imageUrl;
  final String? details;

  /// Shows [details] in orange: almost gone.
  final bool hot;

  /// A card of its own, with a thin border, instead of a plain row.
  final bool bordered;
  final Widget? trailing;
  final VoidCallback? onTap;
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
  final String originalPrice;

  /// "40% off".
  final String discountLabel;
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

abstract interface class DealRenderer {
  Widget tile(BuildContext context, DealTileSpec spec);

  Widget header(BuildContext context, DealHeaderSpec spec);

  Widget stock(BuildContext context, DealStockSpec spec);
}
