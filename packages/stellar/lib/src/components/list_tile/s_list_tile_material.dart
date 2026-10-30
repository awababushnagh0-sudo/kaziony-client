import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_list_tile_renderer.dart';

const _radioHeight = 56.0;
const _leadingSize = 40.0;
const _checkSize = 22.0;

// A little air between a code's characters, so it's easy to read out.
const _codeSpacing = 0.6;

class MaterialListTileRenderer implements ListTileRenderer {
  const MaterialListTileRenderer();

  @override
  Widget render(BuildContext context, ListTileSpec spec) {
    final colors = context.colors;
    final value = spec.value;
    final trailing =
        spec.trailing ??
        (value == null && spec.onTap == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                spacing: Space.xs,
                children: [
                  if (value != null)
                    Text(
                      value,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: context.style.text.small,
                      ),
                    ),
                  if (spec.onTap != null)
                    Icon(
                      materialIcon(SIcons.chevron),
                      size: SIconSize.sm.pixels,
                      color: colors.textSubtle,
                    ),
                ],
              ));
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg),
      // The icon alone, in the words' color: a box around it only adds
      // noise to a list.
      leading:
          spec.leading ??
          (spec.icon == null
              ? null
              : Icon(
                  materialIcon(spec.icon!),
                  size: SIconSize.md.pixels,
                  color: colors.text,
                )),
      title: Text(spec.title),
      subtitle: _subtitle(context, spec),
      isThreeLine: spec.subtitle != null && spec.code != null,
      trailing: trailing,
      onTap: spec.onTap,
    );
  }

  Widget? _subtitle(BuildContext context, ListTileSpec spec) {
    final subtitle = spec.subtitle;
    final code = spec.code;
    if (code == null) return subtitle == null ? null : Text(subtitle);
    final codeText = Text(
      // Isolated left to right, so "R3TW 8KQN" keeps its order in Arabic.
      '\u2066$code\u2069',
      style: TextStyle(
        fontSize: context.style.text.tiny,
        fontWeight: SFontWeight.medium.value,
        letterSpacing: _codeSpacing,
        color: context.colors.textSubtle,
      ),
    );
    if (subtitle == null) return codeText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Space.xxs,
      children: [Text(subtitle), codeText],
    );
  }

  @override
  Widget group(BuildContext context, ListGroupSpec spec) {
    final colors = context.colors;
    final title = spec.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Space.xs,
              bottom: Space.sm,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: context.style.text.small,
                fontWeight: SFontWeight.semibold.value,
              ),
            ),
          ),
        if (spec.separated)
          Column(
            spacing: Space.sm,
            children: [
              for (final child in spec.children)
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: ListTileTheme.merge(
                    shape: const RoundedRectangleBorder(),
                    // A little taller than in a box: each is a card.
                    minVerticalPadding: Space.md,
                    child: child,
                  ),
                ),
            ],
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            // Square rows: the box rounds the corners.
            child: ListTileTheme.merge(
              shape: const RoundedRectangleBorder(),
              child: Column(
                children: [
                  for (final (index, child) in spec.children.indexed) ...[
                    if (index > 0) const Divider(indent: Space.lg),
                    child,
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget fact(BuildContext context, FactTileSpec spec) {
    final c = context.colors;
    final body = context.style.text.body;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.md,
        ),
        child: Row(
          spacing: Space.md,
          children: [
            Expanded(
              child: Text(
                spec.label,
                style: TextStyle(fontSize: body, color: c.textMuted),
              ),
            ),
            Text(
              spec.value,
              style: TextStyle(
                fontSize: body,
                fontWeight: SFontWeight.bold.value,
                color: c.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget radio(BuildContext context, RadioTileSpec spec) =>
      _RadioCard(spec: spec);
}

/// A white card per choice: the chosen one outlined in the brand's green,
/// with a filled check; the others with an empty ring, so each reads as one
/// of a set.
class _RadioCard extends StatelessWidget {
  const _RadioCard({required this.spec});

  final RadioTileSpec spec;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final selected = spec.selected;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.xl),
      side: selected
          ? BorderSide(color: c.primary, width: 1.5)
          : BorderSide(color: c.border),
    );
    // Read as one item: its title, subtitle and whether it's chosen.
    return MergeSemantics(
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        button: true,
        child: Material(
          color: c.surface,
          shape: shape,
          child: InkWell(
            customBorder: shape,
            onTap: spec.onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _radioHeight),
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Row(
                  children: [
                    if (spec.icon != null || spec.mark != null) ...[
                      _RadioLeading(spec: spec),
                      const Gap(Space.md),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spec.title,
                            style: TextStyle(
                              fontSize: text.body,
                              fontWeight: SFontWeight.semibold.value,
                              color: c.text,
                            ),
                          ),
                          if (spec.subtitle case final subtitle?)
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: text.small,
                                color: c.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(Space.md),
                    _RadioCheck(selected: selected),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The choice's icon or mark in a circle, green when it's the chosen one.
class _RadioLeading extends StatelessWidget {
  const _RadioLeading({required this.spec});

  final RadioTileSpec spec;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = spec.selected ? c.onPrimary : c.text;
    return Container(
      width: _leadingSize,
      height: _leadingSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: spec.selected ? c.primary : c.fieldFill,
        shape: BoxShape.circle,
      ),
      child: switch (spec) {
        RadioTileSpec(:final icon?) => Icon(
          materialIcon(icon),
          size: SIconSize.md.pixels,
          color: color,
        ),
        _ => Text(
          spec.mark ?? '',
          maxLines: 1,
          style: TextStyle(
            fontSize: context.style.text.body,
            fontWeight: SFontWeight.bold.value,
            color: color,
          ),
        ),
      },
    );
  }
}

/// A filled check on the chosen card, an empty ring on the others.
class _RadioCheck extends StatelessWidget {
  const _RadioCheck({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: _checkSize,
      height: _checkSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? c.primary : null,
        border: selected ? null : Border.all(color: c.border, width: 1.5),
      ),
      child: selected
          ? Icon(
              materialIcon(SIcons.check),
              size: SIconSize.xs.pixels,
              color: c.onPrimary,
            )
          : null,
    );
  }
}
