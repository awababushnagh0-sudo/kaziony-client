import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_code_renderer.dart';

/// A code people read out or hold up to compare (a pickup code), in big
/// spaced letters under a small [label], on the brand color. Reads left to
/// right in Arabic too.
class SCodeCard extends StatelessWidget {
  const SCodeCard({required this.label, required this.code, super.key});

  final String label;

  /// Already grouped for reading ("K7MP 4XRA").
  final String code;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).code
          .card(context, CodeCardSpec(label: label, code: code));
}
