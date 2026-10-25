import 'package:flutter/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

// reactive_forms holds the form state; apps get only these types from it.
export 'package:reactive_forms/reactive_forms.dart'
    show AbstractControl, FormControl, FormGroup, Validator, Validators;

/// Wraps a group of AppTextInputs bound to [form].
class SForm extends StatelessWidget {
  const SForm({required this.form, required this.child, super.key});

  final FormGroup form;
  final Widget child;

  @override
  Widget build(BuildContext context) => ReactiveForm(
    formGroup: form,
    child: AutofillGroup(child: child),
  );
}
