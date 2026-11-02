import 'package:flutter/material.dart';

import '../../foundation/s_tokens.dart';
import 's_card.dart';

/// [SCard], drawn with Material's [Card].
class SCardMaterial extends StatelessWidget implements SCard {
  const SCardMaterial({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final content = padded
        ? Padding(padding: const EdgeInsets.all(Space.lg), child: child)
        : child;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
