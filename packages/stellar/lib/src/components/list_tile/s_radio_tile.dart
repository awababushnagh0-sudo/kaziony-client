import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_list_tile_material.dart';

/// One choice of a few, as a card: an icon or a short [mark] on its own,
/// the [title] and [subtitle], and a check when [selected] or an empty ring
/// when not. [SRadioGroup] lays out a set of them and keeps one chosen.
abstract interface class SRadioTile implements Widget {
  /// [mark] is a letter or two in place of an icon ("ع",
  /// "En"): an icon or a mark, not both. With neither, the check leads,
  /// before the title. [onEdit] and [onDelete] add a pencil and a bin at
  /// the end, to change or take away the choice itself (a saved place).
  const factory SRadioTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    String? subtitle,
    SIcons? icon,
    String? mark,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    Key? key,
  }) = SRadioTileMaterial;
}
