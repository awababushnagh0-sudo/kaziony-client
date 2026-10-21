import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_pill_renderer.dart';

class MaterialPillRenderer implements PillRenderer {
  const MaterialPillRenderer();

  @override
  Widget render(BuildContext context, PillSpec spec) {
    final c = context.colors;
    final fg = spec.selected ? c.onPrimary : c.textMuted;
    final content = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      decoration: BoxDecoration(
        color: spec.selected ? c.primary : c.fieldFill,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(spec.label, style: TextStyle(color: fg, fontSize: 13)),
          if (spec.icon != null) ...[
            const Gap(Space.xs),
            Icon(
              materialIcon(spec.icon!),
              size: SIconSize.xs.pixels,
              color: fg,
            ),
          ],
        ],
      ),
    );
    if (spec.onTap == null) return content;
    return Semantics(
      button: true,
      selected: spec.selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: spec.onTap,
        child: content,
      ),
    );
  }
}
