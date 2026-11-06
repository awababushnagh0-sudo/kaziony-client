import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_link_text.dart';
import 's_text.dart';

/// [SText], drawn as a [Text] in the theme's type scale.
class STextMaterial extends StatelessWidget implements SText {
  const STextMaterial(
    this.text, {
    this.variant = TextVariant.body,
    this.color = SColor.text,
    this.weight,
    this.align,
    this.maxLines,
    this.struck = false,
    super.key,
  });

  const STextMaterial.display(
    this.text, {
    this.color = SColor.text,
    this.align,
    super.key,
  }) : variant = TextVariant.display,
       weight = SFontWeight.bold,
       maxLines = null,
       struck = false;

  const STextMaterial.title(
    this.text, {
    this.color = SColor.text,
    this.align,
    this.maxLines,
    super.key,
  }) : variant = TextVariant.title,
       weight = SFontWeight.bold,
       struck = false;

  const STextMaterial.caption(
    this.text, {
    this.color = SColor.textMuted,
    this.align,
    this.maxLines,
    super.key,
  }) : variant = TextVariant.caption,
       weight = null,
       struck = false;

  final String text;
  final TextVariant variant;
  final SColor color;

  /// Null keeps the variant's own weight.
  final SFontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final bool struck;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final base = switch (variant) {
      TextVariant.display => theme.headlineMedium,
      TextVariant.title => theme.titleLarge,
      TextVariant.subtitle => theme.titleMedium,
      TextVariant.body => theme.bodyLarge,
      TextVariant.caption => theme.bodySmall,
      TextVariant.label => theme.labelLarge,
    };
    final color = context.colors.resolve(this.color);
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: base?.copyWith(
        color: color,
        fontWeight: weight?.value,
        decoration: struck ? TextDecoration.lineThrough : null,
        decorationColor: struck ? color : null,
      ),
    );
  }
}

/// [SLinkText], drawn as one [Text.rich] whose link is tappable.
class SLinkTextMaterial extends StatefulWidget implements SLinkText {
  const SLinkTextMaterial({
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
  State<SLinkTextMaterial> createState() => _SLinkTextMaterialState();
}

class _SLinkTextMaterialState extends State<SLinkTextMaterial> {
  late final _tap = TapGestureRecognizer()..onTap = () => widget.onTap();

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: c.textMuted),
        children: [
          TextSpan(text: '${widget.text} '),
          TextSpan(
            text: widget.link,
            recognizer: _tap,
            style: TextStyle(
              color: c.link,
              fontWeight: SFontWeight.semibold.value,
            ),
          ),
        ],
      ),
      textAlign: widget.align,
    );
  }
}
