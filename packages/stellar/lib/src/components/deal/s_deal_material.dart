import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge_material.dart';
import '../badge/s_badge_renderer.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../image/s_image_material.dart';
import '../image/s_image_renderer.dart';
import 's_deal_renderer.dart';

class MaterialDealRenderer implements DealRenderer {
  const MaterialDealRenderer();

  static const _barHeight = 10.0;
  static const _photoHeight = 220.0;

  @override
  Widget tile(BuildContext context, DealTileSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final details = spec.details;
    final row = Padding(
      padding: spec.bordered
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
                const MaterialImageRenderer().render(
                  context,
                  ImageSpec(url: spec.imageUrl, size: SImageSize.deal),
                ),
                PositionedDirectional(
                  bottom: 0,
                  start: 0,
                  child: _DiscountTag(spec.discountPercent),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xs,
              children: [
                Row(
                  spacing: Space.sm,
                  children: [
                    Expanded(
                      child: Text(
                        spec.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: text.body,
                          fontWeight: SFontWeight.semibold.value,
                          color: c.text,
                        ),
                      ),
                    ),
                    ?spec.trailing,
                  ],
                ),
                Text(
                  spec.price,
                  style: TextStyle(
                    fontSize: text.body,
                    fontWeight: SFontWeight.bold.value,
                    color: c.primary,
                  ),
                ),
                if (details != null)
                  Text(
                    details,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: text.small,
                      fontWeight: spec.hot ? SFontWeight.semibold.value : null,
                      color: spec.hot ? c.accentInk : c.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!spec.bordered) return InkWell(onTap: spec.onTap, child: row);
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
        child: InkWell(onTap: spec.onTap, child: row),
      ),
    );
  }

  @override
  Widget header(BuildContext context, DealHeaderSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final url = spec.imageUrl;
    final status = spec.status;
    final onBack = spec.onBack;
    final action = spec.action;
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
                spec.title,
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
                    price: spec.price,
                    originalPrice: spec.originalPrice,
                    priceSize: text.display,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Space.md,
                        vertical: Space.xs,
                      ),
                      child: Text(
                        spec.discountLabel,
                        style: TextStyle(
                          fontSize: text.small,
                          fontWeight: SFontWeight.bold.value,
                          color: c.onAccent,
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

  @override
  Widget stock(BuildContext context, DealStockSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final note = spec.note;
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
                    spec.label,
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
            _Bar(left: spec.left, height: _barHeight, track: c.accentSoft),
          ],
        ),
      ),
    );
  }
}

/// The offer price in the brand's green, the regular one crossed out.
class _Prices extends StatelessWidget {
  const _Prices({
    required this.price,
    required this.originalPrice,
    required this.priceSize,
  });

  final String price;
  final String originalPrice;
  final double priceSize;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
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

/// What's left, in orange on [track].
class _Bar extends StatelessWidget {
  const _Bar({required this.left, required this.height, required this.track});

  final double left;
  final double height;
  final Color track;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(Radii.pill),
    child: LinearProgressIndicator(
      value: left.clamp(0, 1),
      minHeight: height,
      color: context.colors.accent,
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
        color: c.accent,
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
            color: c.onAccent,
          ),
        ),
      ),
    );
  }
}
