import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_card_renderer.dart';

class SCard extends StatelessWidget {
  const SCard({required this.child, this.onTap, this.padded = true, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).card
      .render(context, CardSpec(child: child, onTap: onTap, padded: padded));
}
