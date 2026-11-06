import 'package:flutter/widgets.dart';

import 's_divider_material.dart';

/// A thin line between the parts of a page, edge to edge, or kept off the
/// sides ([inset]) between rows.
abstract interface class SDivider implements Widget {
  const factory SDivider({bool inset, Key? key}) = SDividerMaterial;
}
