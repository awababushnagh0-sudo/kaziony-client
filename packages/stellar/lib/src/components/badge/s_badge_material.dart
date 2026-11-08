import 'package:flutter/widgets.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_badge.dart';

/// [SBadge], drawn as a tinted pill.
class SBadgeMaterial extends StatelessWidget implements SBadge {
  const SBadgeMaterial(
    this.label, {
    this.tone = BadgeTone.neutral,
    this.edge,
    this.size = BadgeSize.regular,
    super.key,
  });

  final String label;
  final BadgeTone tone;
  final BadgeEdge? edge;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final discount = tone == BadgeTone.discount;
    // A discount floating on a photo is the first thing seen; as a tag on
    // a card's photo edge it's as small as the tags beside it.
    final big = size == BadgeSize.large || (discount && edge == null);
    final (fg, bg) = badgeColors(c, tone);
    return Container(
      padding: big
          ? const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs)
          : const EdgeInsets.symmetric(
              horizontal: Space.sm,
              vertical: Space.xxs,
            ),
      decoration: BoxDecoration(
        color: discount ? null : bg,
        gradient: discount ? discountGradient(c) : null,
        borderRadius: switch (edge) {
          null => BorderRadius.circular(Radii.pill),
          BadgeEdge.start => const BorderRadiusDirectional.horizontal(
            end: Radius.circular(Radii.pill),
          ),
          BadgeEdge.end => const BorderRadiusDirectional.horizontal(
            start: Radius.circular(Radii.pill),
          ),
        },
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          fontSize: big ? text.small : text.tiny,
          fontWeight: switch (tone) {
            _ when edge != null || big => SFontWeight.bold.value,
            BadgeTone.discount ||
            BadgeTone.onPhoto ||
            BadgeTone.onPhotoHot => SFontWeight.bold.value,
            _ => SFontWeight.medium.value,
          },
          color: fg,
        ),
      ),
    );
  }
}

/// [SBadge.dot], drawn as a small circle and a [Text].
class SBadgeDotMaterial extends StatelessWidget implements SBadge {
  const SBadgeDotMaterial(
    this.label, {
    this.tone = BadgeTone.neutral,
    super.key,
  });

  final String label;
  final BadgeTone tone;

  static const _dot = 8.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (word, dot) = switch (tone) {
      BadgeTone.success => (c.link, c.link),
      BadgeTone.warning => (c.accentInk, c.accent),
      BadgeTone.danger => (c.danger, c.danger),
      _ => (c.textSubtle, c.textSubtle),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Space.xs,
      children: [
        Container(
          width: _dot,
          height: _dot,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.style.text.tiny,
              fontWeight: SFontWeight.semibold.value,
              color: word,
            ),
          ),
        ),
      ],
    );
  }
}

/// [SBadge.status], drawn as a dot and a [Text] in a white pill.
class SBadgeStatusMaterial extends StatelessWidget implements SBadge {
  const SBadgeStatusMaterial(
    this.label, {
    this.tone = BadgeTone.neutral,
    super.key,
  });

  static const _dot = 8.0;

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (ink, _) = badgeColors(c, tone);
    // The solid orange tone's text is white: on white, the orange itself.
    final color = tone == BadgeTone.accent ? c.accent : ink;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.xs,
          children: [
            SizedBox.square(
              dimension: _dot,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: context.style.text.small,
                fontWeight: SFontWeight.bold.value,
                color: color,
              ),
            ),
          ],
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
  BadgeTone.brand => (c.onPrimary, c.primary),
  BadgeTone.discount => (c.onDiscount, c.discountTo),
  BadgeTone.onPhoto => (c.text, c.surface),
  BadgeTone.onPhotoHot => (c.accentInk, c.surface),
};

/// The discount's colors, from one corner to the other.
LinearGradient discountGradient(StellarColors c) => LinearGradient(
  begin: AlignmentDirectional.topStart,
  end: AlignmentDirectional.bottomEnd,
  colors: [c.discountFrom, c.discountTo],
);
