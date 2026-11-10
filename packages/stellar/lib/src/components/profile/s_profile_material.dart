import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../material/s_color_above.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_profile_header.dart';

/// [SProfileHeader.greeting], drawn as a [DecoratedBox] reaching up under
/// the status bar, with the illustration on the band's floor.
class SProfileGreetingMaterial extends StatelessWidget
    implements SProfileHeader {
  const SProfileGreetingMaterial({
    required this.greeting,
    required this.name,
    this.subtitle,
    this.illustration,
    super.key,
  });

  final String greeting;
  final String name;
  final String? subtitle;
  final Illustration? illustration;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final subtitle = this.subtitle;
    final illustration = this.illustration;
    return ColorAbove(
      color: c.accentSoft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.accentSoft,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(Radii.band),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            Space.lg,
            MediaQuery.paddingOf(context).top + Space.xl,
            Space.sm,
            Space.lg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: Space.sm,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: text.subtitle,
                          fontWeight: SFontWeight.medium.value,
                          color: c.textMuted,
                        ),
                      ),
                      Semantics(
                        header: true,
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: text.hero,
                            fontWeight: SFontWeight.bold.value,
                            height: 1.2,
                            color: c.primary,
                          ),
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: text.body,
                            color: c.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (illustration != null) SIllustration(illustration),
            ],
          ),
        ),
      ),
    );
  }
}

/// [SShortcuts.pills], drawn as a row of outlined [InkWell]s of one width,
/// the count as a Material [Badge] on the corner.
class SShortcutPillsMaterial extends StatelessWidget implements SShortcuts {
  const SShortcutPillsMaterial(this.pills, {super.key});

  final List<ShortcutPill> pills;

  @override
  Widget build(BuildContext context) => Row(
    spacing: Space.sm,
    children: [for (final pill in pills) Expanded(child: _Pill(pill))],
  );
}

class _Pill extends StatelessWidget {
  const _Pill(this.pill);

  final ShortcutPill pill;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Badge(
      isLabelVisible: pill.count > 0,
      label: Text('${pill.count}'),
      backgroundColor: c.accent,
      textColor: c.onAccent,
      alignment: AlignmentDirectional.topEnd,
      offset: const Offset(-Space.xs, -Space.xs),
      child: Material(
        color: c.surface,
        shape: StadiumBorder(side: BorderSide(color: c.border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: pill.onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.style.controlHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: Space.xs,
                children: [
                  Icon(
                    materialIcon(pill.icon),
                    size: SIconSize.sm.pixels,
                    color: c.resolve(pill.color),
                  ),
                  Flexible(
                    child: Text(
                      pill.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: text.body,
                        fontWeight: SFontWeight.semibold.value,
                        color: c.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
