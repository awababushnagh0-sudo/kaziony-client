import 'package:flutter/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart' show ValidationMessage;

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../form/s_validators.dart';
import 's_input_renderer.dart';

/// A text field bound to the control [controlName] of the enclosing
/// SForm. Common validation errors get translated messages
/// automatically; pass [validationMessages] for custom ones.
class STextInput extends StatelessWidget {
  const STextInput({
    required this.controlName,
    required this.label,
    this.hint,
    this.kind = TextInputKind.text,
    this.isLast = false,
    this.onSubmitted,
    this.autofillHints,
    this.maxLength,
    this.validationMessages = const {},
    this.required = false,
    this.helper,
    this.autofocus = false,
    super.key,
  });

  final String controlName;
  final String label;
  final String? hint;
  final TextInputKind kind;
  final bool isLast;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final Map<String, String Function(Object error)> validationMessages;

  /// Shows a red asterisk by the label; add `Validators.required` too.
  final bool required;

  /// A quiet line under the field explaining what to enter.
  final String? helper;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return StellarKit.of(context).input.text(
      context,
      TextInputSpec(
        controlName: controlName,
        label: label,
        hint: hint,
        kind: kind,
        isLast: isLast,
        onSubmitted: onSubmitted,
        autofillHints: autofillHints,
        maxLength: maxLength,
        required: required,
        helper: helper,
        autofocus: autofocus,
        validationMessages: {
          ValidationMessage.required: (_) => strings.validationRequired,
          ValidationMessage.minLength: (error) =>
              strings.validationMinLength(_requiredLength(error)),
          ValidationMessage.maxLength: (error) =>
              strings.validationMaxLength(_requiredLength(error)),
          ValidationMessage.email: (_) => strings.validationEmail,
          ValidationMessage.mustMatch: (_) => strings.validationMustMatch,
          SValidators.libyanPhoneKey: (_) => strings.validationPhone,
          SValidators.urlKey: (_) => strings.validationUrl,
          SValidators.priceKey: (_) => strings.validationPrice,
          SValidators.wholeNumberKey: (error) => strings.validationWholeNumber(
            _bound(error, 'min'),
            _bound(error, 'max'),
          ),
          ...validationMessages,
        },
      ),
    );
  }
}

int _requiredLength(Object error) =>
    error is Map ? (error['requiredLength'] as int? ?? 0) : 0;

int _bound(Object error, String key) =>
    error is Map ? (error[key] as int? ?? 0) : 0;
