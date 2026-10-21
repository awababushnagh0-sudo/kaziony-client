import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
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
}
