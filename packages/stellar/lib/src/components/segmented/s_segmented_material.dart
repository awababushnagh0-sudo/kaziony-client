import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_segmented.dart';

/// How long the chosen segment's pill takes to slide to the next one; the
/// segmented choice of a form slides the same.
const segmentSlide = Duration(milliseconds: 220);

/// [SSegmented], drawn as [InkWell]s in a bordered pill; the chosen one's
/// green pill slides under it from the last one, its icon turning white.
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

  /// A segment's size: its icon with room around it.
  static final _width = SIconSize.sm.pixels + Space.md * 2;
  static final _height = SIconSize.sm.pixels + Space.sm * 2;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final chosen = segments.indexWhere((s) => s.value == selected);
    final radius = BorderRadius.circular(Radii.pill);
    // A Material of its own: the segments' ripples show on it, over its
    // white; on the app bar's Material they would be hidden under it.
    return Material(
      color: c.surface,
      shape: StadiumBorder(side: BorderSide(color: c.border)),
      child: Padding(
        padding: const EdgeInsets.all(Space.xxs),
        child: SizedBox(
          width: _width * segments.length + Space.xxs * (segments.length - 1),
          height: _height,
          child: Stack(
            children: [
              if (chosen >= 0)
                AnimatedPositionedDirectional(
                  duration: segmentSlide,
                  curve: Curves.easeOutCubic,
                  start: chosen * (_width + Space.xxs),
                  top: 0,
                  bottom: 0,
                  width: _width,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.primary,
                      borderRadius: radius,
                    ),
                  ),
                ),
              Row(
                spacing: Space.xxs,
                children: [
                  for (final (i, segment) in segments.indexed)
                    Tooltip(
                      message: segment.tooltip,
                      child: Semantics(
                        button: true,
                        selected: i == chosen,
                        child: InkWell(
                          onTap: () => onChanged(segment.value),
                          borderRadius: radius,
                          child: SizedBox(
                            width: _width,
                            height: _height,
                            child: Center(
                              child: TweenAnimationBuilder<Color?>(
                                duration: segmentSlide,
                                tween: ColorTween(
                                  end: i == chosen ? c.onPrimary : c.textMuted,
                                ),
                                builder: (context, color, _) => Icon(
                                  materialIcon(segment.icon),
                                  size: SIconSize.sm.pixels,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
