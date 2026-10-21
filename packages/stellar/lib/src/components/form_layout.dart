import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';
import '../tokens/tokens.dart';
import 'app_icon.dart';
import 'components.dart';

/// Lays out form fields in [columns] equal columns, dropping to one as the
/// space narrows.
class AppFieldGrid extends StatelessWidget {
  const AppFieldGrid({required this.children, this.columns = 2, super.key});

  final List<Widget> children;
  final int columns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final count = width < 440 ? 1 : columns;
      const gap = Space.lg;
      final itemWidth = (width - gap * (count - 1)) / count;
      return Wrap(
        spacing: gap,
        runSpacing: Space.lg,
        children: [
          for (final child in children)
            SizedBox(width: itemWidth, child: child),
        ],
      );
    },
  );
}

/// A titled group of fields, separated from the next by a line, as in
/// ERPNext forms.
class AppFormSection extends StatelessWidget {
  const AppFormSection({
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
          AppText(title, variant: TextVariant.subtitle, bold: true),
          const Gap(Space.lg),
          child,
        ],
      ),
    );
  }
}

/// A value to hand over (a temporary password), with a copy button.
/// Read-only; [ltr] keeps codes and numbers left to right in Arabic.
class AppCopyField extends StatelessWidget {
  const AppCopyField({
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
        Text(label, style: TextStyle(fontSize: 13, color: c.text)),
        const Gap(6),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.text,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppIconButton(
                icon: AppIcon.copy,
                tooltip: strings.copy,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: value));
                  if (context.mounted) AppSnack.info(context, strings.copied);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
