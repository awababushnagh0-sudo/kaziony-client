import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../image/s_image_material.dart';
import '../image/s_image_renderer.dart';
import 's_item_summary_renderer.dart';

class MaterialItemSummaryRenderer implements ItemSummaryRenderer {
  const MaterialItemSummaryRenderer();

  static const _dimmedOpacity = 0.5;

  @override
  Widget render(BuildContext context, ItemSummarySpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final badge = spec.badge;
    final note = spec.note;
    final picture = const MaterialImageRenderer().render(
      context,
      ImageSpec(url: spec.imageUrl, size: SImageSize.thumb),
    );
    return Row(
      spacing: Space.md,
      children: [
        if (spec.dimmed)
          Opacity(opacity: _dimmedOpacity, child: picture)
        else
          picture,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xs,
            children: [
              Text(
                spec.title,
                style: TextStyle(
                  fontSize: text.subtitle,
                  fontWeight: SFontWeight.bold.value,
                  color: spec.dimmed ? c.textMuted : c.text,
                ),
              ),
              if (badge != null || note != null)
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ?badge,
                    if (note != null)
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: text.small,
                          color: c.textSubtle,
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
