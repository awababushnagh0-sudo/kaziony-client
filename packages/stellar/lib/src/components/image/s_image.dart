import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_image_material.dart';

/// Which corners of an [SImage.wide] are rounded.
enum SImageCorners {
  /// All four: a picture on its own.
  all,

  /// The top two: a picture at the top of a card, with the card's words
  /// right under it.
  top,
}

/// A picture from the server (a product photo) with rounded corners. Kept
/// on the device after the first load, for slow connections; a placeholder
/// shows while it loads, when it fails and when `url` is null.
abstract interface class SImage implements Widget {
  /// Square. [url] is null when there's no picture yet. [size] is a
  /// thumbnail's by default.
  const factory SImage(String? url, {SImageSize size, Key? key}) =
      SImageMaterial;

  /// As wide as the space given, as tall as its [ratio] makes it: a banner
  /// (an offer's photo on its card), rounded at its [corners]. With no
  /// photo yet, [missing] asks for one ("Add a photo") under a camera,
  /// instead of the plain placeholder: for the one who can add it.
  const factory SImage.wide(
    String? url, {
    SImageRatio ratio,
    SImageCorners corners,
    String? missing,
    Key? key,
  }) = SImageMaterial.wide;
}
