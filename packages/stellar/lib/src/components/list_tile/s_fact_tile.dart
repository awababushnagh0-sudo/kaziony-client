import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_list_tile_renderer.dart';

/// A setting and its value in an [SListGroup], read at a glance: the name
/// quiet, the [value] in bold ("Hold time · 60 min").
class SFactTile extends StatelessWidget {
  const SFactTile({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).listTile
          .fact(context, FactTileSpec(label: label, value: value));
}
