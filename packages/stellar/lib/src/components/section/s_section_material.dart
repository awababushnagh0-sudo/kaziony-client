import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_section_header.dart';

/// [SSectionHeader], with a Material [TextButton] for its link.
class SSectionHeaderMaterial extends StatelessWidget implements SSectionHeader {
  const SSectionHeaderMaterial(
    this.title, {
    this.note,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'A link needs both its label and what it opens.',
       );

  final String title;
  final String? note;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final note = this.note;
    final actionLabel = this.actionLabel;
    return Row(
      spacing: Space.md,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: TextStyle(
                fontSize: text.subtitle,
                fontWeight: SFontWeight.bold.value,
                color: c.text,
              ),
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: c.link,
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              minimumSize: const Size(0, 44),
            ),
            // Styled here, not in the button's style: that would replace the
            // theme's font.
            child: Text(
              actionLabel,
              style: TextStyle(
                fontSize: text.small,
                fontWeight: SFontWeight.semibold.value,
              ),
            ),
          )
        else if (note != null)
          Text(
            note,
            style: TextStyle(fontSize: text.tiny, color: c.textSubtle),
          ),
      ],
    );
  }
}
