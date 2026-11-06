import 'package:flutter/widgets.dart';

import 's_divider_material.dart';

/// A thin line between the parts of a page, edge to edge, or kept off the
/// sides ([inset]) between rows.
abstract interface class SDivider implements Widget {
  const factory SDivider({bool inset, Key? key}) = SDividerMaterial;

  /// A wide gray band edge to edge, where a page moves on to a part of its
  /// own (from a store's branches to its offers): plainer to see than a
  /// line.
  const factory SDivider.band({Key? key}) = SDividerMaterial.band;

  /// A dashed line, as across a ticket: between a pass's head and its
  /// code.
  const factory SDivider.dashed({Key? key}) = SDashedDividerMaterial;
}
