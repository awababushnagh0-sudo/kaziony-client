import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge.dart';
import '../badge/s_badge_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../image/s_image_material.dart';
import '../stat/s_figures.dart';
import 's_deal_tile.dart';

/// [SDealTile], drawn as an [InkWell] row, in a bordered [Material] when
/// [bordered].
class SDealTileMaterial extends StatelessWidget implements SDealTile {
  const SDealTileMaterial({
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
  final String price;
  final int? discountPercent;
  final String? imageUrl;
  final DealTileStock? stock;
  final bool bordered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final stock = this.stock;
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
          if (stock != null) _StockCount(stock),
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

/// [SDealHeader], drawn with Material's [IconButton]s on the photo.
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
                  child: _RoundButton(
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
                  child: _RoundButton(
                    icon: action.icon,
                    tooltip: action.tooltip,
                    onPressed: action.onPressed,
                  ),
                ),
              if (status != null)
                PositionedDirectional(
                  bottom: Space.md,
                  start: Space.lg,
                  child: _StatusPill(status),
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

/// [SDealStock], drawn with Material's [LinearProgressIndicator].
class SDealStockMaterial extends StatelessWidget implements SDealStock {
  const SDealStockMaterial({
    required this.label,
    required this.left,
    this.note,
    super.key,
  });

  static const _barHeight = 10.0;

  final String label;
  final String? note;
  final double left;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final note = this.note;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.accentWash,
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.md,
          children: [
            Row(
              spacing: Space.sm,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: text.body,
                      fontWeight: SFontWeight.bold.value,
                      color: c.accentInk,
                    ),
                  ),
                ),
                if (note != null)
                  Flexible(
                    child: Text(
                      note,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: text.small,
                        fontWeight: SFontWeight.semibold.value,
                        color: c.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
            _Bar(
              left: left,
              height: _barHeight,
              fill: c.accent,
              track: c.accentSoft,
            ),
          ],
        ),
      ),
    );
  }
}

