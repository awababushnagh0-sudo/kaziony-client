import 'package:flutter/widgets.dart';

import 's_settings_material.dart';

/// What an option card shows above its label: a small picture of the app
/// window in light or dark colors, or both side by side (follow the
/// device).
enum WindowPreview { light, dark, lightAndDark }

/// Choices laid out as [SOptionCard]s, three to a row (one on narrow
/// screens), the same width in every group.
abstract interface class SOptionGrid implements Widget {
  const factory SOptionGrid({required List<Widget> children, Key? key}) =
      SOptionGridMaterial;
}

/// One choice, ERPNext-style: a picture of the app window above, the
/// [label] and a radio circle below; the chosen card has a dark border.
abstract interface class SOptionCard implements Widget {
  /// [direction] lays the preview out in that direction, not the page's.
  const factory SOptionCard({
    required String label,
    required WindowPreview preview,
    required bool selected,
    required VoidCallback onTap,
    TextDirection? direction,
    Key? key,
  }) = SOptionCardMaterial;
}
