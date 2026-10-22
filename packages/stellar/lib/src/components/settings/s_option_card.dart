import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_settings_renderer.dart';

/// Choices laid out as [SOptionCard]s, three to a row.
class SOptionGrid extends StatelessWidget {
  const SOptionGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).settings.optionGrid(context, children);
}

/// One choice, ERPNext-style: a picture of the app window above, the
/// [label] and a radio circle below; the chosen card has a dark border.
class SOptionCard extends StatelessWidget {
  const SOptionCard({
    required this.label,
    required this.preview,
    required this.selected,
    required this.onTap,
    this.direction,
    super.key,
  });

  final String label;
  final WindowPreview preview;
  final bool selected;
  final VoidCallback onTap;

  /// Lays the preview out in this direction, not the page's.
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).settings.optionCard(
        context,
        OptionCardSpec(
          label: label,
          preview: preview,
          selected: selected,
          onTap: onTap,
          direction: direction,
        ),
      );
}
