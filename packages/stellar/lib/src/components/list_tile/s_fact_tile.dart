import 'package:flutter/widgets.dart';

import 's_list_tile_material.dart';

/// A setting and its value in an [SListGroup], read at a glance: the name
/// quiet, the [value] in bold ("Hold time · 60 min").
abstract interface class SFactTile implements Widget {
  const factory SFactTile({
    required String label,
    required String value,
    Key? key,
  }) = SFactTileMaterial;
}
