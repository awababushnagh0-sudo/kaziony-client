import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../input/s_select_input.dart';
import 's_segmented.dart';
import 's_segmented_material.dart' show segmentSlide;

/// [SSegmented.labels], drawn as a [SegmentTrack].
class SSegmentedLabelsMaterial<T> extends StatelessWidget
    implements SSegmented<T> {
  const SSegmentedLabelsMaterial({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<SelectOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => SegmentTrack(
    labels: [for (final option in options) option.label],
    chosen: options.indexWhere((o) => o.value == selected),
    onTap: (i) => onChanged(options[i].value),
  );
}

/// A few words side by side on a gray pill, as wide as it's given, as
/// [InkWell]s; the [chosen] one's white pill slides under it from the last
/// one. Drawn for [SSegmented.labels] and a form's segmented choice.
class SegmentTrack extends StatelessWidget {
  const SegmentTrack({
    required this.labels,
    required this.chosen,
    required this.onTap,
    super.key,
  });

  final List<String> labels;

  /// The index of the chosen label, -1 for none.
  final int chosen;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = context.style;
    final radius = BorderRadius.circular(Radii.pill);
    return DecoratedBox(
      decoration: BoxDecoration(color: c.fieldFill, borderRadius: radius),
      child: Padding(
        padding: const EdgeInsets.all(Space.xxs),
        child: SizedBox(
          height: style.controlHeight - Space.xs,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth / labels.length;
              return Stack(
                children: [
                  if (chosen >= 0)
                    AnimatedPositionedDirectional(
                      duration: segmentSlide,
                      curve: Curves.easeOutCubic,
                      start: chosen * width,
                      top: 0,
                      bottom: 0,
                      width: width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: radius,
                          boxShadow: [
                            BoxShadow(color: c.shadow, blurRadius: 3),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      for (final (i, label) in labels.indexed)
                        Expanded(
                          child: Semantics(
                            button: true,
                            selected: i == chosen,
                            inMutuallyExclusiveGroup: true,
                            child: InkWell(
                              borderRadius: radius,
                              onTap: () => onTap(i),
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: segmentSlide,
                                  style: TextStyle(
                                    fontFamily: stellarFont,
                                    fontSize: style.text.small,
                                    fontWeight: SFontWeight.semibold.value,
                                    color: i == chosen ? c.text : c.textMuted,
                                  ),
                                  child: Text(
                                    label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
