import 'package:flutter/widgets.dart';

import 's_list_tile_material.dart';

/// A row of an [SListGroup] that's ticked or not: a square box at its
/// start, then the [title]. [subtitle] says what the tick means, green
/// while ticked ("Shows here") and orange while not ("Won't show here"),
/// so taking something away reads as what it is.
abstract interface class SCheckTile implements Widget {
  const factory SCheckTile({
    required String title,
    required bool checked,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    Key? key,
  }) = SCheckTileMaterial;
}
