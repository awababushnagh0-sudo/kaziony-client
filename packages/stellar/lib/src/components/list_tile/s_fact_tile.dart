import 'package:flutter/widgets.dart';

import 's_list_tile_material.dart';

/// A fact and its value in an [SListGroup], read at a glance: the [label]
/// quiet at the start, the [value] in bold at the end ("Hold time · 60
/// min"). Every read-only "name: value" row in the apps is one of these, so
/// they all look alike; a long value wraps at the end.
abstract interface class SFactTile implements Widget {
  const factory SFactTile({
    required String label,
    required String value,
    Key? key,
  }) = SFactTileMaterial;
}
