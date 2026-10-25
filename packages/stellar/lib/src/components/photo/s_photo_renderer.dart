import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class PhotoFieldSpec {
  const PhotoFieldSpec({
    required this.url,
    required this.preview,
    required this.progress,
    required this.failed,
    required this.onTap,
  });

  final String? url;
  final Uint8List? preview;
  final double? progress;
  final bool failed;
  final VoidCallback onTap;
}

abstract interface class PhotoRenderer {
  Widget field(BuildContext context, PhotoFieldSpec spec);
}
