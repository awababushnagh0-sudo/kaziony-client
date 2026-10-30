import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../illustration/s_illustration_renderer.dart';
import 's_stat_renderer.dart';

/// One of a store's numbers on a card that floats on the page, with a small
/// picture of what it counts. Put them in an [SStatGrid].
class SStatTile extends StatelessWidget {
  const SStatTile({
    required this.label,
    required this.value,
    required this.illustration,
    this.hint,
    this.urgent = false,
    this.onTap,
    super.key,
  });

  final String label;

  /// Already written for people (a count).
  final String value;
  final SIllustrations illustration;
  final String? hint;

  /// Shows [hint] in orange: something to act on soon.
  final bool urgent;

  /// Opens the list behind the number.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).stat.tile(
    context,
    StatTileSpec(
      label: label,
      value: value,
      illustration: illustration,
      hint: hint,
      urgent: urgent,
      onTap: onTap,
    ),
  );
}
