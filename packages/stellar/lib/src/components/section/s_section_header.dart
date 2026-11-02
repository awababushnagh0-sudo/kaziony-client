import 'package:flutter/widgets.dart';

import 's_section_material.dart';

/// The title over a part of a page, as the big apps head their sections:
/// bold, with a quiet [note] or a link ("See all") at its end.
abstract interface class SSectionHeader implements Widget {
  /// [note] is quiet text at the end (today's date). A link ([actionLabel]
  /// and [onAction], both or neither) takes its place.
  const factory SSectionHeader(
    String title, {
    String? note,
    String? actionLabel,
    VoidCallback? onAction,
    Key? key,
  }) = SSectionHeaderMaterial;
}
