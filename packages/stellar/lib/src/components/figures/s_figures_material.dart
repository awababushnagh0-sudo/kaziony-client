import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../card/s_card.dart';
import 's_figures.dart';

/// [SFigures], drawn as a raised [SCard] with dividers between the
/// numbers.
class SFiguresMaterial extends StatelessWidget implements SFigures {
  const SFiguresMaterial(this.figures, {super.key});

  final List<Figure> figures;

  @override
  Widget build(BuildContext context) => SCard.raised(
    padded: false,
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, figure) in figures.indexed) ...[
            if (index > 0)
              VerticalDivider(width: 1, color: context.colors.border),
            Expanded(child: _Figure(figure)),
          ],
        ],
      ),
    ),
  );
}

/// A figure: its number, what it counts and a quiet line under them, all
/// of it a button when there's a list behind it.
class _Figure extends StatelessWidget {
  const _Figure(this.figure);

  final Figure figure;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final hint = figure.hint;
    return InkWell(
      onTap: figure.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.sm,
          vertical: Space.md,
        ),
        child: MergeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                figure.value,
                maxLines: 1,
                style: TextStyle(
                  fontSize: text.title,
                  fontWeight: SFontWeight.bold.value,
                  color: figure.quiet ? c.textSubtle : c.text,
                ),
              ),
              Text(
                figure.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: text.tiny,
                  fontWeight: SFontWeight.semibold.value,
                  color: c.textMuted,
                ),
              ),
              if (hint != null)
                Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: text.tiny, color: c.textSubtle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
