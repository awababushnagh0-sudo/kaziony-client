import 'package:flutter/widgets.dart';

import '../badge/s_badge.dart';
import '../icon/s_icon.dart';
import 's_deal_material.dart';

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

/// An offer in a list, at a glance: its photo with the discount in the
/// brand's orange, the title and the offer price. The rest is on the
/// offer's page. Without `discountPercent`, a product the same way, with
/// its regular price.
abstract interface class SDealTile implements Widget {
  /// [price] is already written for people (`formatPrice`).
  /// [discountPercent] is 50 for half price; null shows the photo alone.
  /// [bordered] gives it a card of its own, with a thin border, for a list
  /// of offers alone; else it's a plain row among other things (a page's
  /// section).
  const factory SDealTile({
    required String title,
    required String price,
    int? discountPercent,
    String? imageUrl,
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
