import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_tag.dart';

/// [STag], drawn as a tinted pill over its caption.
class STagMaterial extends StatelessWidget implements STag {
  const STagMaterial(this.label, {this.caption, this.hot = false, super.key});

  final String label;
  final String? caption;
  final bool hot;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final caption = this.caption;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: Space.xxs,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: hot ? c.accentSoft : c.fieldFill,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: Space.xxs,
            ),
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: text.small,
                fontWeight: SFontWeight.bold.value,
                color: hot ? c.accentInk : c.text,
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
