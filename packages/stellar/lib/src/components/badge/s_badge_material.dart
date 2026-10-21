import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_badge_renderer.dart';

class MaterialBadgeRenderer implements BadgeRenderer {
  const MaterialBadgeRenderer();

  @override
  Widget render(BuildContext context, String label, BadgeTone tone) {
    final c = context.colors;
    final (fg, bg) = switch (tone) {
      BadgeTone.success => (c.success, c.successSoft),
      BadgeTone.warning => (c.warning, c.warningSoft),
      BadgeTone.danger => (c.danger, c.dangerSoft),
      // A shade darker than a hovered row, so it stays visible there.
      BadgeTone.neutral => (c.textMuted, c.border),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}
