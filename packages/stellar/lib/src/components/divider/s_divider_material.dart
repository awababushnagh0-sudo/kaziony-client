import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_divider.dart';

/// [SDivider], drawn as a Material [Divider] in the border color.
class SDividerMaterial extends StatelessWidget implements SDivider {
  const SDividerMaterial({this.inset = false, super.key});

  final bool inset;

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 1,
    color: context.colors.border,
    indent: inset ? Space.lg : 0,
    endIndent: inset ? Space.lg : 0,
  );
}
