import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

/// [SStatTile]s two to a row, each row as tall as its tallest tile.
class SStatGrid extends StatelessWidget {
  const SStatGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    spacing: Space.sm,
    children: [
      for (var i = 0; i < children.length; i += 2)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.sm,
            children: [
              Expanded(child: children[i]),
              Expanded(
                child: i + 1 < children.length
                    ? children[i + 1]
                    : const SizedBox(),
              ),
            ],
          ),
        ),
    ],
  );
}
