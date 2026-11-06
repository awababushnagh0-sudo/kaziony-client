import 'package:flutter/widgets.dart';

import 's_badge_material.dart';

/// What a badge says at a glance, by its colors.
enum BadgeTone {
  success,
  warning,
  danger,
  neutral,

  /// The brand's orange, solid.
  accent,

  /// The brand's green, solid: a tag on a card's photo (an offer card's
  /// discount).
  brand,

  /// A discount ("44% off") over a photo: the discount's orange gradient,
  /// bold and a size up, the first thing seen.
  discount,

  /// Words over a photo ("2 left"): on white, so they read on any photo.
  onPhoto,

  /// [onPhoto] in orange: running out.
  onPhotoHot,
}

/// The edge of a photo a badge sits flush against, like a tag on it.
enum BadgeEdge {
  /// The start edge (the right in Arabic).
  start,

  /// The end edge.
  end,
}

/// A small rounded status label, like ERPNext's indicator pills.
abstract interface class SBadge implements Widget {
  /// [label] in the colors of its [tone] (neutral by default). With
  /// [edge], it's square on that side, to sit flush against a photo's edge
  /// (an offer card's "2 left"), small and bold.
  const factory SBadge(
    String label, {
    BadgeTone tone,
    BadgeEdge? edge,
    Key? key,
  }) = SBadgeMaterial;
}
