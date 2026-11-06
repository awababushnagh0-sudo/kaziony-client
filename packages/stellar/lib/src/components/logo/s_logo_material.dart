import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_logo.dart';

/// [SLogo], clipped round on a shadowed plate.
class SLogoMaterial extends StatelessWidget implements SLogo {
  const SLogoMaterial(this.url, {required this.storeName, super.key});

  final String? url;
  final String storeName;

  /// How much of the photo shows through the plate.
  static const _plateOpacity = 0.8;
  static const _shadowBlur = 8.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final url = this.url;
    final side = SImageSize.logoOnPhoto.pixels;
    final fallback = ColoredBox(
      color: c.primarySoft,
      child: Icon(
        materialIcon(SIcons.store),
        size: SIconSize.sm.pixels,
        color: c.primary,
      ),
    );
    return Semantics(
      label: storeName,
      image: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface.withValues(alpha: _plateOpacity),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: c.shadow, blurRadius: _shadowBlur)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.xs),
          child: ClipOval(
            child: SizedBox.square(
              dimension: side,
              child: url == null
                  ? fallback
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      memCacheWidth:
                          (side * MediaQuery.devicePixelRatioOf(context))
                              .round(),
                      placeholder: (_, _) => fallback,
                      errorWidget: (_, _, _) => fallback,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
