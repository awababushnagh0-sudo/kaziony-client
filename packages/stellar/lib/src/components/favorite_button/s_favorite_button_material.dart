import 'package:flutter/material.dart';

import 's_favorite_button.dart';
import 's_heart_material.dart';

/// [SFavoriteButton], drawn as a Material [IconButton].
class SFavoriteButtonMaterial extends StatelessWidget
    implements SFavoriteButton {
  const SFavoriteButtonMaterial({
    required this.saved,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final bool saved;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    isSelected: saved,
    icon: HeartMaterial(filled: saved),
  );
}
