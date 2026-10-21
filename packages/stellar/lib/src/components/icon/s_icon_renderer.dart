import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_icon.dart';

abstract interface class IconRenderer {
  Widget render(
    BuildContext context,
    SIcons icon,
    SIconSize size,
    SColor color,
  );
}
