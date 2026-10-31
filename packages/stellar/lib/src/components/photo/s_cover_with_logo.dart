import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

/// A cover photo with a round logo over its bottom edge, at the start: a
/// store's page header. Both are usually `SPhotoField`s.
class SCoverWithLogo extends StatelessWidget {
  const SCoverWithLogo({required this.cover, required this.logo, super.key});

  final Widget cover;
  final Widget logo;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // Room under the cover for the logo's lower half, so all of it can
      // be tapped.
      Padding(
        padding: EdgeInsets.only(bottom: SImageSize.logo.pixels / 2),
        child: cover,
      ),
      PositionedDirectional(start: Space.lg, bottom: 0, child: logo),
    ],
  );
}
