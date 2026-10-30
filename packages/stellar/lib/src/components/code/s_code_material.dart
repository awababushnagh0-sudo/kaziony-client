import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_code_renderer.dart';

class MaterialCodeRenderer implements CodeRenderer {
  const MaterialCodeRenderer();

  // Air between the letters, so look-alikes stay apart when read out.
  static const _letterSpacing = 3.0;

  @override
  Widget card(BuildContext context, CodeCardSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.primary,
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            spacing: Space.xxs,
            children: [
              Text(
                spec.label,
                style: TextStyle(fontSize: text.small, color: c.onPrimaryMuted),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  spec.code,
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: text.code,
                    fontWeight: SFontWeight.bold.value,
                    letterSpacing: _letterSpacing,
                    height: 1.2,
                    color: c.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
