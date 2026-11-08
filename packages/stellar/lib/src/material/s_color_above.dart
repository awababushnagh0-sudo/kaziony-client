import 'package:flutter/widgets.dart';

/// Paints [color] for a screen's height above [child]: a band at a page's
/// top keeps its color when the page is pulled down past its top (the
/// phone's bounce, pull to refresh), instead of the page showing over it.
class ColorAbove extends StatelessWidget {
  const ColorAbove({required this.color, required this.child, super.key});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // A pixel under the band too, so no seam shows between them.
        Positioned(
          top: -height,
          height: height + 1,
          left: 0,
          right: 0,
          child: ColoredBox(color: color),
        ),
        child,
      ],
    );
  }
}
