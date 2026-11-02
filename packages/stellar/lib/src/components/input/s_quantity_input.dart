import 'package:flutter/widgets.dart';

import 's_input_material.dart';

/// How many of something, picked with a minus and a plus around the
/// number, from [min] to [max] (pieces of an offer to reserve).
abstract interface class SQuantityInput implements Widget {
  const factory SQuantityInput({
    required int value,
    required ValueChanged<int> onChanged,
    int min,
    required int max,
    Key? key,
  }) = SQuantityInputMaterial;
}
