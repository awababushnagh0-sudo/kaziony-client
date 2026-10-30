import 'package:flutter/widgets.dart';

/// A code people read out or compare, big and spaced.
@immutable
class CodeCardSpec {
  const CodeCardSpec({required this.label, required this.code});

  final String label;

  /// Already grouped for reading ("K7MP 4XRA").
  final String code;
}

abstract interface class CodeRenderer {
  Widget card(BuildContext context, CodeCardSpec spec);
}
