import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_tag_renderer.dart';

class MaterialTagRenderer implements TagRenderer {
  const MaterialTagRenderer();

  @override
  Widget render(BuildContext context, TagSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final caption = spec.caption;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: Space.xxs,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: spec.hot ? c.accentSoft : c.fieldFill,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: Space.xxs,
            ),
            child: Text(
              spec.label,
              maxLines: 1,
              style: TextStyle(
                fontSize: text.small,
                fontWeight: SFontWeight.bold.value,
                color: spec.hot ? c.accentInk : c.text,
              ),
            ),
          ),
        ),
        if (caption != null)
          Text(
            caption,
            maxLines: 1,
            style: TextStyle(fontSize: text.tiny, color: c.textSubtle),
          ),
      ],
    );
  }
}
