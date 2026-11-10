import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_alert.dart';

/// [SAlert], drawn as a tinted box with Material's [Icon].
class SAlertMaterial extends StatelessWidget implements SAlert {
  const SAlertMaterial({required this.title, this.message, super.key})
    : _warning = false;

  const SAlertMaterial.warning({required this.title, this.message, super.key})
    : _warning = true;

  final String title;
  final String? message;

  /// Orange, an info sign: something to know, not something wrong.
  final bool _warning;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final message = this.message;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _warning ? c.accentSoft : c.dangerSoft,
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.md,
            children: [
              Icon(
                materialIcon(_warning ? SIcons.info : SIcons.error),
                size: SIconSize.lg.pixels,
                color: _warning ? c.accentInk : c.danger,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xs,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: text.body,
                        fontWeight: SFontWeight.bold.value,
                        color: _warning ? c.accentInk : c.danger,
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
