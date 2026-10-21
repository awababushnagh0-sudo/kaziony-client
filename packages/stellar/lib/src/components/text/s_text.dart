import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_text_renderer.dart';

/// All text in the apps. Size, weight and color are stellar tokens
/// ([TextVariant], [SFontWeight], [SColor]), never raw numbers or colors.
class SText extends StatelessWidget {
  const SText(
    this.text, {
    this.variant = TextVariant.body,
    this.color = SColor.text,
    this.weight,
    this.align,
    this.maxLines,
    super.key,
  });

  const SText.display(
    this.text, {
    this.color = SColor.text,
    this.align,
    super.key,
  }) : variant = TextVariant.display,
       weight = SFontWeight.bold,
       maxLines = null;

  const SText.title(
    this.text, {
    this.color = SColor.text,
    this.align,
    this.maxLines,
    super.key,
  }) : variant = TextVariant.title,
       weight = SFontWeight.bold;

  const SText.caption(
    this.text, {
    this.color = SColor.textMuted,
    this.align,
    this.maxLines,
    super.key,
  }) : variant = TextVariant.caption,
       weight = null;

  final String text;
  final TextVariant variant;
  final SColor color;

  /// Null keeps the variant's own weight.
  final SFontWeight? weight;
  final TextAlign? align;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).text.render(
    context,
    TextSpec(
      text,
      variant: variant,
      color: color,
      weight: weight,
      align: align,
      maxLines: maxLines,
    ),
  );
}
