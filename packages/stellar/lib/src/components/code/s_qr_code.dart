import 'package:flutter/widgets.dart';

import 's_code_material.dart';

/// A QR code of data for a counter to scan (a pickup code), dark on white
/// in both themes so every scanner reads it, with a quiet margin.
abstract interface class SQrCode implements Widget {
  /// [label] says what it is, for screen readers ("QR code to show at the
  /// counter").
  const factory SQrCode(String data, {required String label, Key? key}) =
      SQrCodeMaterial;
}
