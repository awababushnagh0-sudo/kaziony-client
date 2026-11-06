import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_card.dart';

/// [SCard], drawn with Material's [Card].
class SCardMaterial extends StatelessWidget implements SCard {
  const SCardMaterial({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  }) : raised = false;

  const SCardMaterial.raised({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  }) : raised = true;

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;
  final bool raised;

  static const _shadowBlur = 16.0;
  static const _shadowDrop = Offset(0, 4);

  @override
  Widget build(BuildContext context) {
    final content = padded
        ? Padding(padding: const EdgeInsets.all(Space.lg), child: child)
        : child;
    if (!raised) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? content : InkWell(onTap: onTap, child: content),
      );
    }
    final c = context.colors;
    // The theme's outlined shape, without the outline where the shadow
    // shows.
    final outlined = CardTheme.of(context).shape! as RoundedRectangleBorder;
    final card = Card(
      clipBehavior: Clip.antiAlias,
      shape: c.brightness == Brightness.light
          ? outlined.copyWith(side: BorderSide.none)
          : outlined,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: outlined.borderRadius,
        boxShadow: [
          BoxShadow(
            color: c.shadow,
            blurRadius: _shadowBlur,
            offset: _shadowDrop,
          ),
        ],
      ),
      child: card,
    );
  }
}
