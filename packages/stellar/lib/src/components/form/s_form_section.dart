import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../text/s_text.dart';
import '../text/s_text_renderer.dart';

/// A titled group of fields, separated from the next by a line, as in
/// ERPNext forms.
class SFormSection extends StatelessWidget {
  const SFormSection({
    required this.title,
    required this.child,
    this.divider = true,
    super.key,
  });

  final String title;
  final Widget child;

  /// The line under the section; off for the last one.
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: EdgeInsets.only(bottom: divider ? Space.xl : 0),
      margin: EdgeInsets.only(bottom: divider ? Space.xl : 0),
      decoration: BoxDecoration(
        border: divider ? Border(bottom: BorderSide(color: c.border)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SText(title, variant: TextVariant.subtitle, weight: SFontWeight.bold),
          const Gap(Space.lg),
          child,
        ],
      ),
    );
  }
}
