import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_code_renderer.dart';

/// A QR code of [data] for a counter to scan (a pickup code), dark on
/// white in both themes so every scanner reads it, with a quiet margin.
class SQrCode extends StatelessWidget {
  const SQrCode(this.data, {required this.label, super.key});

  final String data;

  /// What it is, for screen readers ("QR code to show at the counter").
  final String label;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).code
          .qr(context, QrCodeSpec(data: data, label: label));
}
