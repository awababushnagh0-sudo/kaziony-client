import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_list_tile_renderer.dart';
import 's_radio_tile.dart';

/// Pick one of [options]: an [SRadioTile] each, the one whose value is
/// [value] chosen. Tapping another calls [onChanged] with its value; the
/// screen keeps the value and passes it back, as with any input.
class SRadioGroup<T> extends StatelessWidget {
  const SRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<RadioOption<T>> options;

  /// The chosen value; null when nothing is chosen yet.
  final T? value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Space.sm,
    children: [
      for (final option in options)
        SRadioTile(
          title: option.label,
          subtitle: option.subtitle,
          icon: option.icon,
          mark: option.mark,
          selected: option.value == value,
          onTap: () => onChanged(option.value),
        ),
    ],
  );
}
