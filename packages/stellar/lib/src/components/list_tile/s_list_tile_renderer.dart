import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

@immutable
class ListTileSpec {
  const ListTileSpec({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final SIcons? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
}

abstract interface class ListTileRenderer {
  Widget render(BuildContext context, ListTileSpec spec);
}
