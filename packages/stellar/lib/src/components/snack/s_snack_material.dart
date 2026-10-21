import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import 's_snack_renderer.dart';

class MaterialSnackRenderer implements SnackRenderer {
  const MaterialSnackRenderer();

  @override
  void show(BuildContext context, String message, SnackTone tone) {
    final colors = context.colors;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: switch (tone) {
            SnackTone.info => colors.text,
            SnackTone.success => colors.success,
            SnackTone.error => colors.danger,
          },
        ),
      );
  }
}
