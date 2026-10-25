import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../button/s_button.dart';
import '../icon/s_icon.dart';
import '../snack/s_snack.dart';
import '../text/s_text.dart';
import '../text/s_text_renderer.dart';

/// A value to hand over (a temporary password), with a copy button.
/// Read-only; [ltr] keeps codes and numbers left to right in Arabic.
class SCopyField extends StatelessWidget {
  const SCopyField({
    required this.label,
    required this.value,
    this.ltr = true,
    super.key,
  });

  final String label;
  final String value;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final strings = StellarLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SText(label, variant: TextVariant.label, weight: SFontWeight.semibold),
        const Gap(Space.sm),
        Container(
          padding: const EdgeInsetsDirectional.only(start: Space.md),
          decoration: BoxDecoration(
            color: c.fieldFill,
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  textDirection: ltr ? TextDirection.ltr : null,
                  // Left to right, but lined up with the page's start edge.
                  textAlign: Directionality.of(context) == TextDirection.rtl
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                    fontSize: context.style.text.subtitle,
                    fontWeight: SFontWeight.semibold.value,
                    color: c.text,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SButton.icon(
                icon: SIcons.copy,
                tooltip: strings.copy,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: value));
                  if (context.mounted) SSnack.info(context, strings.copied);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
