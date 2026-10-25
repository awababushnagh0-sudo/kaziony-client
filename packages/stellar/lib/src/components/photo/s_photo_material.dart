import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../image/s_image_material.dart';
import '../image/s_image_renderer.dart';
import 's_photo_renderer.dart';

class MaterialPhotoRenderer implements PhotoRenderer {
  const MaterialPhotoRenderer();

  @override
  Widget field(BuildContext context, PhotoFieldSpec spec) {
    final c = context.colors;
    final s = StellarLocalizations.of(context);
    const size = SImageSize.large;
    final progress = spec.progress;
    final uploading = progress != null;
    final preview = spec.preview;
    final hasPhoto = preview != null || spec.url != null;
    final label = uploading
        ? s.photoUploading((progress * 100).round())
        : spec.failed
        ? s.photoUploadFailed
        : hasPhoto
        ? s.changePhoto
        : s.addPhoto;
    final radius = BorderRadius.circular(Radii.lg);

    final picture = SizedBox.square(
      dimension: size.pixels,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: radius,
            child: preview != null
                ? Image.memory(preview, fit: BoxFit.cover)
                : const MaterialImageRenderer().render(
                    context,
                    ImageSpec(url: spec.url, size: size),
                  ),
          ),
          // Dimmed, with the progress or a retry, while it isn't the photo
          // on the server yet.
          if (uploading || spec.failed)
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.text.withValues(alpha: 0.45),
                borderRadius: radius,
              ),
              child: Center(
                child: uploading
                    ? CircularProgressIndicator(
                        value: progress,
                        color: c.surface,
                        backgroundColor: c.surface.withValues(alpha: 0.3),
                      )
                    : Icon(
                        materialIcon(SIcons.refresh),
                        size: SIconSize.lg.pixels,
                        color: c.surface,
                      ),
              ),
            )
          else
            PositionedDirectional(
              end: Space.sm,
              bottom: Space.sm,
              child: CircleAvatar(
                radius: SIconSize.lg.pixels * 0.75,
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                child: Icon(
                  materialIcon(SIcons.camera),
                  size: SIconSize.md.pixels,
                ),
              ),
            ),
        ],
      ),
    );

    // The picture and the line under it are one button.
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: uploading ? null : spec.onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(Space.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              picture,
              const Gap(Space.sm),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.style.text.small,
                  color: spec.failed ? c.danger : c.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
