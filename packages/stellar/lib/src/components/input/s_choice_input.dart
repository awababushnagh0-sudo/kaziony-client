import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_input_renderer.dart';

/// One of a few values (limited or unlimited), as pills, bound to the
/// control [controlName] of the enclosing SForm.
class SChoiceInput<T> extends StatelessWidget {
  const SChoiceInput({
    required this.controlName,
    required this.label,
    required this.options,
    this.onChanged,
    super.key,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;

  /// For screens that show other fields depending on the choice.
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).input.choice<T>(
    context,
    ChoiceInputSpec<T>(
      controlName: controlName,
      label: label,
      options: options,
      onChanged: onChanged,
    ),
  );
}
