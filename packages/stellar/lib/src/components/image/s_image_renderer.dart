import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

@immutable
class ImageSpec {
  const ImageSpec({required this.url, required this.size});

  /// Null when there's no picture yet: a placeholder shows instead.
  final String? url;
  final SImageSize size;
}

abstract interface class ImageRenderer {
  Widget render(BuildContext context, ImageSpec spec);
}
