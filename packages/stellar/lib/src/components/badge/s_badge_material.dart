import 'package:flutter/widgets.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_badge.dart';

/// [SBadge], drawn as a tinted pill.
class SBadgeMaterial extends StatelessWidget implements SBadge {
  const SBadgeMaterial(this.label, {this.tone = BadgeTone.neutral, super.key});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = badgeColors(context.colors, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          fontSize: context.style.text.tiny,
          fontWeight: SFontWeight.medium.value,
          color: fg,
        ),
      ),
    );
  }
}

/// A [tone]'s text and background colors.
(Color, Color) badgeColors(StellarColors c, BadgeTone tone) => switch (tone) {
  BadgeTone.success => (c.success, c.successSoft),
  BadgeTone.warning => (c.warning, c.warningSoft),
  BadgeTone.danger => (c.danger, c.dangerSoft),
  // A shade darker than a hovered row, so it stays visible there.
  BadgeTone.neutral => (c.textMuted, c.border),
  BadgeTone.accent => (c.onAccent, c.accent),
};