/// [SDealCard], drawn as a bordered [Material] with an [InkWell].
class SDealCardMaterial extends StatelessWidget implements SDealCard {
  const SDealCardMaterial({
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

  static const _barHeight = 6.0;

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
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final status = this.status;
    final when = this.when;
    final stock = this.stock;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg),
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.xl),
          side: BorderSide(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.md,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.md,
                  children: [
                    _Photo(url: imageUrl, discountPercent: discountPercent),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Space.xs,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: Space.sm,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: text.body,
                                    fontWeight: SFontWeight.bold.value,
                                    color: c.text,
                                  ),
                                ),
                              ),
                              if (status != null)
                                SBadgeMaterial(status.label, tone: status.tone),
                            ],
                          ),
                          _Prices(
                            price: price,
                            originalPrice: originalPrice,
                            priceSize: text.body,
                          ),
                          if (when != null)
                            Row(
                              spacing: Space.xs,
                              children: [
                                Icon(
                                  materialIcon(SIcons.clock),
                                  size: SIconSize.xs.pixels,
                                  color: c.textSubtle,
                                ),
                                Flexible(
                                  child: Text(
                                    when,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: text.small,
                                      color: c.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (stock != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: Space.xs,
                    children: [
                      Text(
                        stock.label,
                        style: TextStyle(
                          fontSize: text.small,
                          fontWeight: SFontWeight.semibold.value,
                          color: c.text,
                        ),
                      ),
                      _Bar(
                        left: stock.left,
                        height: _barHeight,
                        fill: c.primary,
                        track: c.primaryTint,
                      ),
                    ],
                  ),
                if (figures.isNotEmpty)
                  // Sharing the card's width.
                  Row(
                    spacing: Space.sm,
                    children: [
                      for (final figure in figures)
                        Expanded(child: _FigurePill(figure)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [SDealPoster]: no box around it, the photo rounded on its own and the
/// words under it, tapped as one with an [InkWell].
class SDealPosterMaterial extends StatelessWidget implements SDealPoster {
  const SDealPosterMaterial({
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

  /// A card in a row takes most of the screen's width, so the next one
  /// peeks in; never wider than this.
  static const _rowShare = 0.72;
  static const _rowMaxWidth = 320.0;

  /// The photo's width to its height: wide, like a banner.
  static const _photoRatio = 2.0;
  static const _logo = 48.0;

  final String title;
  final String price;
  final String? originalPrice;
  final String storeName;
  final String? discountLabel;
  final String? imageUrl;
  final String? storeLogoUrl;
  final String? stockLabel;
  final bool stockHot;
  final List<String> details;
  final bool inRow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final url = imageUrl;
    final logo = storeLogoUrl;
    final discount = discountLabel;
    final stock = stockLabel;
    final originalPrice = this.originalPrice;
    final placeholder = ColoredBox(
      color: c.cream,
      child: Center(
        child: Icon(
          materialIcon(SIcons.offers),
          size: SIconSize.xl.pixels,
          color: c.textSubtle,
        ),
      ),
    );
    final card = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: _photoRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.xl),
                  child: url == null
                      ? placeholder
                      : LayoutBuilder(
                          builder: (context, box) => CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            memCacheWidth:
                                (box.maxWidth *
                                        MediaQuery.devicePixelRatioOf(context))
                                    .round(),
                            placeholder: (_, _) => placeholder,
                            errorWidget: (_, _, _) => placeholder,
                          ),
                        ),
                ),
                if (discount != null)
                  PositionedDirectional(
                    top: Space.sm,
                    end: Space.sm,
                    child: _DiscountPill(discount),
                  ),
                PositionedDirectional(
                  bottom: Space.sm,
                  start: Space.sm,
                  // The logo stands for the store on the card; the name
                  // is for screen readers.
                  child: Semantics(
                    label: storeName,
                    image: true,
                    child: _Logo(url: logo, size: _logo),
                  ),
                ),
                if (stock != null)
                  PositionedDirectional(
                    bottom: Space.sm,
                    end: Space.sm,
                    child: _OnPhotoPill(
                      label: stock,
                      color: stockHot ? c.accentInk : c.text,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.xxs,
              Space.sm,
              Space.xxs,
              0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: Space.md,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Space.xxs,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: text.body,
                          fontWeight: SFontWeight.bold.value,
                          color: c.text,
                        ),
                      ),
                      if (details.isNotEmpty)
                        Row(
                          spacing: Space.xs,
                          children: [
                            Icon(
                              materialIcon(SIcons.clock),
                              size: SIconSize.xs.pixels,
                              color: c.textSubtle,
                            ),
                            Flexible(
                              child: Text(
                                details.join(' · '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: text.small,
                                  color: c.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (originalPrice != null)
                      Text(
                        originalPrice,
                        style: TextStyle(
                          fontSize: text.small,
                          color: c.textSubtle,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: c.textSubtle,
                        ),
                      ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: text.subtitle,
                        fontWeight: SFontWeight.bold.value,
                        color: c.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!inRow) return card;
    final width = MediaQuery.sizeOf(context).width * _rowShare;
    return SizedBox(
      width: width < _rowMaxWidth ? width : _rowMaxWidth,
      child: card,
    );
  }
}

/// [SDealFooter], drawn as a bordered bar in a [SafeArea].
class SDealFooterMaterial extends StatelessWidget implements SDealFooter {
  const SDealFooterMaterial({
    required this.price,
    required this.action,
    this.originalPrice,
    super.key,
  });

  final String price;
  final String? originalPrice;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final originalPrice = this.originalPrice;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            spacing: Space.lg,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (originalPrice != null)
                    Text(
                      originalPrice,
                      style: TextStyle(
                        fontSize: text.small,
                        color: c.textSubtle,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: c.textSubtle,
                      ),
                    ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: text.display,
                      fontWeight: SFontWeight.bold.value,
                      height: 1.2,
                      color: c.primary,
                    ),
                  ),
                ],
              ),
              Expanded(child: action),
            ],
          ),
        ),
      ),
    );
  }
}

/// The discount on a big photo: "44% off" in the discount's colors.
class _DiscountPill extends StatelessWidget {
  const _DiscountPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
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
          label,
          style: TextStyle(
            fontSize: context.style.text.small,
            fontWeight: SFontWeight.bold.value,
            color: c.onDiscount,
          ),
        ),
      ),
    );
  }
}

/// A short word in a small white pill, so it reads on any photo ("2 left").
class _OnPhotoPill extends StatelessWidget {
  const _OnPhotoPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(Radii.pill),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.sm,
        vertical: Space.xxs,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.style.text.tiny,
          fontWeight: SFontWeight.bold.value,
          color: color,
        ),
      ),
    ),
  );
}

/// How much of the photo shows through the plate under a store's logo.
const _logoPlateOpacity = 0.8;

