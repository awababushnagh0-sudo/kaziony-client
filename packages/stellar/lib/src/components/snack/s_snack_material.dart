import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import 's_snack.dart';

enum _Tone { info, success, error }

/// [SSnack], shown with Material's [SnackBar].
abstract final class SSnackMaterial {
  static void info(BuildContext context, String message) =>
      _show(context, message, _Tone.info);

  static void success(BuildContext context, String message) =>
      _show(context, message, _Tone.success);

  static void error(BuildContext context, String message) =>
      _show(context, message, _Tone.error);

  static void _show(BuildContext context, String message, _Tone tone) {
    final colors = context.colors;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: switch (tone) {
            _Tone.info => colors.text,
            _Tone.success => colors.success,
            _Tone.error => colors.danger,
          },
        ),
      );
  }
}
