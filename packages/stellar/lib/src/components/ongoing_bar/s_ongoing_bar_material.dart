import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_ongoing_bar.dart';

/// [SOngoingBar], drawn as a [GestureDetector] on a rounded dark
/// [Material].
class SOngoingBarMaterial extends StatelessWidget implements SOngoingBar {
  const SOngoingBarMaterial({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.imageUrl,
    this.trailing,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final String? imageUrl;
  final String? trailing;

  static const _pictureSize = 40.0;
  static const _shadowBlur = 16.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final subtitle = this.subtitle;
    final trailing = this.trailing;
    final url = imageUrl;
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
        borderRadius: BorderRadius.circular(Radii.lg),
        boxShadow: [BoxShadow(color: c.shadow, blurRadius: _shadowBlur)],
      ),
      child: Semantics(
        button: true,
        child: Material(
          color: c.inverseSurface,
          borderRadius: BorderRadius.circular(Radii.lg),
          clipBehavior: Clip.antiAlias,
          // No ripple, as on the kinds of store.
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Row(
                spacing: Space.md,
                children: [
                  ClipOval(
                    child: SizedBox.square(
                      dimension: _pictureSize,
                      child: url == null
                          ? fallback
                          : CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              memCacheWidth:
                                  (_pictureSize *
                                          MediaQuery.devicePixelRatioOf(
                                            context,
                                          ))
                                      .round(),
                              placeholder: (_, _) => fallback,
                              errorWidget: (_, _, _) => fallback,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: text.small,
                            fontWeight: SFontWeight.bold.value,
                            color: c.onInverse,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: text.tiny,
                              color: c.onInverseMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null)
                    Text(
                      trailing,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: text.subtitle,
                        fontWeight: SFontWeight.bold.value,
                        // Figures of one width, so a countdown doesn't
                        // jiggle.
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: c.onInverseAccent,
                      ),
                    ),
                  Icon(
                    materialIcon(SIcons.chevron),
                    size: SIconSize.sm.pixels,
                    color: c.onInverseMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
