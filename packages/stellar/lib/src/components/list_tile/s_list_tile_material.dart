import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_list_tile_renderer.dart';

const _radioHeight = 56.0;
const _leadingSize = 40.0;
const _checkSize = 22.0;

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
      leading:
          spec.leading ??
          (spec.icon == null
              ? null
              : CircleAvatar(
                  backgroundColor: colors.primarySoft,
                  foregroundColor: colors.primary,
                  child: Icon(
                    materialIcon(spec.icon!),
                    size: SIconSize.md.pixels,
                  ),
                )),
      title: Text(spec.title),
      subtitle: spec.subtitle == null ? null : Text(spec.subtitle!),
      trailing: trailing,
      onTap: spec.onTap,
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
