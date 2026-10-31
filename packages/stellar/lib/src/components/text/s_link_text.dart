import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_text_renderer.dart';

/// A quiet sentence that ends in a tappable [link]: "Store not on Kaziony
/// yet? Contact us".
class SLinkText extends StatelessWidget {
  const SLinkText({
    required this.text,
    required this.link,
    required this.onTap,
    this.align,
    super.key,
  });

  final String text;
  final String link;
  final VoidCallback onTap;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).text.link(
    context,
    LinkTextSpec(text: text, link: link, onTap: onTap, align: align),
  );
}
