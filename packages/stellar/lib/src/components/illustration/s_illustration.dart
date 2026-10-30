import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_illustration_renderer.dart';

/// One of the brand's pictures ([SIllustrations]), centered at its own
/// width, smaller where there's less room. Decoration only: screen readers
/// skip it.
class SIllustration extends StatelessWidget {
  const SIllustration(this.illustration, {super.key});

  final SIllustrations illustration;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).illustration
          .render(context, IllustrationSpec(illustration: illustration));
}
