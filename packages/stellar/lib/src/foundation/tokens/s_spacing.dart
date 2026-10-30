import 'package:flutter/widgets.dart';

/// Spacing scale. Use these for gaps and padding instead of raw numbers.
abstract final class Space {
  /// Between a figure and its caption.
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// A fixed gap in a [Row] or [Column]: `Gap(Space.md)`.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(dimension: size);
}
