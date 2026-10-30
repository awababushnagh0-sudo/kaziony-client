import 'package:flutter/widgets.dart';

/// What a code is for: its picture, name and state.
@immutable
class ItemSummarySpec {
  const ItemSummarySpec({
    required this.title,
    this.imageUrl,
    this.badge,
    this.note,
    this.dimmed = false,
  });

  final String title;
  final String? imageUrl;

  /// Its state, before [note] (an `SBadge`).
  final Widget? badge;
  final String? note;

  /// Grayed: nothing to hand over.
  final bool dimmed;
}

abstract interface class ItemSummaryRenderer {
  Widget render(BuildContext context, ItemSummarySpec spec);
}
