import 'package:flutter/widgets.dart';

import 's_code_material.dart';

/// A code people read out or hold up to compare (a pickup code), in big
/// spaced letters under a small label, on the brand color. Reads left to
/// right in Arabic too.
abstract interface class SCodeCard implements Widget {
  /// [code] comes already grouped for reading ("K7MP 4XRA"). With
  /// [copyHint] and [copiedMessage] (both or neither), tapping it copies
  /// the code and says so; [copyHint] says it, small under the code ("Tap
  /// to copy").
  const factory SCodeCard({
    required String label,
    required String code,
    String? copyHint,
    String? copiedMessage,
    Key? key,
  }) = SCodeCardMaterial;

  /// The code alone, in big dark letters on the card it's in; tapping it
  /// copies it and says so ([copiedMessage]). [copyLabel] says what a tap
  /// does, for screen readers.
  const factory SCodeCard.copyable({
    required String code,
    required String copyLabel,
    required String copiedMessage,
    Key? key,
  }) = SCopyableCodeMaterial;
}
