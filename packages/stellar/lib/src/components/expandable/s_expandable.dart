import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import '../illustration/s_illustration.dart';
import 's_expandable_material.dart';

/// A box that opens to show more inside it, and closes again: a list that
/// can run long (a store's branches) kept to one row until asked for. An
/// outlined card, like the other things that can be tapped, its chevron
/// turning as it opens.
abstract interface class SExpandable implements Widget {
  /// [child] shows under the row, inside the box, while it's open; its
  /// rows (`SListTile`s) run to the box's sides.
  ///
  /// At the row's start, an [illustration] (a small picture, at its own
  /// size) or else an [icon]. [tag] is a short word in a soft green pill
  /// before the [subtitle], what matters most in it ("Closest").
  const factory SExpandable({
    required String title,
    required Widget child,
    String? subtitle,
    String? tag,
    SIcons? icon,
    Illustration? illustration,
    bool initiallyOpen,
    Key? key,
  }) = SExpandableMaterial;
}
