import 'package:flutter/widgets.dart';

/// A code people read out or compare, big and spaced.
@immutable
class CodeCardSpec {
  const CodeCardSpec({required this.label, required this.code});

  final String label;

  /// Already grouped for reading ("K7MP 4XRA").
  final String code;
}

/// A code typed one character to a box.
@immutable
class CodeInputSpec {
  const CodeInputSpec({
    required this.controlName,
    required this.label,
    required this.length,
    required this.groupOf,
    required this.characters,
    required this.autofocus,
    required this.onSubmitted,
  });

  /// Name of the control in the enclosing SForm.
  final String controlName;

  /// Read out for the field; not shown.
  final String label;
  final int length;

  /// A wider gap after every this many boxes, as the code is read out.
  final int groupOf;

  /// Matches one character a code can have; others can't be typed.
  final RegExp characters;
  final bool autofocus;
  final VoidCallback? onSubmitted;
}

/// A QR code a counter scans.
@immutable
class QrCodeSpec {
  const QrCodeSpec({required this.data, required this.label});

  final String data;

  /// Read out for screen readers.
  final String label;
}

abstract interface class CodeRenderer {
  Widget card(BuildContext context, CodeCardSpec spec);
  Widget qr(BuildContext context, QrCodeSpec spec);
  Widget input(BuildContext context, CodeInputSpec spec);
}
