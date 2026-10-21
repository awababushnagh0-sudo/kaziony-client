import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

/// Lays out form fields in [columns] equal columns, dropping to one as the
/// space narrows.
class SFieldGrid extends StatelessWidget {
  const SFieldGrid({required this.children, this.columns = 2, super.key});

  final List<Widget> children;
  final int columns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final count = width < 440 ? 1 : columns;
      const gap = Space.lg;
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
