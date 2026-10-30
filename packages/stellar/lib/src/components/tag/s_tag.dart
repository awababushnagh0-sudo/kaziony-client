import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_tag_renderer.dart';

/// A short figure at the end of a row ("12 min", "3 left") in a pill, with
/// a quiet [caption] under it ("until 3:12 PM"). Goes in a row's
/// `trailing`.
class STag extends StatelessWidget {
  const STag(this.label, {this.caption, this.hot = false, super.key});

  final String label;
  final String? caption;

  /// Orange: running out (time or pieces).
  final bool hot;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).tag
          .render(context, TagSpec(label: label, caption: caption, hot: hot));
}
