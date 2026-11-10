import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// The text field labelled [label]. Stellar widgets are interfaces drawn by
/// other classes, so they're found by subtype, not by exact type.
Finder textField(String label) =>
    find.ancestor(of: find.text(label), matching: find.bySubtype<STextInput>());

/// Where an [SAmountInput]'s amount is typed (an offer's price).
Finder amountField() => find.descendant(
  of: find.bySubtype<SAmountInput>(),
  matching: find.byType(EditableText),
);

/// Where the [index]th [SCountInput] on the page is typed (an offer's
/// pieces first).
Finder countField([int index = 0]) => find.descendant(
  of: find.bySubtype<SCountInput>().at(index),
  matching: find.byType(EditableText),
);
