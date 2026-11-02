import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 's_photo_material.dart';

/// The shape of a photo field.
enum PhotoFieldShape {
  /// As wide as the page: an item's photo, a cover photo.
  wide,

  /// A circle: a logo.
  round,
}

/// A record's photo on its page, with a pill to add or change it. While it
/// uploads it shows the preview (the new photo, from the phone) and the
/// progress; if the upload failed, tapping retries.
abstract interface class SPhotoField implements Widget {
  /// [url] is the photo on the server, if there's one; [preview] is the
  /// photo being uploaded, shown instead of it. [progress] goes from 0 to 1
  /// while uploading and is null otherwise.
  ///
  /// [onTap] adds or changes the photo, or retries a failed upload. It's
  /// ignored while uploading; null shows the photo only, for those who
  /// can't change it.
  ///
  /// [addLabel] is what adding a photo says, instead of "Add a photo"
  /// ("Add your logo"). [hint] goes under it when there's no photo yet,
  /// instead of the default tip; a round field has no room for it.
  const factory SPhotoField({
    required VoidCallback? onTap,
    PhotoFieldShape shape,
    String? addLabel,
    String? hint,
    String? url,
    Uint8List? preview,
    double? progress,
    bool failed,
    Key? key,
  }) = SPhotoFieldMaterial;
}
