import 'package:flutter/widgets.dart';

import 's_item_summary_material.dart';

/// What a code is for at a counter, when there's nothing to hand over: the
/// product's picture and name, its state and a note under it.
abstract interface class SItemSummary implements Widget {
  /// [badge] is its state, before [note] (an `SBadge`). [dimmed] grays it:
  /// nothing to hand over (already picked up, expired).
  const factory SItemSummary({
    required String title,
    String? imageUrl,
    Widget? badge,
    String? note,
    bool dimmed,
    Key? key,
  }) = SItemSummaryMaterial;
}
