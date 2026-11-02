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

  /// Space between the table and the page edge, and between a box's edge
  /// and its text.
  static const _outer = 16.0;
  static const _inner = 8.0;

  /// The gap between two columns; in the header it holds a dividing line.
  static const _gap = 13.0;

  /// The space at the end of the header for the total.
  static const _totalWidth = 96.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(Radii.md);
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final visible = [
          for (final column in columns)
            if (constraints.crossAxisExtent >= column.minWidth) column,
        ];
        Widget row(
          Widget Function(TableColumn<T> column) cell, {
          bool dividers = false,
          Widget? end,
        }) => Row(
          children: [
            for (final (i, column) in visible.indexed) ...[
              if (i > 0)
                SizedBox(
                  width: _gap,
                  child: dividers
                      ? Center(
                          child: Container(
                            width: 1,
                            height: 16,
                            color: c.border,
                          ),
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

        final header = row(
          (column) => Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              column.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: context.style.text.tiny,
                fontWeight: SFontWeight.medium.value,
                color: c.textSubtle,
              ),
            ),
          ),
          dividers: true,
          end: Text(
            totalLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: context.style.text.tiny,
              color: c.textSubtle,
            ),
          ),
        );

        return SliverMainAxisGroup(
          slivers: [
            // Pinned, it hides the rows scrolling under it.
            PinnedHeaderSliver(
              child: ColoredBox(
                color: c.background,
                child: Container(
                  height: 36,
                  margin: const EdgeInsets.fromLTRB(_outer, 8, _outer, 4),
                  padding: const EdgeInsets.symmetric(horizontal: _inner),
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: radius,
                  ),
                  child: header,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(_outer, 0, _outer, 8),
              sliver: SliverList.separated(
                itemCount: rows.length,
                separatorBuilder: (_, _) =>
                    Divider(indent: _inner, endIndent: _inner, color: c.border),
                itemBuilder: (context, index) {
                  final item = rows[index];
                  final content = Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: _inner),
                    child: row((column) => column.cell(item)),
                  );
                  final onOpen = this.onOpen;
                  if (onOpen == null) return content;
                  // Hover and press fill the same rounded box as the header.
                  return InkWell(
                    borderRadius: radius,
                    hoverColor: c.primarySoft,
                    highlightColor: c.primarySoft,
                    splashFactory: NoSplash.splashFactory,
                    onTap: () => onOpen(item),
                    child: content,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
