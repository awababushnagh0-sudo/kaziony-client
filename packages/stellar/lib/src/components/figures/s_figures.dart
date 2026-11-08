import 'package:flutter/widgets.dart';

import 's_figures_material.dart';

/// One number in an [SFigures] row.
@immutable
class Figure {
  const Figure({
    required this.value,
    required this.label,
    this.hint,
    this.quiet = false,
    this.onTap,
  });

  /// Already written for people (a count).
  final String value;
  final String label;

  /// A quiet line under [label].
  final String? hint;

  /// Grays the number, when there's nothing to count.
  final bool quiet;

  /// Opens the list behind the number.
  final VoidCallback? onTap;
}

/// A page's few numbers side by side in a raised card, each number over
/// what it counts and its hint (today's pickups and no-shows at the foot
/// of an `SBand`).
abstract interface class SFigures implements Widget {
  const factory SFigures(List<Figure> figures, {Key? key}) = SFiguresMaterial;
}
