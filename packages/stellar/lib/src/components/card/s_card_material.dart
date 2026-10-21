import 'package:flutter/material.dart';

import '../../foundation/s_tokens.dart';
import 's_card_renderer.dart';

class MaterialCardRenderer implements CardRenderer {
  const MaterialCardRenderer();

  @override
  Widget render(BuildContext context, CardSpec spec) {
    final content = spec.padded
        ? Padding(padding: const EdgeInsets.all(Space.lg), child: spec.child)
        : spec.child;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: spec.onTap == null
          ? content
          : InkWell(onTap: spec.onTap, child: content),
    );
  }
}
