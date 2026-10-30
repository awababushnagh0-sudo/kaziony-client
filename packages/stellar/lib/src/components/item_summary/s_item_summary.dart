import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_item_summary_renderer.dart';

/// What a code is for at a counter, when there's nothing to hand over: the
/// product's picture and name, its state and a note under it.
class SItemSummary extends StatelessWidget {
  const SItemSummary({
    required this.title,
    this.imageUrl,
    this.badge,
    this.note,
    this.dimmed = false,
    super.key,
  });

  final String title;
  final String? imageUrl;

  /// Its state, before [note] (an `SBadge`).
  final Widget? badge;
  final String? note;

  /// Grayed: nothing to hand over (already picked up, expired).
  final bool dimmed;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).itemSummary.render(
        context,
        ItemSummarySpec(
          title: title,
          imageUrl: imageUrl,
          badge: badge,
          note: note,
          dimmed: dimmed,
        ),
      );
}
