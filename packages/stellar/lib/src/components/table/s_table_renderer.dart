import 'package:flutter/widgets.dart';

/// One column of a [TableSpec] showing rows of [T].
@immutable
class TableColumn<T> {
  const TableColumn({
    required this.label,
    required this.cell,
    this.flex = 2,
    this.minWidth = 0,
  });

  final String label;
  final Widget Function(T row) cell;
  final int flex;

  /// The column is hidden when the table is narrower than this.
  final double minWidth;
}

@immutable
class TableSpec<T> {
  const TableSpec({
    required this.rows,
    required this.columns,
    required this.totalLabel,
    this.onOpen,
  });

  final List<T> rows;
  final List<TableColumn<T>> columns;

  /// Shown at the end of the header ("12 stores"), as in ERPNext.
  final String totalLabel;

  /// Rows are clickable when set.
  final ValueChanged<T>? onOpen;
}

abstract interface class TableRenderer {
  /// Slivers, for a list page.
  Widget render<T>(BuildContext context, TableSpec<T> spec);

  /// One table cell's text: muted, one line. [strong] for the column that
  /// names the row, [ltr] for numbers, phones and emails.
  Widget cellText(BuildContext context, String text, {bool strong, bool ltr});
}
