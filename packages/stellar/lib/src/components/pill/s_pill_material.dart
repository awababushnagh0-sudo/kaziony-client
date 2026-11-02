import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_pill.dart';

/// [SPill], drawn as an outlined or filled pill with an [InkWell].
class SPillMaterial extends StatelessWidget implements SPill {
  const SPillMaterial({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.activeColor = SColor.primary,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final SIcons? icon;
  final SColor activeColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final active = c.resolve(activeColor);
    // Light words on a dark fill, dark words on a light one, in either
    // theme.
    final (light, dark) = c.brightness == Brightness.light
        ? (c.surface, c.text)
        : (c.text, c.surface);
    final onActive =
        ThemeData.estimateBrightnessForColor(active) == Brightness.dark
        ? light
        : dark;
    final fg = selected ? onActive : c.textMuted;
    final icon = this.icon;
    final content = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      // Outlined on the page's surface; the chosen one filled.
      decoration: BoxDecoration(
        color: selected ? active : c.surface,
        border: Border.all(color: selected ? active : c.border),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: context.style.text.small,
              fontWeight: SFontWeight.semibold.value,
            ),
          ),
          if (icon != null) ...[
            const Gap(Space.xs),
            Icon(materialIcon(icon), size: SIconSize.xs.pixels, color: fg),
          ],
        ],
      ),
    );
    if (onTap == null) return content;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.pill),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
