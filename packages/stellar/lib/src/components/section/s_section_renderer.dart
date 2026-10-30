import 'package:flutter/widgets.dart';

/// The title over a part of a page, with a note or a link at its end.
@immutable
class SectionHeaderSpec {
  const SectionHeaderSpec({
    required this.title,
    this.note,
    this.actionLabel,
    this.onAction,
  });

  final String title;

  /// Quiet text at the end (today's date).
  final String? note;

  /// A link at the end ("See all"), in place of [note].
  final String? actionLabel;
  final VoidCallback? onAction;
}

abstract interface class SectionRenderer {
  Widget header(BuildContext context, SectionHeaderSpec spec);
}
