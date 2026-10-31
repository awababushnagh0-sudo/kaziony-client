import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The shape of a photo field.
enum PhotoFieldShape {
  /// As wide as the page: an item's photo, a cover photo.
  wide,

  /// A circle: a logo.
  round,
}

@immutable
class PhotoFieldSpec {
  const PhotoFieldSpec({
    required this.url,
    required this.preview,
    required this.progress,
    required this.failed,
    required this.onTap,
    required this.shape,
    required this.addLabel,
    required this.hint,
  });

  final String? url;
  final Uint8List? preview;
  final double? progress;
  final bool failed;
  final VoidCallback? onTap;
  final PhotoFieldShape shape;
  final String? addLabel;
  final String? hint;
}

abstract interface class PhotoRenderer {
  Widget field(BuildContext context, PhotoFieldSpec spec);
}
