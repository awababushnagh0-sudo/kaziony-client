import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The field labelled [label], by the name screen readers give it: the
/// dashboard draws the label above the field, with a red " *" when it's
/// required, so the label's text alone doesn't match.
Finder textField(String label) => find.byWidgetPredicate(
  (widget) => widget is Semantics && widget.properties.label == label,
);
