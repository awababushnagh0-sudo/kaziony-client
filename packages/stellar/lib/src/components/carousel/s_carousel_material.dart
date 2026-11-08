import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_carousel.dart';

/// [SCarousel], drawn as a [Row] in a sideways [SingleChildScrollView].
class SCarouselMaterial extends StatelessWidget implements SCarousel {
  const SCarouselMaterial({required this.children, super.key})
    : small = false,
      wide = false;

  const SCarouselMaterial.wide({required this.children, super.key})
    : small = false,
      wide = true;

  const SCarouselMaterial.small({required this.children, super.key})
    : small = true,
      wide = false;

  final List<Widget> children;

  /// Children keep their own width.
  final bool small;

  /// Cards take more of the screen.
  final bool wide;

  /// A card's share of the screen's width, and the most it gets on a
  /// wide one.
  static const _share = 0.72;
  static const _maxWidth = 320.0;
  static const _wideShare = 0.86;
  static const _wideMaxWidth = 420.0;

  @override
  Widget build(BuildContext context) {
    final share =
        MediaQuery.sizeOf(context).width * (wide ? _wideShare : _share);
    final most = wide ? _wideMaxWidth : _maxWidth;
    final width = share < most ? share : most;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // Raised cards' shadows show past the row; sideways it runs to the
      // screen's edges anyway.
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(
        // Small things carry their own space around them.
        horizontal: small ? Space.sm : Space.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: small ? Space.xs : Space.md,
        children: [
          for (final child in children)
            small ? child : SizedBox(width: width, child: child),
        ],
      ),
    );
  }
}
