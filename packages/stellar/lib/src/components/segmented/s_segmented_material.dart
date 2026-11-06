import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_segmented.dart';

/// [SSegmented], drawn as [InkWell]s in a bordered pill; the chosen one
/// filled with the primary color, its icon on it in white.
class SSegmentedMaterial<T> extends StatelessWidget implements SSegmented<T> {
  const SSegmentedMaterial({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<SSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // A Material of its own: the chosen segment's fill (an Ink) is painted
    // on it, over its white; on the app bar's Material it would be hidden
    // under it.
    return Material(
      color: c.surface,
      shape: StadiumBorder(side: BorderSide(color: c.border)),
      child: Padding(
        padding: const EdgeInsets.all(Space.xxs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.xxs,
          children: [
            for (final segment in segments)
              _Segment(
                segment: segment,
                selected: segment.value == selected,
                onTap: () => onChanged(segment.value),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final SSegment<T> segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(Radii.pill);
    return Tooltip(
      message: segment.tooltip,
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: Space.sm,
            ),
            decoration: BoxDecoration(
              color: selected ? c.primary : null,
              borderRadius: radius,
            ),
            child: Icon(
              materialIcon(segment.icon),
              size: SIconSize.sm.pixels,
              color: selected ? c.onPrimary : c.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
