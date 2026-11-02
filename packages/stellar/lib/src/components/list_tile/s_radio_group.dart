import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import 's_radio_tile.dart';

/// One choice of an [SRadioGroup] or a choice sheet (`SSheet.choose`).
@immutable
class RadioOption<T> {
  const RadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.mark,
  }) : assert(icon == null || mark == null, 'An icon or a mark, not both');

  final T value;
  final String label;

  /// A quieter line under [label] (a branch's address).
  final String? subtitle;

  /// At the start of the row, in a circle.
  final SIcons? icon;

  /// A letter or two in the circle instead of an icon, where no icon fits
  /// ("ع" and "En" for the languages).
  final String? mark;
}

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
