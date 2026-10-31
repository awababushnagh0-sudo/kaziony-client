import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_photo_renderer.dart';

// As wide as the page and nearly as tall as the photo on the item's page,
// so the owner sees it about as customers will.
const _fieldHeight = 200.0;
const _cameraSize = 56.0;

class MaterialPhotoRenderer implements PhotoRenderer {
  const MaterialPhotoRenderer();

  @override
  Widget field(BuildContext context, PhotoFieldSpec spec) {
    final c = context.colors;
    final s = StellarLocalizations.of(context);
    final progress = spec.progress;
    final uploading = progress != null;
    final preview = spec.preview;
    final url = spec.url;
    final hasPhoto = preview != null || url != null;
    final label = uploading
        ? s.photoUploading((progress * 100).round())
        : spec.failed
        ? s.photoUploadFailed
        : hasPhoto
        ? s.changePhoto
        : s.addPhoto;
    const radius = BorderRadius.all(Radius.circular(Radii.xl));

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: c.fieldFill,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: uploading ? null : spec.onTap,
          child: SizedBox(
            height: _fieldHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (preview != null)
                  Image.memory(preview, fit: BoxFit.cover)
                else if (url != null)
                  CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    memCacheHeight:
                        (_fieldHeight * MediaQuery.devicePixelRatioOf(context))
                            .round(),
                    errorWidget: (_, _, _) => const SizedBox.shrink(),
                  ),
                if (uploading || spec.failed)
                  _Dimmed(progress: progress, label: label, failed: spec.failed)
                else if (hasPhoto)
                  PositionedDirectional(
                    end: Space.md,
                    bottom: Space.md,
                    child: _ChangeChip(label: label),
                  )
                else
                  _Empty(label: label, hint: s.addPhotoHint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// No photo yet: a camera in a circle, what to do and what makes a good
/// one.
class _Empty extends StatelessWidget {
  const _Empty({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: _cameraSize,
          height: _cameraSize,
          decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
          child: Icon(
            materialIcon(SIcons.camera),
            size: SIconSize.md.pixels,
            color: c.primary,
          ),
        ),
        const Gap(Space.md),
        Text(
          label,
          style: TextStyle(
            fontSize: text.body,
            fontWeight: SFontWeight.bold.value,
            color: c.text,
          ),
        ),
        const Gap(Space.xxs),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: text.small, color: c.textMuted),
        ),
      ],
    );
  }
}

/// Over a photo: a pill to change it.
class _ChangeChip extends StatelessWidget {
  const _ChangeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: c.surface,
        shape: const StadiumBorder(),
        shadows: [BoxShadow(color: c.shadow, blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.xs,
          children: [
            Icon(
              materialIcon(SIcons.camera),
              size: SIconSize.xs.pixels,
              color: c.text,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: context.style.text.small,
                fontWeight: SFontWeight.semibold.value,
                color: c.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// While it isn't the photo on the server yet: dimmed, with the progress,
/// or a retry when it failed.
class _Dimmed extends StatelessWidget {
  const _Dimmed({
    required this.progress,
    required this.label,
    required this.failed,
  });

  final double? progress;
  final String label;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final onDim = c.onScrim;
    return ColoredBox(
      color: c.scrim,
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Space.md,
          children: [
            if (failed)
              Icon(
                materialIcon(SIcons.refresh),
                size: SIconSize.lg.pixels,
                color: onDim,
              )
            else
              CircularProgressIndicator(
                value: progress,
                color: onDim,
                backgroundColor: onDim.withValues(alpha: 0.3),
              ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.style.text.small,
                fontWeight: SFontWeight.semibold.value,
                color: onDim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
