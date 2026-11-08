import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../card/s_card.dart';
import '../icon/s_icon.dart';
import '../text/s_text.dart';

/// One box of an [SFactBoxes] row.
@immutable
class FactBox {
  const FactBox({
    required this.icon,
    required this.label,
    required this.value,
    this.hot = false,
  });

  final SIcons icon;

  /// What it is ("Pick up"), quiet, after [icon].
  final String label;

  /// The fact itself, bold ("Today 5:00 PM").
  final String value;

  /// [value] in the brand's orange: it needs seeing to (running out).
  final bool hot;
}

/// The few facts to plan around, side by side in outlined boxes of one
/// height, right under a page's photo (when to pick up and how many are
/// left).
class SFactBoxes extends StatelessWidget {
  const SFactBoxes(this.boxes, {super.key});

  final List<FactBox> boxes;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        for (final box in boxes)
          Expanded(
            child: SCard(
              padded: false,
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xs,
                  children: [
                    Row(
                      spacing: Space.xs,
                      children: [
                        SIcon(
                          box.icon,
                          size: SIconSize.sm,
                          color: SColor.textMuted,
                        ),
                        Flexible(
                          child: SText(
                            box.label,
                            variant: TextVariant.caption,
                            color: SColor.textMuted,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SText(
                      box.value,
                      weight: SFontWeight.bold,
                      color: box.hot ? SColor.accentInk : SColor.text,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
