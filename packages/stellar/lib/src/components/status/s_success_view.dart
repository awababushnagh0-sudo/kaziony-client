import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_status_renderer.dart';

/// Fills the area after something finished well, like a pickup at the
/// counter: a big green tick, [title] and [message]. The next step goes in
/// the page's bottom button.
class SSuccessView extends StatelessWidget {
  const SSuccessView({
    required this.title,
    this.message,
    this.icon = SIcons.success,
    super.key,
  });

  final String title;
  final String? message;
  final SIcons icon;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).status
      .success(context, StatusSpec(title: title, message: message, icon: icon));
}
