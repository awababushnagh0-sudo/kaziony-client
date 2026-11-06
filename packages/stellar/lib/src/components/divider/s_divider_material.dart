import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_divider.dart';

/// [SDivider], drawn as a Material [Divider]: a line in the border color,
/// or a band in the fields' gray.
class SDividerMaterial extends StatelessWidget implements SDivider {
  const SDividerMaterial({this.inset = false, super.key}) : _band = false;

  const SDividerMaterial.band({super.key}) : inset = false, _band = true;

  final bool inset;
  final bool _band;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _band
        ? Divider(height: Space.sm, thickness: Space.sm, color: c.fieldFill)
        : Divider(
            height: 1,
            thickness: 1,
            color: c.border,
            indent: inset ? Space.lg : 0,
            endIndent: inset ? Space.lg : 0,
          );
  }
}
