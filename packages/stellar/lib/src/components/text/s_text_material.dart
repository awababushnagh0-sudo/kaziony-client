import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_text_renderer.dart';

class MaterialTextRenderer implements TextRenderer {
  const MaterialTextRenderer();

  @override
  Widget render(BuildContext context, TextSpec spec) {
    final theme = Theme.of(context).textTheme;
    final base = switch (spec.variant) {
      TextVariant.display => theme.headlineMedium,
      TextVariant.title => theme.titleLarge,
      TextVariant.subtitle => theme.titleMedium,
      TextVariant.body => theme.bodyLarge,
      TextVariant.caption => theme.bodySmall,
      TextVariant.label => theme.labelLarge,
    };
    return Text(
      spec.text,
      textAlign: spec.align,
      maxLines: spec.maxLines,
      overflow: spec.maxLines == null ? null : TextOverflow.ellipsis,
      style: base?.copyWith(
        color: context.colors.resolve(spec.color),
        fontWeight: spec.weight?.value,
      ),
    );
  }

  @override
  Widget link(BuildContext context, LinkTextSpec spec) => _LinkText(spec);
}

class _LinkText extends StatefulWidget {
  const _LinkText(this.spec);

  final LinkTextSpec spec;

  @override
  State<_LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<_LinkText> {
  late final _tap = TapGestureRecognizer()..onTap = () => widget.spec.onTap();

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final spec = widget.spec;
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: c.textMuted),
        children: [
          TextSpan(text: '${spec.text} '),
          TextSpan(
            text: spec.link,
            recognizer: _tap,
            style: TextStyle(
              color: c.link,
              fontWeight: SFontWeight.semibold.value,
            ),
          ),
        ],
      ),
      textAlign: spec.align,
    );
  }
}
