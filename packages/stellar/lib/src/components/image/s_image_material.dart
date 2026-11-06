import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_image.dart';

/// [SImage], loaded and kept with `cached_network_image`.
class SImageMaterial extends StatelessWidget implements SImage {
  const SImageMaterial(this.url, {this.size = SImageSize.thumb, super.key})
    : ratio = null,
      corners = SImageCorners.all;

  const SImageMaterial.wide(
    this.url, {
    SImageRatio this.ratio = SImageRatio.banner,
    this.corners = SImageCorners.all,
    super.key,
  }) : size = SImageSize.thumb;

  final String? url;
  final SImageSize size;
  final SImageCorners corners;

  /// Set for a wide picture, which [size] doesn't apply to.
  final SImageRatio? ratio;

  /// A banner's corners: rounder than a thumbnail's, as bigger pictures get.
  static const _wideRadius = Radii.xl;

  @override
  Widget build(BuildContext context) {
    final ratio = this.ratio;
    if (ratio == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size.radius),
        child: SizedBox.square(
          dimension: size.pixels,
          child: _Picture(url: url, width: size.pixels),
        ),
      );
    }
    return ClipRRect(
      borderRadius: switch (corners) {
        SImageCorners.all => BorderRadius.circular(_wideRadius),
        SImageCorners.top => const BorderRadius.vertical(
          top: Radius.circular(_wideRadius),
        ),
      },
      child: AspectRatio(
        aspectRatio: ratio.value,
        child: LayoutBuilder(
          builder: (context, box) => _Picture(url: url, width: box.maxWidth),
        ),
      ),
    );
  }
}

/// The photo at [url], decoded at the [width] shown, not its full size.
class _Picture extends StatelessWidget {
  const _Picture({required this.url, required this.width});

  final String? url;
  final double width;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    const placeholder = _Placeholder();
    if (url == null) return placeholder;
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      memCacheWidth: (width * MediaQuery.devicePixelRatioOf(context)).round(),
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.fieldFill,
    child: Center(
      child: Icon(
        materialIcon(SIcons.image),
        size: SIconSize.lg.pixels,
        color: context.colors.textSubtle,
      ),
    ),
  );
}
