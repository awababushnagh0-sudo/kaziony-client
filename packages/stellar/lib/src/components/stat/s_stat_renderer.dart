import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import '../illustration/s_illustration_renderer.dart';

/// One of a store's numbers: what it counts, the number, and a line about it.
@immutable
class StatTileSpec {
  const StatTileSpec({
    required this.label,
    required this.value,
    required this.illustration,
    this.hint,
    this.urgent = false,
    this.onTap,
  });

  final String label;

  /// Already written for people (a count).
  final String value;
  final SIllustrations illustration;
  final String? hint;

  /// Shows [hint] in orange: something to act on soon.
  final bool urgent;
  final VoidCallback? onTap;
}

/// One number in an [FiguresSpec] row.
@immutable
class Figure {
  const Figure({required this.value, required this.label, this.icon});

  /// Already written for people (a count).
  final String value;
  final String label;

  /// Before [label]: what it counts.
  final SIcons? icon;
}

/// How an [FiguresSpec] row is drawn.
enum FiguresLook {
  /// Its own box, each figure on one line: icon, number, what it counts.
  strip,

  /// The quiet bottom of an [SListGroup], each number over what it counts.
  footer,
}

/// A few numbers side by side, under an optional [title].
@immutable
class FiguresSpec {
  const FiguresSpec({required this.figures, required this.look, this.title});

  final List<Figure> figures;
  final FiguresLook look;
  final String? title;
}

abstract interface class StatRenderer {
  Widget tile(BuildContext context, StatTileSpec spec);

  Widget figures(BuildContext context, FiguresSpec spec);
}
