import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../image/s_image.dart';
import 's_item_summary.dart';

/// [SItemSummary]: the thumbnail, then the name over its state.
class SItemSummaryMaterial extends StatelessWidget implements SItemSummary {
  const SItemSummaryMaterial({
    required this.title,
    this.imageUrl,
    this.badge,
    this.note,
    this.dimmed = false,
    super.key,
  });

  static const _dimmedOpacity = 0.5;

  final String title;
  final String? imageUrl;
  final Widget? badge;
  final String? note;

  /// Grayed: nothing to hand over.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final badge = this.badge;
    final note = this.note;
    final picture = SImage(imageUrl, size: SImageSize.thumb);
    return Row(
      spacing: Space.md,
      children: [
        if (dimmed)
          Opacity(opacity: _dimmedOpacity, child: picture)
        else
          picture,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xs,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: text.subtitle,
                  fontWeight: SFontWeight.bold.value,
                  color: dimmed ? c.textMuted : c.text,
                ),
              ),
              if (badge != null || note != null)
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ?badge,
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
            ],
          ),
        ),
      ],
    );
  }
}
