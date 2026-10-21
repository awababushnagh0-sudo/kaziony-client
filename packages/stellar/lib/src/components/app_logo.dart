import 'package:flutter/widgets.dart';

import '../kit/stellar_kit.dart';

/// The app's mark: the first letter of [name] on the primary color.
/// Stands in until there is a real logo.
class AppLogo extends StatelessWidget {
  const AppLogo({required this.name, this.size = 36, super.key});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final letter = name.trim().isEmpty ? '?' : name.trim().characters.first;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(size * 0.25),
        ),
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
            color: colors.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.5,
            height: 1,
          ),
        ),
      ),
    );
  }
}
