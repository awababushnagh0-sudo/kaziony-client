import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_photo_field.dart';

// As wide as the page and nearly as tall as the photo on the item's page,
// so the owner sees it about as customers will.
const _fieldHeight = 200.0;

/// [SPhotoField], drawn with Material's [InkWell].
class SPhotoFieldMaterial extends StatelessWidget implements SPhotoField {
  const SPhotoFieldMaterial({
    required this.onTap,
    this.shape = PhotoFieldShape.wide,
    this.addLabel,
    this.hint,
    this.url,
    this.preview,
    this.progress,
    this.failed = false,
    super.key,
  });

  final String? url;
  final Uint8List? preview;
  final double? progress;
  final bool failed;
  final VoidCallback? onTap;
  final PhotoFieldShape shape;
  final String? addLabel;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = StellarLocalizations.of(context);
    final progress = this.progress;
    final uploading = progress != null;
    final preview = this.preview;
    final url = this.url;
    final hasPhoto = preview != null || url != null;
    final onTap = this.onTap;
    final round = shape == PhotoFieldShape.round;
    final label = uploading
        ? s.photoUploading((progress * 100).round())
        : failed
        ? s.photoUploadFailed
        : hasPhoto
        ? s.changePhoto
        : addLabel ?? s.addPhoto;
    final side = SImageSize.logo.pixels;
    final height = round ? side : _fieldHeight;

    return Semantics(
      button: onTap != null,
      label: onTap == null ? null : label,
      excludeSemantics: true,
      child: Material(
        color: c.fieldFill,
        // A round one sits on a cover photo: a ring of the page's color
        // keeps it apart.
        shape: round
            ? CircleBorder(
                side: BorderSide(color: c.surface, width: _ring),
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(Radii.xl)),
              ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: uploading ? null : onTap,
          child: SizedBox(
            width: round ? side : null,
            height: height,
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
                        (height * MediaQuery.devicePixelRatioOf(context))
                            .round(),
                    errorWidget: (_, _, _) => const SizedBox.shrink(),
                  ),
                if (uploading || failed)
                  _Dimmed(
                    progress: progress,
                    // No room for words in a logo.
                    label: round ? null : label,
                    failed: failed,
                  )
                else if (onTap == null)
                  const SizedBox.shrink()
                else if (hasPhoto && !round)
                  PositionedDirectional(
                    end: Space.md,
                    bottom: Space.md,
                    child: _ChangeChip(label: label),
                  )
                else if (!hasPhoto)
                  _Empty(
                    label: label,
                    hint: round ? null : hint ?? s.addPhotoHint,
                    small: round,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _ring = Space.xs;

/// No photo yet: a camera, what to do and what makes a good one.
class _Empty extends StatelessWidget {
  const _Empty({required this.label, required this.hint, required this.small});

  final String label;
  final String? hint;

  /// In a logo: a smaller camera and label, no hint.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final hint = this.hint;
    return Padding(
      padding: const EdgeInsets.all(Space.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            materialIcon(SIcons.camera),
            size: (small ? SIconSize.md : SIconSize.lg).pixels,
            color: c.text,
          ),
          Gap(small ? Space.xs : Space.md),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: small ? text.tiny : text.body,
              fontWeight: SFontWeight.bold.value,
              color: c.text,
              height: small ? 1.2 : null,
            ),
          ),
          if (hint != null) ...[
            const Gap(Space.xxs),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: text.small, color: c.textMuted),
            ),
          ],
        ],
      ),
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

  /// Null in a logo: no room for it.
  final String? label;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final onDim = c.onScrim;
    final label = this.label;
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
            if (label != null)
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
