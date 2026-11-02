import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../stat/s_stat_renderer.dart';
import 's_deal_renderer.dart';

/// An offer in a list, at a glance: its photo with the discount in the
/// brand's orange, the title, the offer price, and at its end how much is
/// left ([stock]). The rest is on the offer's page. Without
/// [discountPercent], a product the same way, with its regular price.
class SDealTile extends StatelessWidget {
  const SDealTile({
    required this.title,
    required this.price,
    this.discountPercent,
    this.imageUrl,
    this.stock,
    this.bordered = false,
    this.onTap,
    super.key,
  });

  final String title;

  /// Already written for people (`formatPrice`).
  final String price;

  /// 50 for half price; null shows the photo alone.
  final int? discountPercent;
  final String? imageUrl;

  /// Null for what isn't counted (unlimited offers, products).
  final DealTileStock? stock;

  /// A card of its own, with a thin border, for a list of offers alone; a
  /// plain row among other things (a page's section).
  final bool bordered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.tile(
    context,
    DealTileSpec(
      title: title,
      price: price,
      discountPercent: discountPercent,
      imageUrl: imageUrl,
      stock: stock,
      bordered: bordered,
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

/// An offer as a card of its own ([DealCardSpec]): more than [SDealTile]
/// shows, for the store's list of its offers.
class SDealCard extends StatelessWidget {
  const SDealCard({
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
    super.key,
  });

  final String title;
  final String price;
  final String? originalPrice;
  final int? discountPercent;
  final String? imageUrl;
  final DealStatus? status;
  final String? when;
  final DealStockSpec? stock;
  final List<Figure> figures;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.card(
    context,
    DealCardSpec(
      title: title,
      price: price,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      imageUrl: imageUrl,
      status: status,
      when: when,
      stock: stock,
      figures: figures,
      onTap: onTap,
    ),
  );
}

/// An offer as customers browse it ([DealPosterSpec]): the photo big, with
/// the discount, the store's logo and how much is left on it; the title
/// and prices under it, then [details] ("Ends in 45 min · 0.8 km").
/// [inRow] gives it a fixed width, for a row that scrolls sideways.
class SDealPoster extends StatelessWidget {
  const SDealPoster({
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
    super.key,
  });

  final String title;

  /// Both already written for people (`formatPrice`).
  final String price;
  final String? originalPrice;
  final String storeName;

  /// "44% off".
  final String? discountLabel;
  final String? imageUrl;
  final String? storeLogoUrl;

  /// "3 left"; null for what isn't counted.
  final String? stockLabel;
  final bool stockHot;
  final List<String> details;
  final bool inRow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.poster(
    context,
    DealPosterSpec(
      title: title,
      price: price,
      storeName: storeName,
      originalPrice: originalPrice,
      discountLabel: discountLabel,
      imageUrl: imageUrl,
      storeLogoUrl: storeLogoUrl,
      stockLabel: stockLabel,
      stockHot: stockHot,
      details: details,
      inRow: inRow,
      onTap: onTap,
    ),
  );
}

/// The bottom of an offer's page, pinned under it (`SScaffold.bottom`):
/// the [price] in big figures with the regular one crossed out above it,
/// and the [action] beside it.
class SDealFooter extends StatelessWidget {
  const SDealFooter({
    required this.price,
    required this.action,
    this.originalPrice,
    super.key,
  });

  /// Both already written for people (`formatPrice`).
  final String price;
  final String? originalPrice;

  /// The main button (an `SButton`).
  final Widget action;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).deal.footer(
    context,
    DealFooterSpec(price: price, originalPrice: originalPrice, action: action),
  );
}
