import 'package:flutter/widgets.dart';

import 's_tokens.dart';

/// Provides the look and colors to every component below it.
/// Set up by SApp.
class StellarScope extends InheritedWidget {
  const StellarScope({
    required this.style,
    required this.colors,
    required super.child,
    super.key,
  });

  final StellarStyle style;
  final StellarColors colors;

  static StellarScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StellarScope>();
    assert(scope != null, 'No StellarScope found. Wrap the app in SApp.');
    return scope!;
  }

  @override
  bool updateShouldNotify(StellarScope oldWidget) =>
      style != oldWidget.style || colors != oldWidget.colors;
}

extension StellarContext on BuildContext {
  StellarColors get colors => StellarScope.of(this).colors;

  /// The app's look, for the few widgets whose layout differs between
  /// the phone apps and the dashboard.
  StellarStyle get style => StellarScope.of(this).style;
}
