import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge_material.dart';
import '../button/s_button_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../image/s_image_material.dart';
import 's_deal_tile.dart';

/// [SDealTile], drawn as an [InkWell] row, in a bordered [Material] when
/// [bordered].
class SDealTileMaterial extends StatelessWidget implements SDealTile {
  const SDealTileMaterial({
    required this.title,
    required this.price,
    this.discountPercent,
    this.imageUrl,
    this.bordered = false,
    this.onTap,
    super.key,
  });

  final String title;
  final String price;
  final int? discountPercent;
  final String? imageUrl;
  final bool bordered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final row = Padding(
      padding: bordered
          ? const EdgeInsets.all(Space.md)
          : const EdgeInsets.symmetric(
              horizontal: Space.lg,
              vertical: Space.md,
            ),
      child: Row(
        spacing: Space.md,
        children: [
          // The discount fills the photo's corner, cut by its rounding.
          ClipRRect(
            borderRadius: BorderRadius.circular(SImageSize.deal.radius),
            child: Stack(
              children: [
                SImageMaterial(imageUrl, size: SImageSize.deal),
                if (discountPercent case final percent?)
                  PositionedDirectional(
                    bottom: 0,
                    start: 0,
                    child: _DiscountTag(percent),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xs,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: text.body,
                    fontWeight: SFontWeight.semibold.value,
                    color: c.text,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: text.body,
                    fontWeight: SFontWeight.bold.value,
                    color: c.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!bordered) return InkWell(onTap: onTap, child: row);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.xl),
      side: BorderSide(color: c.border),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg),
      child: Material(
        color: c.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: row),
      ),
    );
  }
}

/// [SDealHeader], drawn with buttons of glass on the photo.
class SDealHeaderMaterial extends StatelessWidget implements SDealHeader {
  const SDealHeaderMaterial({
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

  static const _photoHeight = 220.0;

  final String title;
  final String price;
  final String? originalPrice;
  final String? discountLabel;
  final String? imageUrl;
  final DealStatus? status;
  final VoidCallback? onBack;
  final DealAction? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final url = imageUrl;
    final status = this.status;
    final onBack = this.onBack;
    final action = this.action;
    final discountLabel = this.discountLabel;
    final top = MediaQuery.paddingOf(context).top;
    final placeholder = ColoredBox(
      color: c.fieldFill,
      child: Center(
        child: Icon(
          materialIcon(SIcons.image),
          size: SIconSize.xl.pixels,
          color: c.textSubtle,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          // The photo runs up behind the status bar.
          height: top + _photoHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url == null)
                placeholder
              else
                CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  // Decoded at the height shown, not the photo's full size.
                  memCacheHeight:
                      ((top + _photoHeight) *
                              MediaQuery.devicePixelRatioOf(context))
                          .round(),
                  placeholder: (_, _) => placeholder,
                  errorWidget: (_, _, _) => placeholder,
                ),
              if (onBack != null)
                PositionedDirectional(
                  top: top + Space.sm,
                  start: Space.lg,
                  child: SGlassButtonMaterial(
                    icon: SIcons.chevronBack,
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    onPressed: onBack,
                  ),
                ),
              if (action != null)
                PositionedDirectional(
                  top: top + Space.sm,
                  end: Space.lg,
                  child: SGlassButtonMaterial(
                    icon: action.icon,
                    tooltip: action.tooltip,
                    onPressed: action.onPressed,
                  ),
                ),
              if (status != null)
                PositionedDirectional(
                  bottom: Space.md,
                  start: Space.lg,
                  child: SBadgeStatusMaterial(status.label, tone: status.tone),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xs,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: text.display,
                  fontWeight: SFontWeight.bold.value,
                  height: 1.3,
                  color: c.text,
                ),
              ),
              Wrap(
                spacing: Space.md,
                runSpacing: Space.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _Prices(
                    price: price,
                    originalPrice: originalPrice,
                    priceSize: text.display,
                  ),
                  if (discountLabel != null)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: discountGradient(c),
                        borderRadius: BorderRadius.circular(Radii.pill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.md,
                          vertical: Space.xs,
                        ),
                        child: Text(
                          discountLabel,
                          style: TextStyle(
                            fontSize: text.small,
                            fontWeight: SFontWeight.bold.value,
                            color: c.onDiscount,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [SDealFooter], drawn as a row: `SScaffold.bottom` gives it its room
/// and keeps it clear of the home indicator.
class SDealFooterMaterial extends StatelessWidget implements SDealFooter {
  const SDealFooterMaterial({required this.action, this.quantity, super.key});

  final Widget action;
  final Widget? quantity;

  @override
  Widget build(BuildContext context) => Row(
    spacing: Space.md,
    children: [
      ?quantity,
      Expanded(child: action),
    ],
  );
}

/// The price in the brand's green, and the regular one crossed out when
/// there's an offer.
class _Prices extends StatelessWidget {
  const _Prices({
    required this.price,
    required this.originalPrice,
    required this.priceSize,
  });

  final String price;
  final String? originalPrice;
  final double priceSize;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final originalPrice = this.originalPrice;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: Space.sm,
      children: [
        Text(
          price,
          style: TextStyle(
            fontSize: priceSize,
            fontWeight: SFontWeight.bold.value,
            color: c.primary,
          ),
        ),
        if (originalPrice != null)
          Text(
            originalPrice,
            style: TextStyle(
              fontSize: context.style.text.small,
              color: c.textSubtle,
              decoration: TextDecoration.lineThrough,
              decorationColor: c.textSubtle,
            ),
          ),
      ],
    );
  }
}

/// The discount in a photo's corner: small, so the photo still shows, and
/// rounded only on the side facing the photo.
class _DiscountTag extends StatelessWidget {
  const _DiscountTag(this.percent);

  final int percent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: discountGradient(c),
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(Radii.md),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.sm,
          vertical: Space.xxs,
        ),
        child: Text(
          // "50%" keeps this order in Arabic too.
          '\u2066$percent%\u2069',
          style: TextStyle(
            fontSize: context.style.text.tiny,
            fontWeight: SFontWeight.bold.value,
            height: 1.2,
            color: c.onDiscount,
          ),
        ),
      ),
    );
  }
}
