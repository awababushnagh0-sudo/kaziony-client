import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_list_tile_renderer.dart';

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
}
