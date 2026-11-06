import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_deal_photo_material.dart';

/// An offer's square photo with what it saves ("50% off") on an orange tag
/// filling its top corner at the start, cut by the photo's rounding: an
/// offer beside its words in a list.
abstract interface class SDealPhoto implements Widget {
  /// [url] is null when there's no picture yet; no [discount], no tag.
  const factory SDealPhoto(
    String? url, {
    SImageSize size,
    String? discount,
    Key? key,
  }) = SDealPhotoMaterial;
}
