import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_profile_header.dart';

/// [SProfileHeader], drawn with Material.
class SProfileHeaderMaterial extends StatelessWidget implements SProfileHeader {
  const SProfileHeaderMaterial({
    required this.title,
    this.subtitle,
    this.role,
    this.phone,
    this.imageUrl,
    super.key,
  });

  final String title;
  final String? subtitle;
  final ProfileRole? role;

  /// Already written for people (`formatLibyanPhone`); read left to right
  /// in Arabic too.
  final String? phone;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final subtitle = this.subtitle;
    final role = this.role;
    final phone = this.phone;
    final url = imageUrl;
    const avatar = SIllustrations.avatar;
    const placeholder = SIllustration(avatar);
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
                title,
                style: TextStyle(
                  fontSize: text.title,
                  fontWeight: SFontWeight.bold.value,
                  height: 1.3,
                  color: c.text,
                ),
              ),
              if (role != null || subtitle != null)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  children: [
                    if (role != null) _RoleTag(role),
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
}

/// [SShortcuts], drawn with Material.
class SShortcutsMaterial extends StatelessWidget implements SShortcuts {
  const SShortcutsMaterial(this.shortcuts, {super.key});

  final List<Shortcut> shortcuts;

  @override
  Widget build(BuildContext context) => Column(
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
                child: SIllustration(shortcut.illustration),
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

/// The person's role as a small pill: its icon and name. The lead's is the brand's green, a gradient with a
/// faint sparkle in its corner; the others' a quiet gray.
class _RoleTag extends StatelessWidget {
  const _RoleTag(this.role);

  static const _sparkleSize = 26.0;

  final ProfileRole role;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final lead = role.lead;
    final ink = lead ? c.onBrand : c.textMuted;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.pill),
        color: lead ? null : c.fieldFill,
        gradient: lead
            ? LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [c.brandFrom, c.brandTo],
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.pill),
        child: Stack(
          children: [
            if (lead)
              PositionedDirectional(
                end: -Space.xs,
                top: -Space.xs,
                child: Icon(
                  materialIcon(SIcons.sparkles),
                  size: _sparkleSize,
                  color: c.onBrand.withValues(alpha: 0.18),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.md,
                vertical: Space.xxs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: Space.xs,
                children: [
                  Icon(
                    materialIcon(role.icon),
                    size: SIconSize.xs.pixels,
                    color: ink,
                  ),
                  Text(
                    role.label,
                    style: TextStyle(
                      fontSize: context.style.text.small,
                      fontWeight: SFontWeight.bold.value,
                      color: lead ? c.onBrand : c.text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
