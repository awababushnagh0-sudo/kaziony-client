import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_deal_renderer.dart';

/// An offer in a list, at a glance: its photo with the discount in the
/// brand's orange, the title, the offer price, and a line of [details]
/// ("3 of 10 left") that turns orange when [hot]. The rest is on the
/// offer's page. Without [discountPercent], a product the same way, with
/// its regular price.
class SDealTile extends StatelessWidget {
  const SDealTile({
    required this.title,
    required this.price,
    this.discountPercent,
    this.imageUrl,
    this.details,
    this.hot = false,
    this.bordered = false,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;

  /// Already written for people (`formatPrice`).
  final String price;

  /// 50 for half price; null shows the photo alone.
  final int? discountPercent;
  final String? imageUrl;
  final String? details;

  /// Shows [details] in orange: almost gone, so orange in a list always
  /// means something.
  final bool hot;

  /// A card of its own, with a thin border, for a list of offers alone; a
  /// plain row among other things (a page's section).
  final bool bordered;

  /// At the end of the title: a status badge.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.tile(
    context,
    DealTileSpec(
      title: title,
      price: price,
      discountPercent: discountPercent,
      imageUrl: imageUrl,
      details: details,
      hot: hot,
      bordered: bordered,
      trailing: trailing,
      onTap: onTap,
    ),
  );
}

/// The top of an offer's page: its photo edge to edge, under the status
/// bar, with a round back button and an [action] on it and the offer's
/// [status] at its foot; then the title, the offer price in big figures
/// beside the regular one crossed out, and the [discountLabel]. The page
/// shows it without an app bar. Without [originalPrice] and
/// [discountLabel], a product's page the same way, with its regular price.
class SDealHeader extends StatelessWidget {
  const SDealHeader({
    required this.title,
    required this.price,
    this.originalPrice,
    this.discountLabel,
    this.imageUrl,
    this.status,
    this.onBack,
    this.action,
    super.key,
  });

  final String title;

  /// Both already written for people (`formatPrice`).
  final String price;
  final String? originalPrice;

  /// "40% off".
  final String? discountLabel;
  final String? imageUrl;
  final DealStatus? status;
  final VoidCallback? onBack;
  final DealAction? action;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.header(
    context,
    DealHeaderSpec(
      title: title,
      price: price,
      originalPrice: originalPrice,
      discountLabel: discountLabel,
      imageUrl: imageUrl,
      status: status,
      onBack: onBack,
      action: action,
    ),
  );
}

/// How much of a limited offer is left: [label] ("3 of 10 left") and a
/// [note] (when it ends) over a bar, in the brand's orange.
class SDealStock extends StatelessWidget {
  const SDealStock({
    required this.label,
    required this.left,
    this.note,
    super.key,
  });

  final String label;
  final String? note;

  /// 0 to 1.
  final double left;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).deal
          .stock(context, DealStockSpec(label: label, note: note, left: left));
}
