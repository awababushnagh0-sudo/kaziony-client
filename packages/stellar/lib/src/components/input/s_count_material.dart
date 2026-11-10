import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../form/s_validators.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_count_input.dart';
import 's_input_material.dart' show bareDecoration, fieldScrollPadding;
import 's_number_formatters.dart';

/// [SCountInput], drawn as a bare [ReactiveTextField] between two outlined
/// round [IconButton]s; what's wrong under them.
class SCountInputMaterial extends StatelessWidget implements SCountInput {
  const SCountInputMaterial({
    required this.controlName,
    required this.label,
    required this.min,
    required this.max,
    this.size = CountSize.regular,
    super.key,
  });

  final String controlName;
  final String label;
  final int min;
  final int max;
  final CountSize size;

  /// Room for two figures (three when large) before the number widens, so
  /// the buttons don't move as it grows.
  static const _regularWidth = 40.0;
  static const _largeWidth = 88.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final strings = StellarLocalizations.of(context);
    final large = size == CountSize.large;
    final style = TextStyle(
      fontSize: large ? text.hero : text.title,
      fontWeight: SFontWeight.bold.value,
      color: c.text,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return ReactiveFormField<String, String>(
      formControlName: controlName,
      validationMessages: {
        ValidationMessage.required: (_) => strings.validationRequired,
        SValidators.wholeNumberKey: (_) =>
            strings.validationWholeNumber(min, max),
      },
      builder: (field) {
        final value = SValidators.wholeNumber(field.value);
        void set(int to) {
          field.didChange('$to');
          field.control.markAsTouched();
        }

        Widget step(SIcons icon, String tooltip, int? to) =>
            IconButton.outlined(
              tooltip: tooltip,
              onPressed: to == null ? null : () => set(to),
              style: IconButton.styleFrom(
                foregroundColor: c.primary,
                disabledForegroundColor: c.textSubtle,
                side: BorderSide(color: c.border),
              ),
              icon: Icon(materialIcon(icon), size: SIconSize.md.pixels),
            );

        final errorText = field.errorText;
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.xs,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: Space.sm,
              children: [
                step(
                  SIcons.minus,
                  strings.quantityFewer,
                  value == null || value <= min ? null : value - 1,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: large ? _largeWidth : _regularWidth,
                  ),
                  child: IntrinsicWidth(
                    child: Semantics(
                      label: label,
                      child: ReactiveTextField<String>(
                        formControlName: controlName,
                        showErrors: (_) => false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [wholeNumberFormatter],
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        scrollPadding: fieldScrollPadding,
                        style: style,
                        cursorColor: c.primary,
                        decoration: bareDecoration(
                          hint: (field.value ?? '').isEmpty ? '$min' : null,
                          hintStyle: style.copyWith(color: c.border),
                        ),
                      ),
                    ),
                  ),
                ),
                step(
                  SIcons.add,
                  strings.quantityMore,
                  value == null
                      ? min
                      : value >= max
                      ? null
                      : value + 1,
                ),
              ],
            ),
            if (errorText != null)
              Text(
                errorText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: text.small, color: c.danger),
              ),
          ],
        );
      },
    );
  }
}
