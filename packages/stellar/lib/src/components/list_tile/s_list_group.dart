import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_list_tile_renderer.dart';

/// [SListTile]s in one rounded box under a small title, as on the settings
/// pages of the big apps.
class SListGroup extends StatelessWidget {
  const SListGroup({required this.children, this.title, super.key});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).listTile
          .group(context, ListGroupSpec(title: title, children: children));
}
