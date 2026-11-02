import 'package:flutter_test/flutter_test.dart';
import 'package:stellar/stellar.dart';

/// The text field labelled [label]. Stellar widgets are interfaces drawn by
/// other classes, so they're found by subtype, not by exact type.
Finder textField(String label) =>
    find.ancestor(of: find.text(label), matching: find.bySubtype<STextInput>());
