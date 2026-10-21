import 'package:flutter/widgets.dart';

enum BadgeTone { success, warning, danger, neutral }

abstract interface class BadgeRenderer {
  Widget render(BuildContext context, String label, BadgeTone tone);
}
