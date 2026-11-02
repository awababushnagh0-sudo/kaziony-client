import 'package:flutter/widgets.dart';

import 's_code_material.dart';

/// A code people read out or hold up to compare (a pickup code), in big
/// spaced letters under a small label, on the brand color. Reads left to
/// right in Arabic too.
abstract interface class SCodeCard implements Widget {
  /// [code] comes already grouped for reading ("K7MP 4XRA").
  const factory SCodeCard({
    required String label,
    required String code,
    Key? key,
  }) = SCodeCardMaterial;
}
