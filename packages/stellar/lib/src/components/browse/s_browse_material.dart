import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import '../illustration/s_illustration_material.dart';
import 's_browse.dart';

/// [SPlaceHeader], drawn as an [InkWell] row.
class SPlaceHeaderMaterial extends StatelessWidget implements SPlaceHeader {
  const SPlaceHeaderMaterial({
    required this.caption,
    required this.place,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final String caption;
  final String place;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final trailing = this.trailing;
    return Row(
      spacing: Space.md,
      children: [
        Flexible(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: Space.sm,
                children: [
                  Icon(
                    materialIcon(SIcons.location),
                    size: SIconSize.lg.pixels,
                    color: c.primary,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caption,
                          style: TextStyle(
                            fontSize: text.small,
                            color: c.textMuted,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: Space.xs,
                          children: [
                            Flexible(
                              child: Text(
                                place,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: text.body,
                                  fontWeight: SFontWeight.bold.value,
                                  color: c.text,
                                ),
                              ),
                            ),
                            Icon(
                              materialIcon(SIcons.chevronDown),
                              size: SIconSize.xs.pixels,
                              color: c.text,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// [SCategoryStrip], drawn as a sideways [SingleChildScrollView] at least
/// the screen's width.
class SCategoryStripMaterial extends StatelessWidget implements SCategoryStrip {
  const SCategoryStripMaterial({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  static const _pictureSize = 64.0;
  static const _choiceWidth = 84.0;
  static const _underlineWidth = 24.0;
  static const _underlineHeight = 3.0;

  final List<CategoryChoice> choices;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    // At least as wide as the screen, so a few choices sit in the middle
    // and many still scroll.
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.sm),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: box.maxWidth - 2 * Space.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, choice) in choices.indexed)
                Semantics(
                  selected: i == selected,
                  button: true,
                  child: InkWell(
                    onTap: () => onSelected(i),
                    borderRadius: BorderRadius.circular(Radii.lg),
                    child: SizedBox(
                      width: _choiceWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Space.xs),
                        child: Column(
                          spacing: Space.xs,
                          children: [
                            SizedBox.square(
                              dimension: _pictureSize,
                              child: _Picture(choice),
                            ),
                            Text(
                              choice.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: text.small,
                                fontWeight: i == selected
                                    ? SFontWeight.bold.value
                                    : SFontWeight.medium.value,
                                color: i == selected ? c.primary : c.text,
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: i == selected ? 1 : 0,
                              duration: const Duration(milliseconds: 150),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: c.primary,
                                  borderRadius: BorderRadius.circular(
                                    Radii.pill,
                                  ),
                                ),
                                child: const SizedBox(
                                  width: _underlineWidth,
                                  height: _underlineHeight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [SLogoTile], drawn as an [InkWell] column, the logo in a thin ring.
class SLogoTileMaterial extends StatelessWidget implements SLogoTile {
  const SLogoTileMaterial(
    this.url, {
    required this.name,
    required this.onTap,
    super.key,
  });

  final String? url;
  final String name;
  final VoidCallback onTap;

  /// Room for a name a little wider than the logo.
  static const _width = 80.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final url = this.url;
    final side = SImageSize.logoInRow.pixels;
    const fallback = SIllustrationMaterial(SIllustrations.avatar);
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.lg),
        child: SizedBox(
          width: _width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(
              spacing: Space.xs,
              children: [
                DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: c.border),
                  ),
                  child: ClipOval(
                    child: SizedBox.square(
                      dimension: side,
                      child: url == null
                          ? fallback
                          : CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              memCacheWidth:
                                  (side *
                                          MediaQuery.devicePixelRatioOf(
                                            context,
                                          ))
                                      .round(),
                              placeholder: (_, _) =>
                                  ColoredBox(color: c.fieldFill),
                              errorWidget: (_, _, _) => fallback,
                            ),
                    ),
                  ),
                ),
                // One line, so a long name doesn't make the whole row
                // taller than its neighbours.
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.style.text.tiny,
                    fontWeight: SFontWeight.medium.value,
                    color: c.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A kind of store's picture: one of the brand's, else its photo, else a
/// plain mark.
class _Picture extends StatelessWidget {
  const _Picture(this.choice);

  final CategoryChoice choice;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fallback = Icon(
      materialIcon(SIcons.category),
      size: SIconSize.xl.pixels,
      color: c.primary,
    );
    if (choice.illustration case final picture?) {
      return SIllustrationMaterial(picture);
    }
    if (choice.imageUrl case final url?) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      );
    }
    return fallback;
  }
}
