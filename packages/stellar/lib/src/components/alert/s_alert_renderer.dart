import 'package:flutter/widgets.dart';

/// Something that stops the person: what's wrong and what to do.
@immutable
class AlertSpec {
  const AlertSpec({required this.title, this.message});

  final String title;
  final String? message;
}

abstract interface class AlertRenderer {
  Widget render(BuildContext context, AlertSpec spec);
}
