import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_input_renderer.dart';

/// A saved value with its label, laid out like a form field but read-only,
/// as on an ERPNext record page. Put several in an SFieldGrid.
class SReadField extends StatelessWidget {
  const SReadField({
    required this.label,
    required this.value,
    this.ltr = false,
    super.key,
  });

  final String label;

  /// Null or empty shows a dash.
  final String? value;

  /// For phones, emails and links.
  final bool ltr;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).input
          .read(context, ReadFieldSpec(label: label, value: value, ltr: ltr));
}
