import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_stat_material.dart';

/// One number in an [SFigures] row.
@immutable
class Figure {
  const Figure({required this.value, required this.label, this.icon});

  /// Already written for people (a count).
  final String value;
  final String label;

  /// Before [label]: what it counts.
  final SIcons? icon;
}

/// How an [SFigures] row is drawn.
enum FiguresLook {
  /// Its own box, each figure on one line: icon, number, what it counts.
  strip,

  /// The quiet bottom of an [SListGroup], each number over what it counts.
  footer,
}

/// A few numbers about one thing side by side (an offer's views,
/// reservations and pickups): a strip of their own, or the bottom of an
/// [SListGroup] ([FiguresLook.footer]).
abstract interface class SFigures implements Widget {
  /// [title] is small, above the numbers.
  const factory SFigures(
    List<Figure> figures, {
    FiguresLook look,
    String? title,
    Key? key,
  }) = SFiguresMaterial;
}
