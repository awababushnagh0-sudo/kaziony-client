import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_input_renderer.dart';

class SSearchField extends StatelessWidget {
  const SSearchField({
    required this.hint,
    required this.onChanged,
    this.initialValue = '',
    super.key,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).input.search(
    context,
    SearchFieldSpec(
      hint: hint,
      onChanged: onChanged,
      initialValue: initialValue,
    ),
  );
}
