import 'package:flutter/widgets.dart';

import 's_chip_material.dart';

/// A short word to tap again (a recent search): outlined like a pill, on
/// the page's surface.
abstract interface class SChip implements Widget {
  /// [onRemove] adds an × at the end that takes it away.
  const factory SChip({
    required String label,
    required VoidCallback onTap,
    VoidCallback? onRemove,
    Key? key,
  }) = SChipMaterial;
}
