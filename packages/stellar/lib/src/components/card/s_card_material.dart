import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_card.dart';

enum _Look {
  outlined,

  /// On a soft shadow, without the outline where the shadow shows.
  raised,

  /// Neither: the photo inside draws its edge.
  plain,
}

/// [SCard], drawn with Material's [Card].
class SCardMaterial extends StatelessWidget implements SCard {
  const SCardMaterial({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  }) : _look = _Look.outlined;

  const SCardMaterial.raised({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  }) : _look = _Look.raised;

  const SCardMaterial.plain({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  }) : _look = _Look.plain;

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;
  final _Look _look;

  static const _shadowBlur = 8.0;
  static const _shadowDrop = Offset(0, 2);

  @override
  Widget build(BuildContext context) {
    final content = padded
        ? Padding(padding: const EdgeInsets.all(Space.lg), child: child)
        : child;
    final tappable = onTap == null
        ? content
        : InkWell(onTap: onTap, child: content);
    if (_look == _Look.outlined) {
      return Card(clipBehavior: Clip.antiAlias, child: tappable);
    }
    final c = context.colors;
    // The theme's outlined shape, without the outline.
    final outlined = CardTheme.of(context).shape! as RoundedRectangleBorder;
    final bare = outlined.copyWith(side: BorderSide.none);
    if (_look == _Look.plain) {
      return Card(clipBehavior: Clip.antiAlias, shape: bare, child: tappable);
    }
    final card = Card(
      clipBehavior: Clip.antiAlias,
      // In the dark, where the shadow doesn't show, the outline stays.
      shape: c.brightness == Brightness.light ? bare : outlined,
      child: tappable,
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
