import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_alert_renderer.dart';

/// A red box that stops the person before a mistake: what's wrong in bold
/// ([title]), and what to do about it ([message]). Read out by screen
/// readers as soon as it shows.
class SAlert extends StatelessWidget {
  const SAlert({required this.title, this.message, super.key});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).alert
          .render(context, AlertSpec(title: title, message: message));
}
