import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration_material.dart';
import '../illustration/s_illustration_renderer.dart';
import 's_browse_renderer.dart';

class MaterialBrowseRenderer implements BrowseRenderer {
  const MaterialBrowseRenderer();

  static const _pictureSize = 64.0;
  static const _choiceWidth = 84.0;
  static const _underlineWidth = 24.0;
  static const _underlineHeight = 3.0;

  @override
  Widget place(BuildContext context, PlaceHeaderSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final trailing = spec.trailing;
    return Row(
      spacing: Space.md,
      children: [
        Flexible(
          child: InkWell(
            onTap: spec.onTap,
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
                          spec.caption,
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
                                spec.place,
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

  @override
  Widget categories(BuildContext context, CategoryStripSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, choice) in spec.choices.indexed)
            Semantics(
              selected: i == spec.selected,
              button: true,
              child: InkWell(
                onTap: () => spec.onSelected(i),
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
                            fontWeight: i == spec.selected
                                ? SFontWeight.bold.value
                                : SFontWeight.medium.value,
                            color: i == spec.selected ? c.primary : c.text,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: i == spec.selected ? 1 : 0,
                          duration: const Duration(milliseconds: 150),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: c.primary,
                              borderRadius: BorderRadius.circular(Radii.pill),
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
    );
  }

  @override
  Widget banner(BuildContext context, PromoBannerSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final tag = spec.tag;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [c.brandFrom, c.brandTo],
        ),
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Space.xs,
          children: [
            Text(
              spec.title,
              style: TextStyle(
                fontSize: text.title,
                fontWeight: SFontWeight.bold.value,
                color: c.onBrand,
              ),
            ),
            Text(
              spec.message,
              style: TextStyle(
                fontSize: text.small,
                height: 1.6,
                color: c.onBrand.withValues(alpha: 0.85),
              ),
            ),
            if (tag != null) ...[
              const SizedBox(height: Space.xs),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: c.accent,
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.md,
                    vertical: Space.xs,
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: text.small,
                      fontWeight: SFontWeight.bold.value,
                      color: c.onAccent,
                    ),
                  ),
                ),
              ),
            ],
          ],
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
      return const MaterialIllustrationRenderer().render(
        context,
        IllustrationSpec(illustration: picture),
      );
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
