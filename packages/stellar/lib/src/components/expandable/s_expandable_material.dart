import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge.dart';
import '../badge/s_badge_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import '../illustration/s_illustration_material.dart';
import 's_expandable.dart';

const _turn = Duration(milliseconds: 200);

/// [SExpandable]: an outlined [Material] with an [InkWell] row, the
/// [child] sliding open and shut under a line.
class SExpandableMaterial extends StatefulWidget implements SExpandable {
  const SExpandableMaterial({
    required this.title,
    required this.child,
    this.subtitle,
    this.tag,
    this.icon,
    this.illustration,
    this.initiallyOpen = false,
    super.key,
  });

  final String title;
  final Widget child;
  final String? subtitle;
  final String? tag;
  final SIcons? icon;
  final Illustration? illustration;
  final bool initiallyOpen;

  @override
  State<SExpandableMaterial> createState() => _SExpandableMaterialState();
}

class _SExpandableMaterialState extends State<SExpandableMaterial> {
  late var _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final icon = widget.icon;
    final illustration = widget.illustration;
    final subtitle = widget.subtitle;
    final tag = widget.tag;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
        side: BorderSide(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            expanded: _open,
            button: true,
            child: InkWell(
              onTap: () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Row(
                  spacing: Space.md,
                  children: [
                    if (illustration != null)
                      SIllustrationMaterial(illustration)
                    else if (icon != null)
                      Icon(
                        materialIcon(icon),
                        size: SIconSize.md.pixels,
                        color: c.text,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Space.xxs,
                        children: [
                          Text(
                            widget.title,
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
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: _turn,
                      child: Icon(
                        materialIcon(SIcons.chevronDown),
                        size: SIconSize.sm.pixels,
                        color: c.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: _turn,
              curve: Curves.easeOut,
              alignment: AlignmentDirectional.topStart,
              child: _open
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Divider(height: 1, color: c.border),
                        widget.child,
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
