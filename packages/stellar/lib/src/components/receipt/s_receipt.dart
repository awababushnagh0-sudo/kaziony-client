import 'package:flutter/widgets.dart';

import 's_receipt_material.dart';

/// One line of an [SReceipt]: how many of what, at what price.
@immutable
class ReceiptLine {
  const ReceiptLine({
    required this.quantity,
    required this.title,
    required this.amount,
    this.detail,
  });

  /// Shown first, bold: the pieces to hand over.
  final int quantity;
  final String title;

  /// Under [title]: the price of one ("7.5 LD each").
  final String? detail;

  /// The line's total, already written for people (`formatPrice`).
  final String amount;
}

/// A bill to check before taking the money, as at a till: a line per item
/// (how many, what, the line's total), a dashed rule, and the [total] in big
/// figures. The quantity and the total are the two numbers mistakes come
/// from, so they're the boldest.
abstract interface class SReceipt implements Widget {
  /// [total] is already written for people (`formatPrice`). [note] goes
  /// under the total: how it's paid ("In cash").
  const factory SReceipt({
    required List<ReceiptLine> lines,
    required String totalLabel,
    required String total,
    String? note,
    Key? key,
  }) = SReceiptMaterial;
}
