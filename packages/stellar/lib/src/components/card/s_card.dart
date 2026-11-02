import 'package:flutter/widgets.dart';

import 's_card_material.dart';

/// A raised surface that holds a group of things together.
abstract interface class SCard implements Widget {
  /// [onTap] makes the whole card tappable; [padded] puts the standard
  /// space around [child] (false for content that runs to the edges).
  const factory SCard({
    required Widget child,
    VoidCallback? onTap,
    bool padded,
    Key? key,
  }) = SCardMaterial;
}
