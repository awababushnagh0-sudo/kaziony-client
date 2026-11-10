import 'package:flutter/widgets.dart';

import 's_figure_material.dart';

/// One number at the end of a card's row, big enough to read at a glance,
/// over the words for what it counts ("2" over "left of 10").
abstract interface class SFigure implements Widget {
  /// [hot] turns the number orange: running out. [quiet] grays it: it no
  /// longer moves (paused, over).
  const factory SFigure(
    String value, {
    required String label,
    bool hot,
    bool quiet,
    Key? key,
  }) = SFigureMaterial;
}
