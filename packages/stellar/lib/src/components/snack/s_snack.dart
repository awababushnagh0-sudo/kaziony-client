import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_snack_renderer.dart';

/// Short message at the bottom of the screen.
abstract final class SSnack {
  static void info(BuildContext context, String message) =>
      StellarKit.of(context).snack.show(context, message, SnackTone.info);

  static void success(BuildContext context, String message) =>
      StellarKit.of(context).snack.show(context, message, SnackTone.success);

  static void error(BuildContext context, String message) =>
      StellarKit.of(context).snack.show(context, message, SnackTone.error);
}
