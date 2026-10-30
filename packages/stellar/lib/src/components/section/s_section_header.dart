import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_section_renderer.dart';

/// The title over a part of a page, as the big apps head their sections:
/// bold, with a quiet [note] or a link ("See all") at its end.
class SSectionHeader extends StatelessWidget {
  const SSectionHeader(
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
  Widget build(BuildContext context) => StellarKit.of(context).section.header(
    context,
    SectionHeaderSpec(
      title: title,
      note: note,
      actionLabel: actionLabel,
      onAction: onAction,
    ),
  );
}
