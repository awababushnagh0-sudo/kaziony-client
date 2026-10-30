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
    final active = c.resolve(spec.activeColor);
    // Light words on a dark fill, dark words on a light one, in either
    // theme.
    final (light, dark) = c.brightness == Brightness.light
        ? (c.surface, c.text)
        : (c.text, c.surface);
    final onActive =
        ThemeData.estimateBrightnessForColor(active) == Brightness.dark
        ? light
        : dark;
    final fg = spec.selected ? onActive : c.textMuted;
    final content = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      // Outlined on the page's surface; the chosen one filled.
      decoration: BoxDecoration(
        color: spec.selected ? active : c.surface,
        border: Border.all(color: spec.selected ? active : c.border),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            spec.label,
            style: TextStyle(
              color: fg,
              fontSize: context.style.text.small,
              fontWeight: SFontWeight.semibold.value,
            ),
          ),
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
        borderRadius: BorderRadius.circular(Radii.pill),
        onTap: spec.onTap,
        child: content,
      ),
    );
  }
}
