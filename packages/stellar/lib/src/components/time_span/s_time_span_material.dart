import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../material/s_dashed_line.dart';
import 's_time_span_renderer.dart';

class MaterialTimeSpanRenderer implements TimeSpanRenderer {
  const MaterialTimeSpanRenderer();

  static const _dot = 8.0;

  /// The most of the width each end takes; the line gets the rest.
  static const _pointShare = 0.38;

  @override
  Widget render(BuildContext context, TimeSpanSpec spec) {
    final c = context.colors;
    final length = spec.length;
    Widget dot(Color color) => SizedBox.square(
      dimension: _dot,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          Widget point(TimePoint point, CrossAxisAlignment alignment) =>
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * _pointShare,
                ),
                child: _Point(point, alignment: alignment),
              );
          return Row(
            spacing: Space.md,
            children: [
              point(spec.start, CrossAxisAlignment.start),
              Expanded(
                child: Column(
                  spacing: Space.xs,
                  children: [
                    if (length != null)
                      Text(
                        length,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.style.text.tiny,
                          color: c.textMuted,
                        ),
                      ),
                    Row(
                      children: [
                        dot(c.primary),
                        Expanded(child: DashedLine(color: c.border)),
                        dot(c.accent),
                      ],
                    ),
                  ],
                ),
              ),
              point(spec.end, CrossAxisAlignment.end),
            ],
          );
        },
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.point, {required this.alignment});

  final TimePoint point;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final note = point.note;
    final muted = TextStyle(fontSize: text.small, color: c.textMuted);
    // A long day wraps toward the line.
    final align = alignment == CrossAxisAlignment.end
        ? TextAlign.end
        : TextAlign.start;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(point.label, style: muted),
          Text(
            point.time,
            style: TextStyle(
              fontSize: text.title,
              fontWeight: SFontWeight.bold.value,
              color: c.text,
            ),
          ),
          if (note != null) Text(note, textAlign: align, style: muted),
        ],
      ),
    );
  }
}
