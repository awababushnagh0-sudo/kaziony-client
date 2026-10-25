import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge_material.dart';
import '../badge/s_badge_renderer.dart';
import '../image/s_image_material.dart';
import '../image/s_image_renderer.dart';
import 's_deal_renderer.dart';

class MaterialDealRenderer implements DealRenderer {
  const MaterialDealRenderer();

  @override
  Widget tile(BuildContext context, DealTileSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final details = spec.details;
    return InkWell(
      onTap: spec.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.md,
        ),
        child: Row(
          spacing: Space.md,
          children: [
            const MaterialImageRenderer().render(
              context,
              ImageSpec(url: spec.imageUrl, size: SImageSize.thumb),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Space.xs,
                children: [
                  Text(
                    spec.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: text.body,
                      fontWeight: SFontWeight.semibold.value,
                      color: c.text,
                    ),
                  ),
                  Wrap(
                    spacing: Space.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        spec.price,
                        style: TextStyle(
                          fontSize: text.body,
                          fontWeight: SFontWeight.bold.value,
                          color: c.text,
                        ),
                      ),
                      Text(
                        spec.originalPrice,
                        style: TextStyle(
                          fontSize: text.small,
                          color: c.textSubtle,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: c.textSubtle,
                        ),
                      ),
                      const MaterialBadgeRenderer().render(
                        context,
                        // "-50%" keeps this order in Arabic too.
                        '\u2066\u2212${spec.discountPercent}%\u2069',
                        BadgeTone.accent,
                      ),
                    ],
                  ),
                  if (details != null)
                    Text(
                      details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: text.small,
                        color: c.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            ?spec.trailing,
          ],
        ),
      ),
    );
  }
}
