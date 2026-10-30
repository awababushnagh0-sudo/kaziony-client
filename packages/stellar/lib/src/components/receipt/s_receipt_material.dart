import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../material/s_dashed_line.dart';
import 's_receipt_renderer.dart';

class MaterialReceiptRenderer implements ReceiptRenderer {
  const MaterialReceiptRenderer();

  @override
  Widget render(BuildContext context, ReceiptSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final note = spec.note;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.md,
          children: [
            for (final line in spec.lines) _Line(line),
            DashedLine(color: c.border),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.totalLabel,
                        style: TextStyle(
                          fontSize: text.subtitle,
                          fontWeight: SFontWeight.bold.value,
                          color: c.text,
                        ),
                      ),
                      if (note != null)
                        Text(
                          note,
                          style: TextStyle(
                            fontSize: text.small,
                            color: c.textSubtle,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  spec.total,
                  style: TextStyle(
                    fontSize: text.display,
                    fontWeight: SFontWeight.bold.value,
                    color: c.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.line);

  final ReceiptLine line;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final detail = line.detail;
    // On the item's first line, like a printed receipt.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Space.sm,
      children: [
        Text(
          // "×2" reads left to right in Arabic too.
          '\u2066×${line.quantity}\u2069',
          style: TextStyle(
            fontSize: text.body,
            fontWeight: SFontWeight.bold.value,
            color: c.primary,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.title,
                style: TextStyle(
                  fontSize: text.body,
                  fontWeight: SFontWeight.semibold.value,
                  color: c.text,
                ),
              ),
              if (detail != null)
                Text(
                  detail,
                  style: TextStyle(fontSize: text.small, color: c.textSubtle),
                ),
            ],
          ),
        ),
        Text(
          line.amount,
          style: TextStyle(
            fontSize: text.body,
            fontWeight: SFontWeight.semibold.value,
            color: c.text,
          ),
        ),
      ],
    );
  }
}
