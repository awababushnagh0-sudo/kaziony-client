import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_input_renderer.dart';

/// How many of something, picked with a minus and a plus around the
/// number, from [min] to [max] (pieces of an offer to reserve).
class SQuantityInput extends StatelessWidget {
  const SQuantityInput({
    required this.value,
    required this.onChanged,
    this.min = 1,
    required this.max,
    super.key,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).input.quantity(
    context,
    QuantityInputSpec(value: value, min: min, max: max, onChanged: onChanged),
  );
}
