import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_alert_renderer.dart';

class MaterialAlertRenderer implements AlertRenderer {
  const MaterialAlertRenderer();

  @override
  Widget render(BuildContext context, AlertSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final message = spec.message;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.dangerSoft,
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.md,
            children: [
              Icon(
                materialIcon(SIcons.error),
                size: SIconSize.lg.pixels,
                color: c.danger,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xs,
                  children: [
                    Text(
                      spec.title,
                      style: TextStyle(
                        fontSize: text.body,
                        fontWeight: SFontWeight.bold.value,
                        color: c.danger,
                      ),
                    ),
                    if (message != null)
                      Text(
                        message,
                        style: TextStyle(fontSize: text.small, color: c.text),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
