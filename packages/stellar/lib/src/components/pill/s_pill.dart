import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import 's_pill_material.dart';

/// A small toggle (filters, page size): outlined, and filled with
/// `activeColor` when `selected`.
abstract interface class SPill implements Widget {
  /// [activeColor] is the fill when [selected] (the primary color by
  /// default); the words on it turn light or dark to read. [icon] goes
  /// after the [label].
  const factory SPill({
    required String label,
    required bool selected,
    VoidCallback? onTap,
    SIcons? icon,
    SColor activeColor,
    Key? key,
  }) = SPillMaterial;
}
