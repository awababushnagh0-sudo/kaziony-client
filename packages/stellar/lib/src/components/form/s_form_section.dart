import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../text/s_text.dart';
import '../text/s_text_renderer.dart';

/// A titled group of fields. In the phone apps it's a gray panel, so a
/// form reads as a few short steps; on the dashboard, a part separated
/// from the next by a line, as in ERPNext forms.
class SFormSection extends StatelessWidget {
  const SFormSection({
    required this.title,
    required this.child,
    this.note,
    this.divider = true,
    super.key,
  });

  final String title;

  /// A line under [title] on what the fields are for.
  final String? note;
  final Widget child;

  /// The line under the section on the dashboard; off for the last one.
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xxs,
      children: [
        SText(title, variant: TextVariant.subtitle, weight: SFontWeight.bold),
        if (note case final note?)
          SText(note, variant: TextVariant.caption, color: SColor.textMuted),
      ],
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [heading, const Gap(Space.lg), child],
    );
    if (context.style == StellarStyle.app) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: c.fieldFill,
          borderRadius: BorderRadius.circular(Radii.xxl),
        ),
        child: Padding(padding: const EdgeInsets.all(Space.lg), child: body),
      );
    }
    return Container(
      padding: EdgeInsets.only(bottom: divider ? Space.xl : 0),
      margin: EdgeInsets.only(bottom: divider ? Space.xl : 0),
      decoration: BoxDecoration(
        border: divider ? Border(bottom: BorderSide(color: c.border)) : null,
      ),
      child: body,
    );
  }
}
