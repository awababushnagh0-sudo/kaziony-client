import 'package:flutter/widgets.dart';

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

@immutable
class ReceiptSpec {
  const ReceiptSpec({
    required this.lines,
    required this.totalLabel,
    required this.total,
    this.note,
  });

  final List<ReceiptLine> lines;
  final String totalLabel;

  /// Already written for people (`formatPrice`).
  final String total;

  /// Under the total: how it's paid.
  final String? note;
}

abstract interface class ReceiptRenderer {
  Widget render(BuildContext context, ReceiptSpec spec);
}
