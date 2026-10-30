import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_list_tile_renderer.dart';

/// [SListTile]s in one rounded box under a small title, as on the settings
/// pages of the big apps; or, [separated], each in a card of its own.
class SListGroup extends StatelessWidget {
  const SListGroup({
    required this.children,
    this.title,
    this.separated = false,
    super.key,
  });

  final String? title;
  final List<Widget> children;

  /// Rows that each open a page of their own (a profile's), rather than
  /// the parts of one thing.
  final bool separated;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).listTile.group(
    context,
    ListGroupSpec(title: title, separated: separated, children: children),
  );
}
