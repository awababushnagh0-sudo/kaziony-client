import 'package:flutter/widgets.dart';

@immutable
class DealTileSpec {
  const DealTileSpec({
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.imageUrl,
    required this.details,
    required this.trailing,
    required this.onTap,
  });

  final String title;
  final String price;
  final String originalPrice;
  final int discountPercent;
  final String? imageUrl;
  final String? details;
  final Widget? trailing;
  final VoidCallback? onTap;
}

abstract interface class DealRenderer {
  Widget tile(BuildContext context, DealTileSpec spec);
}
