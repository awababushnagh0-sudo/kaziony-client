import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_table.dart';

/// [SCellText] as a Material [Text].
class SCellTextMaterial extends StatelessWidget implements SCellText {
  const SCellTextMaterial(
    this.text, {
    this.strong = false,
    this.ltr = false,
    super.key,
  });

  final String text;
  final bool strong;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textDirection: ltr ? TextDirection.ltr : null,
      // Left-to-right text still lines up with the page's start edge.
      textAlign: ltr
          ? (rtl ? TextAlign.right : TextAlign.left)
          : TextAlign.start,
      style: strong
          ? TextStyle(
              fontSize: context.style.text.body,
              fontWeight: SFontWeight.medium.value,
              color: c.text,
            )
          : TextStyle(fontSize: context.style.text.small, color: c.textMuted),
    );
  }
}

/// Space between the table and the page edge, and between a box's edge and
/// its text.
const _outer = 16.0;
const _inner = 8.0;

/// The gap between two columns; in the header it holds a dividing line.
const _gap = 13.0;

/// The space at the end of the header for the total.
const _totalWidth = 96.0;
const _headerHeight = 36.0;
const _rowHeight = 44.0;

/// What both tables draw for a [width]: the columns that fit, the header's
/// rounded gray box, a row that lights up on hover, and the line between
/// rows.
class _TableParts<T> {
  _TableParts(this.context, this.columns, this.totalLabel, double width)
    : visible = [
        for (final column in columns)
          if (width >= column.minWidth) column,
      ];

  final BuildContext context;
  final List<TableColumn<T>> columns;
  final String totalLabel;
  final List<TableColumn<T>> visible;

  Color get _background => context.colors.primarySoft;
  BorderRadius get _radius => BorderRadius.circular(Radii.md);

  Widget _line(
    Widget Function(TableColumn<T> column) cell, {
    bool dividers = false,
    Widget? end,
  }) {
    final c = context.colors;
    return Row(
      children: [
        for (final (i, column) in visible.indexed) ...[
          if (i > 0)
            SizedBox(
              width: _gap,
              child: dividers
                  ? Center(
                      child: Container(width: 1, height: 16, color: c.border),
                    )
                  : null,
            ),
          Expanded(flex: column.flex, child: cell(column)),
        ],
        const SizedBox(width: _gap),
        // Each row keeps this space empty, so the columns line up.
        SizedBox(width: _totalWidth, child: end),
      ],
    );
  }

  Widget header() {
    final c = context.colors;
    final style = TextStyle(
      fontSize: context.style.text.tiny,
      color: c.textSubtle,
    );
    return Container(
      height: _headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: _inner),
      decoration: BoxDecoration(color: _background, borderRadius: _radius),
      child: _line(
        (column) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            column.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(fontWeight: SFontWeight.medium.value),
          ),
        ),
        dividers: true,
        end: Text(
          totalLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: style,
        ),
      ),
    );
  }

  Widget row(T item, ValueChanged<T>? onOpen) {
    final content = Container(
      height: _rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: _inner),
      child: _line((column) => column.cell(item)),
    );
    if (onOpen == null) return content;
    // Hover and press fill the same rounded box as the header.
    return InkWell(
      borderRadius: _radius,
      hoverColor: _background,
      highlightColor: _background,
      splashFactory: NoSplash.splashFactory,
      onTap: () => onOpen(item),
      child: content,
    );
  }

  Widget divider() =>
      Divider(indent: _inner, endIndent: _inner, color: context.colors.border);
}

/// ERPNext-style [STable]: a pinned header in a rounded gray box, rows that
/// light up on hover, and the total at the end of the header.
class STableMaterial<T> extends StatelessWidget implements STable<T> {
  const STableMaterial({
    required this.rows,
    required this.columns,
    required this.totalLabel,
    this.onOpen,
    super.key,
  });

  final List<T> rows;
  final List<TableColumn<T>> columns;

  /// Shown at the end of the header ("12 stores"), as in ERPNext.
  final String totalLabel;

  /// Rows are clickable when set.
  final ValueChanged<T>? onOpen;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final parts = _TableParts(
        context,
        columns,
        totalLabel,
        constraints.crossAxisExtent,
      );
      return SliverMainAxisGroup(
        slivers: [
          // Pinned, it hides the rows scrolling under it.
          PinnedHeaderSliver(
            child: ColoredBox(
              color: context.colors.background,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(_outer, 8, _outer, 4),
                child: parts.header(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(_outer, 0, _outer, 8),
            sliver: SliverList.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => parts.divider(),
              itemBuilder: (context, index) => parts.row(rows[index], onOpen),
            ),
          ),
        ],
      );
    },
  );
}

/// [STable.box]: the same header and rows in a column, for a page that
/// already scrolls and has its own padding.
class STableBoxMaterial<T> extends StatelessWidget implements STable<T> {
  const STableBoxMaterial({
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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final parts = _TableParts(
        context,
        columns,
        totalLabel,
        constraints.maxWidth,
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          parts.header(),
          const SizedBox(height: 4),
          for (final (i, item) in rows.indexed) ...[
            if (i > 0) parts.divider(),
            parts.row(item, onOpen),
          ],
        ],
      );
    },
  );
}
