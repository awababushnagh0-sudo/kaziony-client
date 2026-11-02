import 'package:flutter/widgets.dart';

import '../illustration/s_illustration.dart';
import 's_stat_material.dart';

/// One of a store's numbers on a card that floats on the page, with a small
/// picture of what it counts. Put them in an [SStatGrid].
abstract interface class SStatTile implements Widget {
  /// [urgent] shows [hint] in orange: something to act on soon. [onTap]
  /// opens the list behind the number.
  const factory SStatTile({
    required String label,
    required String value,
    required Illustration illustration,
    String? hint,
    bool urgent,
    VoidCallback? onTap,
    Key? key,
  }) = SStatTileMaterial;
}
