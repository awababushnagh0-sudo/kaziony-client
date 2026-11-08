import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_fact_tile.dart';
import 's_list_group.dart';
import 's_list_tile.dart';
import 's_radio_tile.dart';

const _radioHeight = 56.0;
const _leadingSize = 28.0;
const _checkSize = 22.0;

// A little air between a code's characters, so it's easy to read out.
const _codeSpacing = 0.6;

/// [SListTile], drawn with Material's [ListTile].
class SListTileMaterial extends StatelessWidget implements SListTile {
  const SListTileMaterial({
    required this.title,
    this.subtitle,
    this.code,
    this.icon,
    this.leading,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// A code under [subtitle] (a pickup code), read left to right in
  /// Arabic too.
  final String? code;
  final SIcons? icon;

  /// Takes [icon]'s place, for a picture (`SImage`).
  final Widget? leading;

  /// A short value at the end of the row (the current language).
  final String? value;

  /// Replaces the arrow tappable rows get.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final value = this.value;
    final icon = this.icon;
    final trailing =
        this.trailing ??
        (value == null && onTap == null
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
                  if (onTap != null)
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
          leading ??
          (icon == null
              ? null
              : Icon(
                  materialIcon(icon),
                  size: SIconSize.md.pixels,
                  color: colors.text,
                )),
      title: Text(title),
      subtitle: _subtitle(context),
      isThreeLine: subtitle != null && code != null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget? _subtitle(BuildContext context) {
    final subtitle = this.subtitle;
    final code = this.code;
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
}

/// [SListGroup]: the rows in a Material [Card], or a card each.
class SListGroupMaterial extends StatelessWidget implements SListGroup {
  const SListGroupMaterial({
    required this.children,
    this.title,
    this.separated = false,
    super.key,
  });

  final String? title;
  final List<Widget> children;

  /// Each row its own bordered card, a little apart, instead of all in
  /// one box.
  final bool separated;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = this.title;
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
        if (separated)
          Column(
            spacing: Space.sm,
            children: [
              for (final child in children)
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
                  for (final (index, child) in children.indexed) ...[
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

/// [SFactTile]: the name and the value on one row.
class SFactTileMaterial extends StatelessWidget implements SFactTile {
  const SFactTileMaterial({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
                label,
                style: TextStyle(fontSize: body, color: c.textMuted),
              ),
            ),
            Text(
              value,
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
}

/// [SRadioTile] as a white card per choice: the chosen one outlined in the
/// brand's green, with a filled check; the others with an empty ring, so
/// each reads as one of a set. The check sits at the end after an icon or
/// a mark, and leads in their place.
class SRadioTileMaterial extends StatelessWidget implements SRadioTile {
  const SRadioTileMaterial({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.mark,
    this.onEdit,
    this.onDelete,
    super.key,
  }) : assert(icon == null || mark == null, 'An icon or a mark, not both');

  final String title;
  final String? subtitle;
  final SIcons? icon;

  /// A letter or two in place of an icon ("ع", "En").
  final String? mark;

  /// The chosen one of its group: outlined, with a check.
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final onEdit = this.onEdit;
    final onDelete = this.onDelete;
    final hasActions = onEdit != null || onDelete != null;
    final leads = icon != null || mark != null;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.xl),
      side: selected
          ? BorderSide(color: c.primary, width: 1.5)
          : BorderSide(color: c.border),
    );
    return Material(
      color: c.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            // Read as one item: its title, subtitle and whether it's
            // chosen. The pencil and the bin stay buttons of their own.
            child: MergeSemantics(
              child: Semantics(
                inMutuallyExclusiveGroup: true,
                checked: selected,
                button: true,
                child: InkWell(
                  onTap: onTap,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: _radioHeight),
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: Space.md,
                        top: Space.md,
                        bottom: Space.md,
                        end: hasActions ? Space.xs : Space.md,
                      ),
                      child: Row(
                        children: [
                          if (leads)
                            _RadioLeading(
                              icon: icon,
                              mark: mark,
                              selected: selected,
                            )
                          else
                            _RadioCheck(selected: selected),
                          const Gap(Space.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: text.body,
                                    fontWeight: SFontWeight.semibold.value,
                                    color: c.text,
                                  ),
                                ),
                                if (subtitle case final subtitle?)
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
                          if (leads) ...[
                            const Gap(Space.md),
                            _RadioCheck(selected: selected),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (onEdit != null)
            _TileAction(
              icon: SIcons.edit,
              tooltip: StellarLocalizations.of(context).edit,
              onPressed: onEdit,
            ),
          if (onDelete != null)
            _TileAction(
              icon: SIcons.delete,
              tooltip: StellarLocalizations.of(context).delete,
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

/// A quiet icon button at the end of a radio tile (edit, delete).
class _TileAction extends StatelessWidget {
  const _TileAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final SIcons icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(
      materialIcon(icon),
      size: SIconSize.sm.pixels,
      color: context.colors.textMuted,
    ),
  );
}

/// The choice's icon or mark on its own, green when it's the chosen one.
class _RadioLeading extends StatelessWidget {
  const _RadioLeading({
    required this.icon,
    required this.mark,
    required this.selected,
  });

  final SIcons? icon;
  final String? mark;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.text;
    final icon = this.icon;
    // Bare, no circle behind it; a fixed width keeps the titles in line.
    return SizedBox(
      width: _leadingSize,
      child: Center(
        child: icon != null
            ? Icon(materialIcon(icon), size: SIconSize.md.pixels, color: color)
            : Text(
                mark ?? '',
                maxLines: 1,
                style: TextStyle(
                  fontSize: context.style.text.body,
                  fontWeight: SFontWeight.bold.value,
                  color: color,
                ),
              ),
      ),
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
