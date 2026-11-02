import 'package:flutter/widgets.dart';

import 's_snack_material.dart';

/// Short message at the bottom of the screen.
abstract final class SSnack {
  static void info(BuildContext context, String message) =>
      SSnackMaterial.info(context, message);

  static void success(BuildContext context, String message) =>
      SSnackMaterial.success(context, message);

  static void error(BuildContext context, String message) =>
      SSnackMaterial.error(context, message);
}
