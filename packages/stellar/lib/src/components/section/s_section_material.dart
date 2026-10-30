import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_section_renderer.dart';

class MaterialSectionRenderer implements SectionRenderer {
  const MaterialSectionRenderer();

  @override
  Widget header(BuildContext context, SectionHeaderSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final note = spec.note;
    final actionLabel = spec.actionLabel;
    return Row(
      spacing: Space.md,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              spec.title,
              style: TextStyle(
                fontSize: text.subtitle,
                fontWeight: SFontWeight.bold.value,
                color: c.text,
              ),
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: spec.onAction,
            style: TextButton.styleFrom(
              foregroundColor: c.link,
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              minimumSize: const Size(0, 44),
            ),
            // Styled here, not in the button's style: that would replace the
            // theme's font.
            child: Text(
              actionLabel,
              style: TextStyle(
                fontSize: text.small,
                fontWeight: SFontWeight.semibold.value,
              ),
            ),
          )
        else if (note != null)
          Text(
            note,
            style: TextStyle(fontSize: text.tiny, color: c.textSubtle),
          ),
      ],
    );
  }
}
