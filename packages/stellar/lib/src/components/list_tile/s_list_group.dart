import 'package:flutter/widgets.dart';

import 's_list_tile_material.dart';

/// [SListTile]s in one rounded box under a small title, as on the settings
/// pages of the big apps; or, [separated], each in a card of its own.
abstract interface class SListGroup implements Widget {
  /// [separated] for rows that each open a page of their own (a
  /// profile's), rather than the parts of one thing.
  const factory SListGroup({
    required List<Widget> children,
    String? title,
    bool separated,
    Key? key,
  }) = SListGroupMaterial;
}
