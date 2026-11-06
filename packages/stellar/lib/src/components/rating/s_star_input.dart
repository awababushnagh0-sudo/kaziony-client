import 'package:flutter/widgets.dart';

import 's_rating_material.dart';

/// Five stars to give a rating from 1 to 5: the first [value] filled.
abstract interface class SStarInput implements Widget {
  /// [value] is 0 before any is picked. [starLabel] names each star, for
  /// its tooltip and screen readers ("3 stars"); read-only, it names the
  /// [value] given. Without [onChanged] the stars only show [value] (a
  /// rating already given, or one being sent).
  const factory SStarInput({
    required int value,
    required String Function(int stars) starLabel,
    ValueChanged<int>? onChanged,
    Key? key,
  }) = SStarInputMaterial;
}
