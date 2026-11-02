import 'package:flutter/widgets.dart';

import 's_table_material.dart';

/// One column of an [STable] showing rows of [T].
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

/// The rows of a list, with a pinned header that ends with [totalLabel].
/// Made of slivers: put it in an SListPage.
abstract interface class STable<T> implements Widget {
  /// [totalLabel] is shown at the end of the header ("12 stores"), as in
  /// ERPNext. Rows are clickable when [onOpen] is set.
  const factory STable({
    required List<T> rows,
    required List<TableColumn<T>> columns,
    required String totalLabel,
    ValueChanged<T>? onOpen,
    Key? key,
  }) = STableMaterial<T>;
}

/// A table cell's text: muted, one line. [strong] for the column that names
/// the row, [ltr] for numbers, phones and emails.
abstract interface class SCellText implements Widget {
  const factory SCellText(String text, {bool strong, bool ltr, Key? key}) =
      SCellTextMaterial;
}
