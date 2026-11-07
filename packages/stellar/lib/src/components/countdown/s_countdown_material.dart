import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import 's_countdown.dart';

/// [SCountdown], drawn as two lines of text.
class SCountdownMaterial extends StatelessWidget implements SCountdown {
  const SCountdownMaterial({
    required this.label,
    required this.time,
    required this.left,
    required this.total,
    super.key,
  });

  final String label;
  final String time;
  final Duration left;
  final Duration total;

  /// The share of the time left under which it reads as running out.
  static const _urgent = 0.2;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final share = total <= Duration.zero
        ? 0.0
        : (left.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    return Semantics(
      label: '$label $time',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.xs,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: text.small, color: c.textMuted),
          ),
          Text(
            time,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: text.hero,
              fontWeight: SFontWeight.bold.value,
              height: 1.1,
              // Figures of one width, so the time doesn't jiggle as it
              // counts down.
              fontFeatures: const [FontFeature.tabularFigures()],
              color: share < _urgent ? c.danger : c.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// [SCountdown.strip], drawn as a rounded [DecoratedBox] with the time in
/// a pill of the surface's color.
class SCountdownStripMaterial extends StatelessWidget implements SCountdown {
  const SCountdownStripMaterial({
    required this.label,
    required this.detail,
    this.time,
    this.urgent = false,
    super.key,
  });

  final String label;
  final String detail;
  final String? time;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final ink = urgent ? SColor.danger : SColor.primary;
    final time = this.time;
    return Semantics(
      label: [label, detail, ?time].join(' '),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: urgent ? c.dangerSoft : c.primarySoft,
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Row(
            spacing: Space.sm,
            children: [
              SIcon(SIcons.clock, color: ink),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: text.small,
                        color: c.textMuted,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: text.body,
                        fontWeight: SFontWeight.semibold.value,
                        color: c.text,
                      ),
                    ),
                  ],
                ),
              ),
              if (time != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.md,
                      vertical: Space.xs,
                    ),
                    child: Text(
                      time,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: text.title,
                        fontWeight: SFontWeight.bold.value,
                        height: 1.2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: c.resolve(ink),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
