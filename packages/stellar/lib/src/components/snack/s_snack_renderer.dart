import 'package:flutter/widgets.dart';

enum SnackTone { info, success, error }

abstract interface class SnackRenderer {
  void show(BuildContext context, String message, SnackTone tone);
}
