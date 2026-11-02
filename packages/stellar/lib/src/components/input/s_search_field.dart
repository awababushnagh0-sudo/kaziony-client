import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_input_renderer.dart';

/// A search box above a list: a gray pill that filters as the user types.
class SSearchField extends StatelessWidget {
  const SSearchField({
    required this.hint,
    required ValueChanged<String> this.onChanged,
    this.initialValue = '',
    this.autofocus = false,
    super.key,
  }) : onTap = null;

  /// Looks the same but opens the search elsewhere ([onTap]): the search
  /// bar at the top of a home page.
  const SSearchField.button({
    required this.hint,
    required VoidCallback this.onTap,
    super.key,
  }) : onChanged = null,
       initialValue = '',
       autofocus = false;

  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String initialValue;

  /// Opens the keyboard at once: on a page that is only for searching.
  final bool autofocus;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).input.search(
    context,
    SearchFieldSpec(
      hint: hint,
      onChanged: onChanged,
      onTap: onTap,
      initialValue: initialValue,
      autofocus: autofocus,
    ),
  );
}
