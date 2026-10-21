import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_table_renderer.dart';

/// The rows of a list, with a pinned header that ends with [totalLabel].
/// Made of slivers: put it in an SListPage.
class STable<T> extends StatelessWidget {
  const STable({
    required this.rows,
    required this.columns,
    required this.totalLabel,
    this.onOpen,
    super.key,
  });

  final List<T> rows;
  final List<TableColumn<T>> columns;
  final String totalLabel;
  final ValueChanged<T>? onOpen;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).table.render<T>(
    context,
    TableSpec<T>(
      rows: rows,
      columns: columns,
      totalLabel: totalLabel,
      onOpen: onOpen,
    ),
  );
}

/// A table cell's text. [strong] for the column that names the row, [ltr]
/// for numbers, phones and emails.
class SCellText extends StatelessWidget {
  const SCellText(
    this.text, {
    this.strong = false,
    this.ltr = false,
    super.key,
  });

  final String text;
  final bool strong;
  final bool ltr;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).table
          .cellText(context, text, strong: strong, ltr: ltr);
}
