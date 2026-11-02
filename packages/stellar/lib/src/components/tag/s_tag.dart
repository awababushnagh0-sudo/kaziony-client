import 'package:flutter/widgets.dart';

import 's_tag_material.dart';

/// A short figure at the end of a row ("12 min", "3 left") in a pill, with
/// a quiet `caption` under it ("until 3:12 PM"). Goes in a row's
/// `trailing`.
abstract interface class STag implements Widget {
  /// [hot] turns it orange: running out (time or pieces).
  const factory STag(String label, {String? caption, bool hot, Key? key}) =
      STagMaterial;
}
