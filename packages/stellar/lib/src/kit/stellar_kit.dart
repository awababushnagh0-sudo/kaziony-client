import 'package:flutter/widgets.dart';

import '../tokens/tokens.dart';
import 'contracts.dart';

/// A complete set of renderers. Provide another kit to restyle the apps.
@immutable
class StellarKit {
  const StellarKit({
    required this.button,
    required this.textInput,
    required this.scaffold,
    required this.text,
    required this.card,
    required this.listTile,
    required this.status,
    required this.snack,
  });

  final ButtonRenderer button;
  final TextInputRenderer textInput;
  final ScaffoldRenderer scaffold;
  final TextRenderer text;
  final CardRenderer card;
  final ListTileRenderer listTile;
  final StatusRenderer status;
  final SnackRenderer snack;

  static StellarKit of(BuildContext context) => StellarScope.of(context).kit;
}

/// Provides the active kit and colors to every component below it.
/// Set up by StellarApp.
class StellarScope extends InheritedWidget {
  const StellarScope({
    required this.kit,
    required this.colors,
    required super.child,
    super.key,
  });

  final StellarKit kit;
  final StellarColors colors;

  static StellarScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StellarScope>();
    assert(scope != null, 'No StellarScope found. Wrap the app in StellarApp.');
    return scope!;
  }

  @override
  bool updateShouldNotify(StellarScope oldWidget) =>
      kit != oldWidget.kit || colors != oldWidget.colors;
}

extension StellarContext on BuildContext {
  StellarColors get colors => StellarScope.of(this).colors;
}
