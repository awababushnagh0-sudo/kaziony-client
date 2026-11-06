import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_box_head.dart';
import 's_expandable.dart';

/// [SBoxTile]: the boxes' frame and head in an [InkWell].
class SBoxTileMaterial extends StatelessWidget implements SBoxTile {
  const SBoxTileMaterial({
    required this.title,
    required this.action,
    required this.actionLabel,
    required this.onTap,
    this.subtitle,
    this.tag,
    this.icon,
    this.illustration,
    super.key,
  });

  final String title;
  final SIcons action;
  final String actionLabel;
  final VoidCallback onTap;
  final String? subtitle;
  final String? tag;
  final SIcons? icon;
  final Illustration? illustration;

  @override
  Widget build(BuildContext context) => BoxFrame(
    child: Semantics(
      button: true,
      hint: actionLabel,
      child: InkWell(
        onTap: onTap,
        child: BoxHead(
          title: title,
          subtitle: subtitle,
          tag: tag,
          icon: icon,
          illustration: illustration,
          end: Icon(
            materialIcon(action),
            size: SIconSize.md.pixels,
            color: context.colors.primary,
          ),
        ),
      ),
    ),
  );
}
