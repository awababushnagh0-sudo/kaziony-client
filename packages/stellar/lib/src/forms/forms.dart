import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show normalizeLibyanPhone;
import 'package:reactive_forms/reactive_forms.dart';

import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';

// reactive_forms holds the form state; apps get only these types from it.
export 'package:reactive_forms/reactive_forms.dart'
    show AbstractControl, FormControl, FormGroup, Validators;

/// Wraps a group of [AppTextInput]s bound to [form].
class AppForm extends StatelessWidget {
  const AppForm({required this.form, required this.child, super.key});

  final FormGroup form;
  final Widget child;

  @override
  Widget build(BuildContext context) => ReactiveForm(
    formGroup: form,
    child: AutofillGroup(child: child),
  );
}

/// A text field bound to the control [controlName] of the enclosing
/// [AppForm]. Common validation errors get translated messages
/// automatically; pass [validationMessages] for custom ones.
class AppTextInput extends StatelessWidget {
  const AppTextInput({
    required this.controlName,
    required this.label,
    this.hint,
    this.kind = TextInputKind.text,
    this.isLast = false,
    this.onSubmitted,
    this.autofillHints,
    this.maxLength,
    this.validationMessages = const {},
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

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return StellarKit.of(context).textInput.render(
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
        validationMessages: {
          ValidationMessage.required: (_) => strings.validationRequired,
          ValidationMessage.minLength: (error) =>
              strings.validationMinLength(_requiredLength(error)),
          ValidationMessage.maxLength: (error) =>
              strings.validationMaxLength(_requiredLength(error)),
          ValidationMessage.email: (_) => strings.validationEmail,
          ValidationMessage.mustMatch: (_) => strings.validationMustMatch,
          AppValidators.libyanPhoneKey: (_) => strings.validationPhone,
          ...validationMessages,
        },
      ),
    );
  }
}

int _requiredLength(Object error) =>
    error is Map ? (error['requiredLength'] as int? ?? 0) : 0;

abstract final class AppValidators {
  static const libyanPhoneKey = 'libyanPhone';

  /// Any common Libyan mobile format (0912345678, +218 91..., Arabic digits).
  static const Validator<dynamic> libyanPhone = _LibyanPhoneValidator();
}

class _LibyanPhoneValidator extends Validator<dynamic> {
  const _LibyanPhoneValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.isEmpty) return null;
    return normalizeLibyanPhone(value) == null
        ? {AppValidators.libyanPhoneKey: true}
        : null;
  }
}
