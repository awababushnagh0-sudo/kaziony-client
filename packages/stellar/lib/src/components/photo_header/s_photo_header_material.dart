import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge.dart';
import '../badge/s_badge_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../logo/s_logo_material.dart';
import 's_photo_header.dart';

/// [SPhotoHeader], drawn as a pinned [SliverPersistentHeader].
class SPhotoHeaderMaterial extends StatelessWidget implements SPhotoHeader {
  const SPhotoHeaderMaterial({
    required this.title,
    this.subtitle,
    this.trailing,
    this.imageUrl,
    this.discountLabel,
    this.logo,
    this.onBack,
    super.key,
  });

  /// The photo's height, under the status bar.
  static const _photoHeight = 240.0;

  /// Without a photo: room for the bar and the logo under it.
  static const _plainHeight = 128.0;

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? imageUrl;
  final String? discountLabel;
  final PhotoHeaderLogo? logo;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _PhotoHeaderDelegate(
      header: this,
      top: MediaQuery.paddingOf(context).top,
      height: imageUrl == null ? _plainHeight : _photoHeight,
      backTooltip: MaterialLocalizations.of(context).backButtonTooltip,
    ),
  );
}

class _PhotoHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PhotoHeaderDelegate({
    required this.header,
    required this.top,
    required this.height,
    required this.backTooltip,
  });

  final SPhotoHeaderMaterial header;

  /// The status bar's height: the photo runs up behind it.
  final double top;
  final double height;
  final String backTooltip;

  @override
  double get minExtent => top + kToolbarHeight;

  @override
  double get maxExtent => top + height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final c = context.colors;
    final url = header.imageUrl;
    final onBack = header.onBack;
    final logo = header.logo;
    final discountLabel = header.discountLabel;
    final folded = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    // The bar fills in over the second half of the fold, and the photo's
    // badges are gone by the first half's end.
    final bar = ((folded - 0.5) * 2).clamp(0.0, 1.0);
    final badges = (1 - folded * 2).clamp(0.0, 1.0);
    final plain = ColoredBox(color: c.surfaceMuted);
    final onPhoto = url != null && bar < 0.5;
    // Over the photo the clock and icons are white, on a shade so they read
    // on a light picture too; on the bar they take the page's colors.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: onPhoto || c.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url == null)
            plain
          else
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              // Decoded at the height shown, not the photo's full size.
              memCacheHeight:
                  (maxExtent * MediaQuery.devicePixelRatioOf(context)).round(),
              placeholder: (_, _) => plain,
              errorWidget: (_, _, _) => plain,
            ),
          if (url != null && bar < 1)
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              height: top + kToolbarHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      c.scrim.withValues(alpha: c.scrim.a * (1 - bar) * 0.6),
                      c.scrim.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          if (bar > 0)
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface.withValues(alpha: bar),
                border: Border(
                  bottom: BorderSide(color: c.border.withValues(alpha: bar)),
                ),
              ),
            ),
          if (badges > 0 && (logo != null || discountLabel != null))
            PositionedDirectional(
              start: Space.lg,
              end: Space.lg,
              bottom: Space.md,
              child: Opacity(
                opacity: badges,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: Space.sm,
                  children: [
                    if (logo != null)
                      SLogoMaterial(logo.url, storeName: logo.storeName),
                    const Spacer(),
                    if (discountLabel != null)
                      SBadgeMaterial(discountLabel, tone: BadgeTone.discount),
                  ],
                ),
              ),
            ),
          PositionedDirectional(
            top: top,
            start: 0,
            end: 0,
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: Row(
                spacing: Space.md,
                children: [
                  if (onBack != null)
                    RoundPhotoButton(
                      icon: SIcons.chevronBack,
                      tooltip: backTooltip,
                      onPressed: onBack,
                      lift: 1 - bar,
                    ),
                  // Built only once it shows, so the page's own title is
                  // the one screen readers and finders meet first.
                  if (bar > 0)
                    Expanded(
                      child: Opacity(
                        opacity: bar,
                        child: _BarTitle(
                          title: header.title,
                          subtitle: header.subtitle,
                        ),
                      ),
                    ),
                  if (bar > 0 && header.trailing != null)
                    Opacity(opacity: bar, child: header.trailing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_PhotoHeaderDelegate old) =>
      old.header != header ||
      old.top != top ||
      old.height != height ||
      old.backTooltip != backTooltip;
}

/// The folded bar's words: the title, and the subtitle under it in a
/// smaller, quieter line.
class _BarTitle extends StatelessWidget {
  const _BarTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final subtitle = this.subtitle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: text.subtitle,
            fontWeight: SFontWeight.bold.value,
            color: c.text,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: text.small, color: c.textMuted),
          ),
      ],
    );
  }
}

/// A white circle on a photo, so the icon reads on any picture. [lift]
/// (0 to 1) is how much of its shadow shows: none once it sits on a plain
/// bar.
class RoundPhotoButton extends StatelessWidget {
  const RoundPhotoButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.lift = 1,
    super.key,
  });

  static const _size = 44.0;
  static const _shadowBlur = 12.0;

  final SIcons icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double lift;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (lift > 0)
            BoxShadow(
              color: c.shadow.withValues(alpha: c.shadow.a * lift),
              blurRadius: _shadowBlur,
            ),
        ],
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
