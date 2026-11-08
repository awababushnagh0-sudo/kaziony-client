import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_timeline.dart';

/// [STimeline], its rows drawn as [InkWell]s, so the whole row opens.
class STimelineMaterial extends StatelessWidget implements STimeline {
  const STimelineMaterial(this.entries, {super.key});

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, entry) in entries.indexed)
        _Row(entry, first: index == 0, last: index == entries.length - 1),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row(this.entry, {required this.first, required this.last});

  final TimelineEntry entry;
  final bool first;
  final bool last;

  /// Room for "12:45" in its bold figures.
  static const _timeWidth = 52.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final subtitle = entry.subtitle;
    final period = entry.period;
    final trailing = entry.trailing;
    return InkWell(
      onTap: entry.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        // The rail needs the row's height, to reach the next dot.
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.sm,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.sm),
                child: SizedBox(
                  width: _timeWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        entry.time,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: text.body,
                          fontWeight: SFontWeight.bold.value,
                          color: entry.hot ? c.accentInk : c.text,
                        ),
                      ),
                      if (period != null)
                        Text(
                          period,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: text.tiny,
                            color: c.textSubtle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              _Rail(hot: entry.hot, first: first, last: last),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: text.body,
                          fontWeight: SFontWeight.bold.value,
                          color: c.text,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: text.small,
                            color: c.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.sm),
                  child: Align(alignment: Alignment.topCenter, child: trailing),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The dot, level with the time's first line, and the line to the stops
/// before and after it.
class _Rail extends StatelessWidget {
  const _Rail({required this.hot, required this.first, required this.last});

  final bool hot;
  final bool first;
  final bool last;

  static const _width = 16.0;
  static const _dot = 10.0;
  static const _lineWidth = 2.0;

  /// From the row's top to the dot.
  static const _aboveDot = 15.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final line = ColoredBox(
      color: c.border,
      child: const SizedBox(width: _lineWidth),
    );
    return SizedBox(
      width: _width,
      child: Column(
        children: [
          SizedBox(height: _aboveDot, child: first ? null : line),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xxs),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: hot ? c.accent : c.primary,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(dimension: _dot),
            ),
          ),
          Expanded(child: last ? const SizedBox.shrink() : line),
        ],
      ),
    );
  }
}