/// A store's logo on a light round plate, so it stands off the photo while
/// a little of it shows through; the store icon when it has none.
class _Logo extends StatelessWidget {
  const _Logo({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final url = this.url;
    final fallback = ColoredBox(
      color: c.primarySoft,
      child: Icon(
        materialIcon(SIcons.store),
        size: SIconSize.sm.pixels,
        color: c.primary,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: _logoPlateOpacity),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: c.shadow, blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.xs),
        child: ClipOval(
          child: SizedBox.square(
            dimension: size,
            child: url == null
                ? fallback
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    memCacheWidth:
                        (size * MediaQuery.devicePixelRatioOf(context)).round(),
                    placeholder: (_, _) => fallback,
                    errorWidget: (_, _, _) => fallback,
                  ),
          ),
        ),
      ),
    );
  }
}

/// An offer's photo with its discount in the corner, cut by the rounding.
class _Photo extends StatelessWidget {
  const _Photo({required this.url, required this.discountPercent});

  final String? url;
  final int? discountPercent;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(SImageSize.deal.radius),
    child: Stack(
      children: [
        SImageMaterial(url, size: SImageSize.deal),
        if (discountPercent case final percent?)
          PositionedDirectional(
            bottom: 0,
            start: 0,
            child: _DiscountTag(percent),
          ),
      ],
    ),
  );
}

/// One of a card's numbers in a gray pill: its icon, the number and what
/// it counts.
class _FigurePill extends StatelessWidget {
  const _FigurePill(this.figure);

  final Figure figure;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final icon = figure.icon;
    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.sm,
            vertical: Space.sm,
          ),
          // Smaller words, never cut, where the three don't fit.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: Space.xs,
              children: [
                if (icon != null)
                  Icon(
                    materialIcon(icon),
                    size: SIconSize.xs.pixels,
                    color: c.textMuted,
                  ),
                Text(
                  figure.value,
                  style: TextStyle(
                    fontSize: text.small,
                    fontWeight: SFontWeight.bold.value,
                    color: c.text,
                  ),
                ),
                Text(
                  figure.label,
                  style: TextStyle(fontSize: text.small, color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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

/// What's left, in [fill] on [track].
class _Bar extends StatelessWidget {
  const _Bar({
    required this.left,
    required this.height,
    required this.fill,
    required this.track,
  });

  final double left;
  final double height;
  final Color fill;
  final Color track;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(Radii.pill),
    child: LinearProgressIndicator(
      value: left.clamp(0, 1),
      minHeight: height,
      color: fill,
      backgroundColor: track,
    ),
  );
}

/// A white circle on a photo, so the icon reads on any picture.
class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  static const _size = 44.0;

  final SIcons icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: c.shadow, blurRadius: 12)],
      ),
      child: Material(
        color: c.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: SizedBox.square(
          dimension: _size,
          child: IconButton(
            tooltip: tooltip,
            onPressed: onPressed,
            color: c.text,
            icon: Icon(materialIcon(icon), size: SIconSize.md.pixels),
          ),
        ),
      ),
    );
  }
}

/// "● Live" in a white pill, so it reads on any photo.
class _StatusPill extends StatelessWidget {
  const _StatusPill(this.status);

  static const _dot = 8.0;

  final DealStatus status;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (tone, _) = badgeColors(c, status.tone);
    // The solid orange tone's text is white: on white, the orange itself.
    final color = status.tone == BadgeTone.accent ? c.accent : tone;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.xs,
          children: [
            SizedBox.square(
              dimension: _dot,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
            Text(
              status.label,
              style: TextStyle(
                fontSize: context.style.text.small,
                fontWeight: SFontWeight.bold.value,
                color: color,
              ),
            ),
          ],
        ),
      ),
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

/// The discount's own colors, light at the start and deeper at the end.
LinearGradient discountGradient(StellarColors c) => LinearGradient(
  begin: AlignmentDirectional.topStart,
  end: AlignmentDirectional.bottomEnd,
  colors: [c.discountFrom, c.discountTo],
);

/// How much is left at a tile's end: the pieces left in big figures, and
/// "of 10" smaller under them, set off toward the end so the two read as a
/// count, not a column; orange when almost gone.
class _StockCount extends StatelessWidget {
  const _StockCount(this.stock);

  final DealTileStock stock;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Semantics(
      label: stock.label,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${stock.left}',
            style: TextStyle(
              fontSize: text.display,
              fontWeight: SFontWeight.bold.value,
              height: 1,
              color: stock.hot ? c.accentInk : c.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Space.md),
            child: Text(
              stock.note,
              style: TextStyle(
                fontSize: text.small,
                fontWeight: SFontWeight.medium.value,
                color: c.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
