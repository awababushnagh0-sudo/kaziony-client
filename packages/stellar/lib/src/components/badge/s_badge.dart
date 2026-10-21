import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_badge_renderer.dart';

/// A small rounded status label, like ERPNext's indicator pills.
class SBadge extends StatelessWidget {
  const SBadge(this.label, {this.tone = BadgeTone.neutral, super.key});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).badge.render(context, label, tone);
}
