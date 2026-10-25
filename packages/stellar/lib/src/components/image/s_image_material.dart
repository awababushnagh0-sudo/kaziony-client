import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_image_renderer.dart';

class MaterialImageRenderer implements ImageRenderer {
  const MaterialImageRenderer();

  @override
  Widget render(BuildContext context, ImageSpec spec) {
    final side = spec.size.pixels;
    final url = spec.url;
    const placeholder = _Placeholder();
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.md),
      child: SizedBox.square(
        dimension: side,
        child: url == null
            ? placeholder
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                // Decoded at the size shown, not the photo's full size.
                memCacheWidth: (side * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.fieldFill,
    child: Center(
      child: Icon(
        materialIcon(SIcons.image),
        size: SIconSize.lg.pixels,
        color: context.colors.textSubtle,
      ),
    ),
  );
}
