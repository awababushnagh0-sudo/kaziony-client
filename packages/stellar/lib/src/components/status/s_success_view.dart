import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_status_material.dart';

/// Fills the area after something finished well, like a pickup at the
/// counter: a big green tick, [title] and [message]. The next step goes in
/// the page's bottom button.
abstract interface class SSuccessView implements Widget {
  const factory SSuccessView({
    required String title,
    String? message,
    SIcons icon,
    Key? key,
  }) = SSuccessViewMaterial;
}
