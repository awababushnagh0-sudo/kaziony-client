import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge.dart';
import '../badge/s_badge_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import '../illustration/s_illustration_material.dart';

/// The outlined box of an [SExpandable] or an [SBoxTile], clipping what's
/// in it to its corners.
class BoxFrame extends StatelessWidget {
  const BoxFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
        side: BorderSide(color: c.border),
      ),
      child: child,
    );
  }
}

/// The head row both boxes share: the picture (or icon) at the start, the
/// title, the tag and subtitle under it, and [end] at the end.
class BoxHead extends StatelessWidget {
  const BoxHead({
    required this.title,
    required this.end,
    this.subtitle,
    this.tag,
    this.icon,
    this.illustration,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? tag;
  final SIcons? icon;
  final Illustration? illustration;
  final Widget end;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final icon = this.icon;
    final illustration = this.illustration;
    final subtitle = this.subtitle;
    final tag = this.tag;
    return Padding(
      padding: const EdgeInsets.all(Space.md),
      child: Row(
        spacing: Space.md,
        children: [
          if (illustration != null)
            SIllustrationMaterial(illustration)
          else if (icon != null)
            Icon(materialIcon(icon), size: SIconSize.md.pixels, color: c.text),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xxs,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: text.body,
                    fontWeight: SFontWeight.bold.value,
                    color: c.text,
                  ),
                ),
                if (tag != null || subtitle != null)
                  Wrap(
                    spacing: Space.xs,
                    runSpacing: Space.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (tag != null)
                        SBadgeMaterial(tag, tone: BadgeTone.success),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: text.small,
                            color: c.textMuted,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          end,
        ],
      ),
    );
  }
}
