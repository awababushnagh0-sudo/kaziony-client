import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_split_bar.dart';

/// [SSplitBar], drawn as a rounded [Row] of colors over a [Row] of words.
class SSplitBarMaterial extends StatelessWidget implements SSplitBar {
  const SSplitBarMaterial({
    required this.parts,
    this.note,
    this.faded = false,
    super.key,
  });

  final List<SplitPart> parts;
  final String? note;
  final bool faded;

  /// How much of the strong color the lighter one keeps.
  static const _underwayShare = 0.45;

  Color _color(StellarColors c, SplitTone tone) {
    final strong = faded ? c.textSubtle : c.primary;
    return switch (tone) {
      SplitTone.done => strong,
      SplitTone.underway => Color.lerp(c.surface, strong, _underwayShare)!,
      SplitTone.waiting => c.fieldFill,
      SplitTone.hot => c.accent,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final note = this.note;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        // The key below says the same in words.
        ExcludeSemantics(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.pill),
            child: ColoredBox(
              color: c.fieldFill,
              child: SizedBox(
                // Thin: a line under the words, not a block beside them.
                height: Space.sm,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: Space.xxs,
                  children: [
                    for (final part in parts)
                      if (part.count > 0)
                        Expanded(
                          flex: part.count,
                          child: ColoredBox(color: _color(c, part.tone)),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, room) => FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            // At least the full width, so the words spread across it when
            // they fit.
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: room.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: Space.sm,
                children: [
                  for (final part in parts)
                    if (part.keyed)
                      _KeyEntry(part, color: _color(c, part.tone)),
                  if (note != null)
                    Text(
                      note,
                      style: TextStyle(
                        fontSize: context.style.text.small,
                        color: c.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A part in the key: its color, its count and what it counts.
class _KeyEntry extends StatelessWidget {
  const _KeyEntry(this.part, {required this.color});

  final SplitPart part;
  final Color color;

  static const _swatch = 10.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final hot = part.tone == SplitTone.hot;
    return MergeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Space.xs,
        children: [
          Container(
            width: _swatch,
            height: _swatch,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              // Gray on the card's white needs an edge to be seen.
              border: part.tone == SplitTone.waiting
                  ? Border.all(color: c.border)
                  : null,
            ),
          ),
          Text(
            '${part.count}',
            style: TextStyle(
              fontSize: text.body,
              fontWeight: SFontWeight.bold.value,
              color: hot ? c.accentInk : c.text,
            ),
          ),
          Text(
            part.label,
            style: TextStyle(
              fontSize: text.small,
              color: hot ? c.accentInk : c.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
