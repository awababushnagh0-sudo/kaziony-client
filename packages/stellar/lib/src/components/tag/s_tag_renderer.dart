import 'package:flutter/widgets.dart';

/// A short figure at the end of a row, with a caption under it.
@immutable
class TagSpec {
  const TagSpec({required this.label, this.caption, this.hot = false});

  final String label;
  final String? caption;

  /// Orange: running out (time or pieces).
  final bool hot;
}

abstract interface class TagRenderer {
  Widget render(BuildContext context, TagSpec spec);
}
