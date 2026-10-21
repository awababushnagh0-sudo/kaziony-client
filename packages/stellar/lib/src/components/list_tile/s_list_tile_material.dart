import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_list_tile_renderer.dart';

class MaterialListTileRenderer implements ListTileRenderer {
  const MaterialListTileRenderer();

  @override
  Widget render(BuildContext context, ListTileSpec spec) {
    final colors = context.colors;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg),
      leading: spec.icon == null
          ? null
          : CircleAvatar(
              backgroundColor: colors.primarySoft,
              foregroundColor: colors.primary,
              child: Icon(materialIcon(spec.icon!), size: SIconSize.md.pixels),
            ),
      title: Text(spec.title),
      subtitle: spec.subtitle == null ? null : Text(spec.subtitle!),
      trailing: spec.trailing,
      onTap: spec.onTap,
    );
  }
}
