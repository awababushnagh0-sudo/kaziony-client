import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_code_renderer.dart';

/// A code typed one character to a box, in capitals, left to right in
/// Arabic too (a pickup code read out by the customer). Bound to
/// [controlName] in the enclosing SForm.
class SCodeInput extends StatelessWidget {
  const SCodeInput({
    required this.controlName,
    required this.label,
    required this.length,
    required this.characters,
    this.groupOf = 4,
    this.autofocus = false,
    this.onSubmitted,
    super.key,
  });

  final String controlName;

  /// Read out for the field; not shown.
  final String label;
  final int length;

  /// Matches one character a code can have (in capitals): others can't be
  /// typed, so look-alikes like 0 and O never get in.
  final RegExp characters;

  /// A wider gap after every this many boxes.
  final int groupOf;
  final bool autofocus;

  /// The keyboard's "go".
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).code.input(
    context,
    CodeInputSpec(
      controlName: controlName,
      label: label,
      length: length,
      groupOf: groupOf,
      characters: characters,
      autofocus: autofocus,
      onSubmitted: onSubmitted,
    ),
  );
}
