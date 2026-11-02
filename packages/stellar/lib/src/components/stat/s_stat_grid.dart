import 'package:flutter/widgets.dart';

import '../../foundation/tokens/s_colors.dart';
import 's_stat_material.dart';

/// A store's numbers ([SStatTile]s) together on one soft panel, two to a
/// row, each row as tall as its tallest tile, under a [title] and a [note]
/// (the day they're for).
abstract interface class SStatGrid implements Widget {
  /// [color] is the panel behind the tiles: a quiet gray unless set.
  const factory SStatGrid({
    required List<Widget> children,
    String? title,
    String? note,
    SColor color,
    Key? key,
  }) = SStatGridMaterial;
}
