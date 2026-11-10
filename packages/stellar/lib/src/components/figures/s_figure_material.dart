import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_figure.dart';

/// [SFigure], drawn as two lines of text read as one.
class SFigureMaterial extends StatelessWidget implements SFigure {
  const SFigureMaterial(
    this.value, {
    required this.label,
    this.hot = false,
    this.quiet = false,
    super.key,
  });

  final String value;
  final String label;
  final bool hot;
  final bool quiet;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: text.title,
              fontWeight: SFontWeight.bold.value,
              // The words under it sit close.
              height: 1.2,
              color: hot
                  ? c.accentInk
                  : quiet
                  ? c.textSubtle
                  : c.text,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            style: TextStyle(fontSize: text.tiny, color: c.textMuted),
          ),
        ],
      ),
    );
  }
}
