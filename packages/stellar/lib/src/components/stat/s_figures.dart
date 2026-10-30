import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_stat_renderer.dart';

/// A few numbers about one thing side by side (an offer's views,
/// reservations and pickups): a strip of their own, or the bottom of an
/// [SListGroup] ([FiguresLook.footer]).
class SFigures extends StatelessWidget {
  const SFigures(
    this.figures, {
    this.look = FiguresLook.strip,
    this.title,
    super.key,
  });

  final List<Figure> figures;
  final FiguresLook look;

  /// Small, above the numbers.
  final String? title;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).stat.figures(
    context,
    FiguresSpec(figures: figures, look: look, title: title),
  );
}
