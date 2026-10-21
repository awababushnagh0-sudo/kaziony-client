import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

/// Fields narrower than this move to the next row instead.
const _minFieldWidth = 210.0;

/// Lays out form fields in [columns] equal columns, as in ERPNext, using
/// fewer columns as the space narrows. Every field gets a column's width,
/// long ones (a description) included.
class SFieldGrid extends StatelessWidget {
  const SFieldGrid({required this.children, this.columns = 2, super.key});

  final List<Widget> children;
  final int columns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      const gap = Space.lg;
      final count = ((width + gap) / (_minFieldWidth + gap)).floor().clamp(
        1,
        columns,
      );
      final itemWidth = (width - gap * (count - 1)) / count;
      return Wrap(
        spacing: gap,
        runSpacing: Space.lg,
        children: [
          for (final child in children)
            SizedBox(width: itemWidth, child: child),
        ],
      );
    },
  );
}
