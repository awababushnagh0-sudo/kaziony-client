import 'package:flutter/widgets.dart';

import 's_input_material.dart';

/// A search box above a list: a gray pill that filters as the user types.
abstract interface class SSearchField implements Widget {
  /// [autofocus] opens the keyboard at once: on a page that is only for
  /// searching. [onSubmitted] runs on the keyboard's search key. Pass a
  /// [controller] to change the words from outside (a recent search
  /// tapped); it replaces [initialValue]. Once there are words, an × at the
  /// end empties the field and calls [onChanged] with ''.
  const factory SSearchField({
    required String hint,
    required ValueChanged<String> onChanged,
    ValueChanged<String>? onSubmitted,
    TextEditingController? controller,
    String initialValue,
    bool autofocus,
    Key? key,
  }) = SSearchFieldMaterial;
}
