import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_photo_renderer.dart';

/// A record's photo on its page, with a camera badge to add or change it.
/// While it uploads it shows [preview] (the new photo, from the phone) and
/// the [progress]; if the upload [failed], tapping retries.
class SPhotoField extends StatelessWidget {
  const SPhotoField({
    required this.onTap,
    this.url,
    this.preview,
    this.progress,
    this.failed = false,
    super.key,
  });

  /// The photo on the server, if there's one.
  final String? url;

  /// The photo being uploaded, shown instead of [url].
  final Uint8List? preview;

  /// From 0 to 1 while uploading; null otherwise.
  final double? progress;
  final bool failed;

  /// Adds or changes the photo, or retries a failed upload. Ignored while
  /// uploading.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).photo.field(
    context,
    PhotoFieldSpec(
      url: url,
      preview: preview,
      progress: progress,
      failed: failed,
      onTap: onTap,
    ),
  );
}
