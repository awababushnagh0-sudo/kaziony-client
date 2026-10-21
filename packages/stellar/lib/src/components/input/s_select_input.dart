import 'package:flutter/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart' show ValidationMessage;

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import 's_input_renderer.dart';

/// A dropdown bound to the control [controlName] of the enclosing SForm.
class SSelectInput<T> extends StatelessWidget {
  const SSelectInput({
    required this.controlName,
    required this.label,
    required this.options,
    this.hint,
    this.required = false,
    super.key,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;
  final String? hint;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return StellarKit.of(context).input.select<T>(
      context,
      SelectInputSpec<T>(
        controlName: controlName,
        label: label,
        options: options,
        hint: hint,
        required: required,
        validationMessages: {
          ValidationMessage.required: (_) => strings.validationRequired,
        },
      ),
    );
  }
}
