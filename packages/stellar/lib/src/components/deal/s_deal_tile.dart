import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_deal_renderer.dart';

/// An offer in a list: its photo, title, the offer price beside the
/// regular one crossed out, the discount in the brand's orange, and a line
/// of [details] (pieces left, end time).
class SDealTile extends StatelessWidget {
  const SDealTile({
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    this.imageUrl,
    this.details,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;

  /// Both already written for people (`formatPrice`).
  final String price;
  final String originalPrice;

  /// 50 for half price.
  final int discountPercent;
  final String? imageUrl;
  final String? details;

  /// At the end of the row: a status badge.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.tile(
    context,
    DealTileSpec(
      title: title,
      price: price,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      imageUrl: imageUrl,
      details: details,
      trailing: trailing,
      onTap: onTap,
    ),
  );
}
