import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/tokens/s_radii.dart';
import '../../foundation/tokens/s_spacing.dart';
import '../../foundation/tokens/s_typography.dart';
import 's_bar_chart.dart';

/// Tall enough to tell bars apart, short enough to sit over a table.
const _chartHeight = Space.xxl * 5;

/// [SBarChart], drawn as a row of rounded bars over a baseline.
class SBarChartMaterial extends StatelessWidget implements SBarChart {
  const SBarChartMaterial({
    required this.bars,
    required this.summary,
    this.startLabel,
    this.endLabel,
    super.key,
  });

  final List<ChartBar> bars;
  final String summary;
  final String? startLabel;
  final String? endLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tallest = bars.fold(0.0, (top, bar) => math.max(top, bar.value));
    final labelStyle = TextStyle(
      fontSize: context.style.text.tiny,
      fontWeight: SFontWeight.medium.value,
      color: c.textMuted,
    );
    return Semantics(
      label: summary,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _chartHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final bar in bars)
                    Expanded(
                      child: _Bar(bar: bar, tallest: tallest),
                    ),
                ],
              ),
            ),
            Container(height: 1, color: c.border),
            if (startLabel != null || endLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: Space.xs),
                child: Row(
                  children: [
                    Text(startLabel ?? '', style: labelStyle),
                    const Spacer(),
                    Text(endLabel ?? '', style: labelStyle),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.bar, required this.tallest});

  final ChartBar bar;
  final double tallest;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final share = tallest <= 0 ? 0.0 : bar.value / tallest;
    final alertShare = bar.value <= 0
        ? 0.0
        : (bar.alert / bar.value).clamp(0.0, 1.0);
    final drawn = LayoutBuilder(
      builder: (context, constraints) {
        // A bar with anything in it shows, however small next to the rest.
        final height = bar.value <= 0
            ? 0.0
            : math.max(constraints.maxHeight * share, Space.xxs);
        final alertHeight = height * alertShare;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xxs / 2),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Radii.sm),
              ),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(child: ColoredBox(color: c.primary)),
                    SizedBox(
                      height: alertHeight,
                      child: ColoredBox(color: c.danger),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    final label = bar.label;
    return label == null ? drawn : Tooltip(message: label, child: drawn);
  }
}
