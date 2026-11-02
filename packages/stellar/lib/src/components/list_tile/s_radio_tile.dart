import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_list_tile_material.dart';

/// One choice of a few, as a card: an icon or a short [mark] in a circle,
/// the [title] and [subtitle], and a check when [selected] or an empty ring
/// when not. [SRadioGroup] lays out a set of them and keeps one chosen.
abstract interface class SRadioTile implements Widget {
  /// [mark] is a letter or two in the circle instead of an icon ("ع",
  /// "En"): an icon or a mark, not both.
  const factory SRadioTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    String? subtitle,
    SIcons? icon,
    String? mark,
    Key? key,
  }) = SRadioTileMaterial;
}
