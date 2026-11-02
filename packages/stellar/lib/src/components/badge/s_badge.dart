import 'package:flutter/widgets.dart';

import 's_badge_material.dart';

/// What a badge says at a glance, by its colors.
enum BadgeTone {
  success,
  warning,
  danger,
  neutral,

  /// The brand's orange, solid: discounts.
  accent,
}

/// A small rounded status label, like ERPNext's indicator pills.
abstract interface class SBadge implements Widget {
  /// [label] in the colors of its [tone] (neutral by default).
  const factory SBadge(String label, {BadgeTone tone, Key? key}) =
      SBadgeMaterial;
}
