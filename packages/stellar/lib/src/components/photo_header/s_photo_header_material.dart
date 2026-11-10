import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge.dart';
import '../badge/s_badge_material.dart';
import '../button/s_button_material.dart';
import '../favorite_button/s_heart_material.dart';
import '../icon/s_icon.dart';
import 's_photo_header.dart';

/// [SPhotoHeader], drawn as a pinned [SliverPersistentHeader].
class SPhotoHeaderMaterial extends StatelessWidget implements SPhotoHeader {
  const SPhotoHeaderMaterial({
    required this.title,
    this.subtitle,
    this.trailing,
    this.caption,
    this.imageUrl,
    this.discountLabel,
    this.favorite,
    this.action,
    this.onBack,
    super.key,
  }) : assert(
         favorite == null || action == null,
         'One button across from the back button: a heart or an action.',
       );

  /// The photo's height, under the status bar.
  static const _photoHeight = 200.0;

  /// Taller with words on it, so they leave the picture room.
  static const _captionedHeight = 250.0;

  /// Without a photo: room for the bar and the discount tag under it, or
  /// for the caption.
  static const _plainHeight = 128.0;
  static const _plainCaptionedHeight = 176.0;

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? caption;
  final String? imageUrl;
  final String? discountLabel;
  final PhotoHeaderFavorite? favorite;
  final PhotoHeaderAction? action;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _PhotoHeaderDelegate(
      header: this,
      top: MediaQuery.paddingOf(context).top,
      height: switch ((imageUrl, caption)) {
        (null, null) => _plainHeight,
        (null, _) => _plainCaptionedHeight,
        (_, null) => _photoHeight,
        _ => _captionedHeight,
      },
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

  /// How solid the bar is before its words start to show.
  static const _wordsFrom = 0.8;

  /// How much of the photo, from its foot, is soft behind the caption, and
  /// how much of that fades in from the sharp photo above it.
  static const _blurShare = 0.5;
  static const _blurFade = 0.4;

  /// How wide the soft copy of the photo is decoded. Stretched back over
  /// the photo, so few pixels look blurred, with no blur drawn on any frame.
  static const _blurPixels = 32;

  /// How much of the photo, from its foot, the caption's shade covers.
  static const _shadeShare = 0.65;

  /// How dark the shade is from its top down to the photo's foot: clear,
  /// then darkening fast where the caption's words start, so the picture
  /// still shows above them.
  static const _shadeAlphas = [0.0, 0.55, 0.85];
  static const _shadeStops = [0.0, 0.5, 1.0];

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
    final favorite = header.favorite;
    final action = header.action;
    final discountLabel = header.discountLabel;
    final caption = header.caption;
    final folded = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    // The bar fills in over the second half of the fold, and the photo's
    // badges are gone by the first half's end. Its words come last, once
    // the bar is all but solid, so they never show over the photo.
    final bar = ((folded - 0.5) * 2).clamp(0.0, 1.0);
    final badges = (1 - folded * 2).clamp(0.0, 1.0);
    final words = ((bar - _wordsFrom) / (1 - _wordsFrom)).clamp(0.0, 1.0);
    // Without the photo (none, or not loaded yet), a caption's white words
    // go on the brand's green, deep in both themes.
    final plain = caption == null
        ? ColoredBox(color: c.surfaceMuted)
        : DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [c.brandFrom, c.brandTo],
              ),
            ),
          );
    final onPhoto = (url != null || caption != null) && bar < 0.5;
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
          // The photo again, decoded tiny and stretched, so it looks blurred
          // behind the caption: as cheap to draw as the photo itself, with
          // no blur filter. It fades into the sharp photo above it, and out
          // with the caption as the photo folds.
          if (url != null && caption != null && badges > 0)
            Positioned.fill(
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                // A mask: only its colors' opacity counts.
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    1 - _blurShare,
                    1 - _blurShare * (1 - _blurFade),
                  ],
                  colors: [
                    c.scrim.withValues(alpha: 0),
                    c.scrim.withValues(alpha: badges),
                  ],
                ).createShader(bounds),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  memCacheWidth: _blurPixels,
                  filterQuality: FilterQuality.medium,
                  fadeInDuration: Duration.zero,
                ),
              ),
            ),
          // The caption's shade: one plain gradient, painted in a single
          // pass on each frame of the fold (no blur, no extra layer), and
          // gone once the fold has hidden the caption. Dark enough for white
          // words on a light photo.
          if (url != null && caption != null && badges > 0)
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              height: height * _shadeShare,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: _shadeStops,
                    colors: [
                      for (final alpha in _shadeAlphas)
                        c.scrim.withValues(alpha: alpha * badges),
                    ],
                  ),
                ),
              ),
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
          if (badges > 0 && caption != null)
            PositionedDirectional(
              start: Space.lg,
              end: Space.lg,
              bottom: Space.lg,
              // Only faded while it folds: a whole opacity draws as is.
              child: badges < 1
                  ? Opacity(opacity: badges, child: caption)
                  : caption,
            ),
          // A tag against the photo's edge, in the brand's green, as on
          // the offer's card.
          if (badges > 0 && discountLabel != null)
            PositionedDirectional(
              end: 0,
              bottom: Space.lg,
              child: Opacity(
                opacity: badges,
                child: SBadgeMaterial(
                  discountLabel,
                  tone: BadgeTone.brand,
                  edge: BadgeEdge.end,
                  size: BadgeSize.large,
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
                    SGlassButtonMaterial(
                      icon: SIcons.chevronBack,
                      tooltip: backTooltip,
                      onPressed: onBack,
                      lift: 1 - bar,
                    ),
                  // Built only once it shows, so the page's own title is
                  // the one screen readers and finders meet first.
                  if (words > 0)
                    Expanded(
                      child: Opacity(
                        opacity: words,
                        child: _BarTitle(
                          title: header.title,
                          subtitle: header.subtitle,
                        ),
                      ),
                    ),
                  if (words == 0 && (favorite != null || action != null))
                    const Spacer(),
                  if (words > 0 && header.trailing != null)
                    Opacity(opacity: words, child: header.trailing),
                  if (favorite != null)
                    SGlassButtonMaterial.drawn(
                      icon: HeartMaterial(filled: favorite.saved),
                      tooltip: favorite.tooltip,
                      onPressed: favorite.onPressed,
                      selected: favorite.saved,
                      lift: 1 - bar,
                    ),
                  if (action != null)
                    SGlassButtonMaterial(
                      icon: action.icon,
                      tooltip: action.tooltip,
                      onPressed: action.onPressed,
                      lift: 1 - bar,
                    ),
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
