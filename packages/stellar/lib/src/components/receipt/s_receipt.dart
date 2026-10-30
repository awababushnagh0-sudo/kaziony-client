import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_receipt_renderer.dart';

/// A bill to check before taking the money, as at a till: a line per item
/// (how many, what, the line's total), a dashed rule, and the [total] in big
/// figures. The quantity and the total are the two numbers mistakes come
/// from, so they're the boldest.
class SReceipt extends StatelessWidget {
  const SReceipt({
    required this.lines,
    required this.totalLabel,
    required this.total,
    this.note,
    super.key,
  });

  final List<ReceiptLine> lines;
  final String totalLabel;

  /// Already written for people (`formatPrice`).
  final String total;

  /// Under the total: how it's paid ("In cash").
  final String? note;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).receipt.render(
    context,
    ReceiptSpec(lines: lines, totalLabel: totalLabel, total: total, note: note),
  );
}
