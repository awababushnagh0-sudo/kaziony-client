import 'package:flutter/widgets.dart';

import 's_text_material.dart';

/// A quiet sentence that ends in a tappable [link]: "Store not on Kaziony
/// yet? Contact us".
abstract interface class SLinkText implements Widget {
  const factory SLinkText({
    required String text,
    required String link,
    required VoidCallback onTap,
    TextAlign? align,
    Key? key,
  }) = SLinkTextMaterial;
}
