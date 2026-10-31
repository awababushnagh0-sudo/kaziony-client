import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration_material.dart';
import '../illustration/s_illustration_renderer.dart';
import 's_profile_renderer.dart';

class MaterialProfileRenderer implements ProfileRenderer {
  const MaterialProfileRenderer();

  @override
  Widget header(BuildContext context, ProfileHeaderSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final subtitle = spec.subtitle;
    final badge = spec.badge;
    final phone = spec.phone;
    final url = spec.imageUrl;
    const avatar = SIllustrations.avatar;
    final placeholder = const MaterialIllustrationRenderer().render(
      context,
      const IllustrationSpec(illustration: avatar),
    );
    return Row(
      spacing: Space.lg,
      children: [
        if (url == null)
          placeholder
        else
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              width: avatar.size.width,
              height: avatar.size.height,
              fit: BoxFit.cover,
              memCacheHeight:
                  (avatar.size.height * MediaQuery.devicePixelRatioOf(context))
                      .round(),
              placeholder: (_, _) => placeholder,
              errorWidget: (_, _, _) => placeholder,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xs,
            children: [
              Text(
                spec.title,
                style: TextStyle(
                  fontSize: text.title,
                  fontWeight: SFontWeight.bold.value,
                  height: 1.3,
                  color: c.text,
                ),
              ),
              if (badge != null || subtitle != null)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  children: [
                    if (badge != null)
                      const MaterialBadgeRenderer().render(
                        context,
                        badge,
                        spec.badgeTone,
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: text.body,
                          fontWeight: SFontWeight.medium.value,
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
              if (phone != null)
                Text(
                  // "091 000 0001" keeps its order in Arabic.
                  '\u2066$phone\u2069',
                  style: TextStyle(fontSize: text.small, color: c.textSubtle),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget shortcuts(BuildContext context, List<Shortcut> shortcuts) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Space.sm,
    children: [for (final shortcut in shortcuts) _ShortcutRow(shortcut)],
  );
}

/// A row bigger than a settings row, so it stands apart from them: gray
/// instead of outlined, with a picture, a name in bold, what's inside and
/// an arrow.
class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow(this.shortcut);

  final Shortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final hint = shortcut.hint;
    return Material(
      color: c.fieldFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: shortcut.onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.md,
            Space.md,
            Space.lg,
            Space.md,
          ),
          child: Row(
            spacing: Space.md,
            children: [
              SizedBox.fromSize(
                size: shortcut.illustration.size,
                child: const MaterialIllustrationRenderer().render(
                  context,
                  IllustrationSpec(illustration: shortcut.illustration),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    Text(
                      shortcut.label,
                      style: TextStyle(
                        fontSize: text.subtitle,
                        fontWeight: SFontWeight.bold.value,
                        color: c.text,
                      ),
                    ),
                    if (hint != null)
                      Text(
                        hint,
                        style: TextStyle(
                          fontSize: text.small,
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                materialIcon(SIcons.chevron),
                size: SIconSize.sm.pixels,
                color: c.textSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
