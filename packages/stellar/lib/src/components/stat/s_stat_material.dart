import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration_material.dart';
import '../illustration/s_illustration_renderer.dart';
import 's_stat_renderer.dart';

class MaterialStatRenderer implements StatRenderer {
  const MaterialStatRenderer();

  static const _minHeight = 92.0;

  @override
  Widget tile(BuildContext context, StatTileSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final hint = spec.hint;
    // On the grid's panel, which sets it apart: no shadow or border.
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: spec.onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minHeight),
          child: Padding(
            // The picture has air of its own, so less room on its side.
            padding: const EdgeInsetsDirectional.fromSTEB(
              Space.md,
              Space.md,
              Space.sm,
              Space.md,
            ),
            child: Row(
              spacing: Space.xs,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        spec.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: text.tiny,
                          fontWeight: SFontWeight.semibold.value,
                          color: c.textMuted,
                        ),
                      ),
                      Text(
                        spec.value,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: text.display,
                          fontWeight: SFontWeight.bold.value,
                          height: 1.2,
                          color: c.text,
                        ),
                      ),
                      if (hint != null)
                        Text(
                          hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: text.tiny,
                            fontWeight: spec.urgent
                                ? SFontWeight.semibold.value
                                : null,
                            color: spec.urgent ? c.accentInk : c.textSubtle,
                          ),
                        ),
                    ],
                  ),
                ),
                const MaterialIllustrationRenderer().render(
                  context,
                  IllustrationSpec(illustration: spec.illustration),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget grid(BuildContext context, StatGridSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final title = spec.title;
    final note = spec.note;
    final tiles = spec.children;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.resolve(spec.color),
        borderRadius: BorderRadius.circular(Radii.xxl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.sm,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  Space.sm,
                  Space.xs,
                  Space.sm,
                  Space.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: text.title,
                        fontWeight: SFontWeight.bold.value,
                        height: 1.3,
                        color: c.text,
                      ),
                    ),
                    if (note != null)
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: text.small,
                          fontWeight: SFontWeight.medium.value,
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            for (var i = 0; i < tiles.length; i += 2)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: Space.sm,
                  children: [
                    Expanded(child: tiles[i]),
                    Expanded(
                      child: i + 1 < tiles.length
                          ? tiles[i + 1]
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget figures(BuildContext context, FiguresSpec spec) {
    final c = context.colors;
    final title = spec.title;
    final strip = spec.look == FiguresLook.strip;
    final row = IntrinsicHeight(
      child: Row(
        children: [
          for (final (index, figure) in spec.figures.indexed) ...[
            if (index > 0) VerticalDivider(color: c.border),
            Expanded(child: _Figure(figure, inline: strip)),
          ],
        ],
      ),
    );
    if (strip) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.sm,
            vertical: Space.lg,
          ),
          child: row,
        ),
      );
    }
    return ColoredBox(
      color: c.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.sm,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: context.style.text.small,
                    fontWeight: SFontWeight.semibold.value,
                    color: c.textMuted,
                  ),
                ),
              ),
            row,
          ],
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure(this.figure, {required this.inline});

  final Figure figure;

  /// Icon, number and words on one line; otherwise the number over the
  /// words.
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final icon = figure.icon;
    final value = Text(
      figure.value,
      maxLines: 1,
      style: TextStyle(
        fontSize: inline ? text.subtitle : text.title,
        fontWeight: SFontWeight.bold.value,
        color: c.text,
      ),
    );
    final label = Flexible(
      child: Text(
        figure.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: text.small, color: c.textMuted),
      ),
    );
    if (!inline) {
      return MergeSemantics(
        child: Column(
          children: [
            value,
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [label]),
          ],
        ),
      );
    }
    return MergeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Space.xs,
        children: [
          if (icon != null)
            Icon(
              materialIcon(icon),
              size: SIconSize.sm.pixels,
              color: c.textSubtle,
            ),
          value,
          label,
        ],
      ),
    );
  }
}
