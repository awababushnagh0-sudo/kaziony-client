import 'package:flutter/widgets.dart';

import 's_input_material.dart';

/// A search box above a list: a gray pill that filters as the user types.
abstract interface class SSearchField implements Widget {
  /// [autofocus] opens the keyboard at once: on a page that is only for
  /// searching.
  const factory SSearchField({
    required String hint,
    required ValueChanged<String> onChanged,
    String initialValue,
    bool autofocus,
    Key? key,
  }) = SSearchFieldMaterial;

  /// Looks the same but opens the search elsewhere ([onTap]): the search
  /// bar at the top of a home page.
  const factory SSearchField.button({
    required String hint,
    required VoidCallback onTap,
    Key? key,
  }) = SSearchFieldMaterial.button;
}
