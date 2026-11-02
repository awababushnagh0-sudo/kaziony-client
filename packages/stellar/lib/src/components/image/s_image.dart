import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_image_material.dart';

/// A picture from the server (a product photo), square with rounded
/// corners. Kept on the device after the first load, for slow connections;
/// a placeholder shows while it loads, when it fails and when `url` is
/// null.
abstract interface class SImage implements Widget {
  /// [url] is null when there's no picture yet. [size] is a thumbnail's by
  /// default.
  const factory SImage(String? url, {SImageSize size, Key? key}) =
      SImageMaterial;
}
