import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_image_renderer.dart';

/// A picture from the server (a product photo), square with rounded
/// corners. Kept on the device after the first load, for slow connections;
/// a placeholder shows while it loads, when it fails and when [url] is
/// null.
class SImage extends StatelessWidget {
  const SImage(this.url, {this.size = SImageSize.thumb, super.key});

  final String? url;
  final SImageSize size;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).image
          .render(context, ImageSpec(url: url, size: size));
}
