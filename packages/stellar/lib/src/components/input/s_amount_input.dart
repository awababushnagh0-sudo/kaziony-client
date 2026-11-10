import 'package:flutter/widgets.dart';

import 's_amount_material.dart';

/// An amount of money, large in the middle of the page with the currency
/// beside it and no box around it: the one number a form is about (an
/// offer's price). Bound to the control [controlName] (a `String`) of the
/// enclosing SForm; it takes only digits and one decimal point, 3 decimals
/// at most, Arabic digits turned Western.
abstract interface class SAmountInput implements Widget {
  /// Under the amount: [was] crossed out (the regular price, "15.000 LD")
  /// and [badge] beside it (the discount, "-50%"); what's wrong in their
  /// place once the amount is checked. [validationMessages] are for the
  /// screen's own checks.
  ///
  /// [limit] ("8.000") is what the amount must stay under: what would
  /// reach it isn't typed, and [limitMessage] says why in red under the
  /// amount until the next thing typed is taken (an offer's price under
  /// the regular one, or it's no discount).
  const factory SAmountInput({
    required String controlName,
    required String label,
    String? was,
    String? badge,
    String? limit,
    String? limitMessage,
    Map<String, String Function(Object error)> validationMessages,
    Key? key,
  }) = SAmountInputMaterial;
}
