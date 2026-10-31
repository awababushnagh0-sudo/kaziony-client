import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/tokens/s_colors.dart';
import 's_stat_renderer.dart';

/// A store's numbers ([SStatTile]s) together on one soft panel, two to a
/// row, under a [title] and a [note] (the day they're for).
class SStatGrid extends StatelessWidget {
  const SStatGrid({
    required this.children,
    this.title,
    this.note,
    this.color = SColor.fieldFill,
    super.key,
  });

  final String? title;

  /// Under [title], quieter.
  final String? note;
  final List<Widget> children;

  /// The panel behind the tiles: a quiet gray unless set.
  final SColor color;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).stat.grid(
    context,
    StatGridSpec(title: title, note: note, color: color, children: children),
  );
}
