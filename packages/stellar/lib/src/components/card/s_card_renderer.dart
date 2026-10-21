import 'package:flutter/widgets.dart';

@immutable
class CardSpec {
  const CardSpec({required this.child, this.onTap, this.padded = true});

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;
}

abstract interface class CardRenderer {
  Widget render(BuildContext context, CardSpec spec);
}
