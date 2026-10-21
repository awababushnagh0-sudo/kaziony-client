import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';

class SLoadingView extends StatelessWidget {
  const SLoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).status.loading(context, message: message);
}
